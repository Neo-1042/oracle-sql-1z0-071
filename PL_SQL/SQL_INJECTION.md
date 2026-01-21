# SQL Injection

SQL injection happens when the application submits a textual
SQL query to the DB engine for processing
by means of simple string concatenation, **embedding 
UNTRUSTED data**.

The problem is that there is no separation between DATA 
and CODE. Furthermore, the embedded data is neither checked
for data type validity nor subsequently sanitized.

Thus, the untrusted data (where you might expect a user's
information, countries, etc.) could contain SQL commands, or
or modify the intended query. The database would
interpret the altered query and commands as if they
originated from the application as its normal operation,
and execute them accordingly.

> The attacker can exploit this vulnerability either by
modifying the URL, or by submitting malicious data in the
user input or other request fields.

## General Recommendations

- Validate all untrusted data, regardless of the source.
- Preferrably, use ORMs (Object-Relational Mappings)
- Validation should be based on a **white list**, rather than
a black list.
- In particular, check for:
    - Data type
    - Size
    - Range
    - Format
    - Expected values
- Adhere to the **Principle of Least Privilege**
- Do NOT use dynamically-concatenated strings to
construct SQL queries.
- Prefer using DB **STORED PROCEDUREs** for all data access,
instead of ad-hoc (on the fly) dynamic queries.
- Use secure db components, such as **parameterized queries**
and **object bindings**. 

### Vulnerable SQL Code

```sql
CREATE OR REPLACE PROCEDURE sp_vulnerable (
    vname IN VARCHAR2
    , vresult OUT VARCHAR2
) AS
    vsql VARCHAR2(4000);
BEGIN
    vsql := 'SELECT name FROM customers WHERE name = ''' || vname || ''''; -- SECURITY RISK!!
END;
/
```

### Safe SQL Code

```sql
CREATE OR REPLACE PROCEDURE sp_example(
    vname IN VARCHAR2
    ,vresult OUT VARCHAR2
) AS
    vsql VARCHAR2(4000);
BEGIN
    vsql := 'SELECT id FROM tbl_customers WHERE name = :1';
    EXECUTE IMMEDIATE vsql INTO vresult USING vname;
END;
/
```

\* Interesting: XML databases can have similar problems:
e.g. XPath and XQuery injection.

# A Common SQL Injection Example with Java

```java
String query = "SELECT account_balance FROM user_data WHERE user name = " 
    + request.getParameter("customerName");

try {
    Statement statement = connection.createStatement(...);
    ResultSet results = statement.executeQuery(query);
}
```

## Primary Defenses

1. Use **Prepared Statements** with Parameterized Queries.
2. Use of Properly Constructed STORED PROCEDURES.
3. White List Validation.
4. (Last Resort) Escaping all user input.

# Second Order SQL Injection Example
## PL/SQL Using Database Values in an SQL Statement Can Result in SQL Injection

```sql
IF if_number(p_id) THEN
    vsql_1 := 'SELECT name FROM product WHERE id = ''' || p_id || '''';
    EXECUTE IMMEDIATE vsql_1 INTO p_name;

    vsql_2 := 'SELECT client_id FROM invoices WHERE product_name = ''' || p_name || '''';
    EXECUTE IMMEDIATE vsql_2 INTO client_id;

    DBMS_OUTPUT.PUT_LINE('Client ID = ' || client_id);
END IF;
```

# Parameter Tampering with PL/SQL

Parameter Tampering is a type of security vulnerability
where a malicious user **manipulates parameters** sent
from a client (UI, URL, API request, input form, JSON)
to the server-side logic, including PL/SQL FUNCTIONS or
PROCEDURES.

Attackers might modify the following parameters:

- IDs (employee_id, customer_id)
- Flags (is_admin, price, has_discount)
- JSON fields
- Hidden input fields
- Query-string values in APEX apps

[+] PL/SQL often powers:

- Oracle APEX apps
- REST Data Services (ORDS)
- Custom backend APIs
- **Enterprise apps where PL/SQL controls business logic**

Because PL/SQL often runs with powerful database privileges,
**parameter tampering** can lead to:

\* Unauthorized data access  
\* Data modification  
\* Escalation of privileges  
\* Bypassing business rules  

# update_salary PL/SQL example

```sql
PROCEDURE update_salary (
    p_emp_id    IN NUMBER,
    p_amount    IN NUMBER
)
IS
BEGIN
    UPDATE employees
    SET salary = p_amount
    WHERE employee_id = p_emp_id;
END;
/
```

If the frontend sends:
```json
    "p_emp_id" : 101,
    "p_amount" : 5000
```
an attacker could tamper the request to:
```json
    "p_emp_id" : 1,
    "p_amount" : 999999
```
if the PL/SQL code does NOT:
- Check the user's authorization level
- Limit the allowed salary range
- Validate that they can modify employee_id = 1

# How to Protect PL/SQL Code from Parameter Tampering

1. Validate inputs:
```sql
IF p_amount < 0 OR p_amount > 20000 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid salary amount'.);
END IF;
```

2. Never trust client logic

3. Use **Definer's vs Invoker's** Rights Properly

- Definer's rights procedures run with the **schema's privileges**  
- Invoker's rights run with the caller's privileges.

Using invoker's rights (AUTHID CURRENT_USER) reduces risk in
multi-tenant or multi-user systems.

4. Implement Authorization Checks

```sql
IF NOT security_pkg.can_update_emp(v_current_user, p_emp_id) THEN
    RAISE_APPLICATION_ERROR(-20002, 'Unauthorized');
END IF;
```

5. Use Strong Database Constraints

- Foreign Keys
- CHECK constraints
- Row-level security (Fine-Grained Access Control / VPD)

6. Use Bind Variables to Prevent SQL Injection

Not exactly the same as parameter tampering, but often
related. PL/SQL naturally uses bind variables, but when
writing SQL, one must be careful:

```sql
-- Bind variable :id
EXECUTE IMMEDIATE 'SELECT ... WHERE id = :id' USING p_id;
```

**Never concatenate** unchecked values
**inside dynamic SQL**. 

## Safe PL/SQL with Best Practices

```sql
-- %TYPE ---> Anchored Data Type
-- %TYPE tells Oracle:
-- "Use the exact same data type as the employee_id column
-- in the employees table"
CREATE OR REPLACE PROCEDURE secure_update (
    p_emp_id    IN employees.employee_id%TYPE,
    p_amount    IN employees.salary%TYPE,
    p_user_id   IN users.user_id%TYPE
)
IS
BEGIN
    -- 1] Validate input format
    IF p_amount < 0 OR p_amount > 20000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid amount');
    END IF;

    -- 2] Validate user authorization
    IF NOT security_pkg.can_update(p_user_id, p_emp_id) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Not authorized');
    END IF;

    -- 3] Apply business logic
    UPDATE employees
    SET salary = p_amount
    WHERE employee_id = p_emp_id;

END secure_update;
/
```