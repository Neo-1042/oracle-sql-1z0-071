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