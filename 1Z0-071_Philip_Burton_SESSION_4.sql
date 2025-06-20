---------------------------------------------------------------------------------------------------
-- 1Z0-071 Oracle SQL Database
-- SESSION 4
-- 02/MAY/2025
---------------------------------------------------------------------------------------------------
-- SET operators to combine multiple queries into a single query (UNION, UNION ALL)
-- Control the order of rows returned
-- MERGE rows in a table
-- Ampersand (&) substitution to restrict and sort output at runtime
-- OVER: Analytical functions (PERCENTILE_CONT, STDDEV, LAG, LEAD) in SELECT statements
---------------------------------------------------------------------------------------------------
-- CREATING VIEWS
-- Encapsulate the 'SELECT' statements to be used in the future

SELECT d.department, t.employee_number, t.date_of_transaction, t.amount AS total_amount
FROM tbl_department d
	LEFT JOIN tbl_employee e    ON d.department = e.department
	LEFT JOIN tbl_transaction t ON e.employee_number = t.employee_number
WHERE t.employee_number BETWEEN 120 AND 139 -- We don't want to give a user this code so that 
-- he can change it at will
ORDER BY d.department, t.employee_number
;

SELECT d.department, t.employee_number AS empnum, SUM(t.amount) AS total_amount
FROM tbl_department d
	LEFT JOIN tbl_employee e    ON d.department = e.department
	LEFT JOIN tbl_transaction t ON e.employee_number = t.employee_number
GROUP BY d.department, t.employee_number
ORDER BY d.department, t.employee_number
;

-- There are four main reasons to use views:
-- 1] Restrict the user to specific rows
-- 2] Restrict the user to specific columns
-- 3] Creating summaries
-- 4] Join columns from multiple tables to group logically related information

CREATE VIEW vw_department1 AS (
	SELECT d.department, t.employee_number, t.date_of_transaction, t.amount AS total_amount
	FROM tbl_department d
		LEFT JOIN tbl_employee e    ON d.department = e.department
		LEFT JOIN tbl_transaction t ON e.employee_number = t.employee_number
	WHERE t.employee_number BETWEEN 120 AND 139 -- We don't want to give a user this code so that 
	-- he can change it at will
	ORDER BY d.department, t.employee_number -- Oracle SQL allows ORDER BY within views
);

CREATE VIEW vw_dept_summary AS (
	SELECT d.department, t.employee_number AS empnum, SUM(t.amount) AS total_amount
	FROM tbl_department d
		LEFT JOIN tbl_employee e    ON d.department = e.department
		LEFT JOIN tbl_transaction t ON e.employee_number = t.employee_number
	GROUP BY d.department, t.employee_number
	ORDER BY d.department, t.employee_number
);

-- * Note: In this way, views are automatically created like so:
CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYS"."vw_dept_summary" ("DEPARTMENT", "EMPLOYEE_NUMBER") AS ...
---------------------------------------------------------------------------------------------------
-- Altering or dropping VIEWs
DROP VIEW vw_department1;
DROP VIEW vw_dept_summary;
---------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_department1 AS (
	SELECT d.department, t.employee_number, t.date_of_transaction
		  ,t.amount AS total_amount ,t.amount * 2 AS double_amount
	FROM tbl_department d
		LEFT JOIN tbl_employee e    ON d.department = e.department
		LEFT JOIN tbl_transaction t ON e.employee_number = t.employee_number
	WHERE t.employee_number BETWEEN 120 AND 139 -- We don't want to give a user this code so that 
	-- he can change it at will
	ORDER BY d.department, t.employee_number -- Oracle SQL allows ORDER BY within views
);
---------------------------------------------------------------------------------------------------
-- DML on VIEWs
-- INSERT INTO vw ... 
-- Error: Cannot modify a column which maps to a non key-preserved table
-- Action: Modify the underlying base tables directly
-- Alternative solution: analyze and fix the PK/FK constraints on the underlying tables

ALTER TABLE tbl_department
ADD CONSTRAINT pk_tbl_department PRIMARY KEY (department)
ENABLE NOVALIDATE;
-- INSERT INTO vw... works, but it's not recommended. Better to insert directly into the underlying tables

UPDATE vw_by_department
SET employee_number = 142
WHERE employee_number = 132; -- Not in the range of the view. It is allowed :O

-- If you don't want people messing with the view and its underlying tables, add WITH READ ONLY to the end:
CREATE OR REPLACE VIEW vw_by_department AS
	SELECT d.department, t.employee_number, t.date_of_transaction
		  ,t.amount AS total_amount ,t.amount * 2 AS double_amount
	FROM tbl_department d
		LEFT JOIN tbl_employee e    ON d.department = e.department
		LEFT JOIN tbl_transaction t ON e.employee_number = t.employee_number
	WHERE t.employee_number BETWEEN 120 AND 139 -- We don't want to give a user this code so that 
	-- he can change it at will
	ORDER BY d.department, t.employee_number
WITH READ ONLY
;

-- If you want to people to modify info only in the range BETWEEN 120 AND 139:
CREATE OR REPLACE VIEW vw_by_department AS (
	SELECT t.employee_number, t.date_of_transaction, t.amount AS total_amount
	FROM tbl_transaction t
	WHERE t.employee_number	BETWEEN 120 AND 139
) WITH CHECK OPTION CONSTRAINT constraint_vw_by_department
;
---------------------------------------------------------------------------------------------------
-- Invisible Columns in Views
CREATE TABLE tbl_dummy (
	"invisible_number" NUMBER(6,0) INVISIBLE GENERATED ALWAYS AS IDENTITY
	,CONSTRAINT "pk_tbl_dummy2" PRIMARY KEY ("invisible_number")
);

SELECT invisible_number FROM tbl_dummy; -- Only this way we can retrieve the value

CREATE OR REPLACE VIEW vw_employee (employee_name INVISIBLE, employee_number) AS
	SELECT employee_name, employee_number
	FROM tbl_employee
	WHERE hire_date BETWEEN TO_DATE('01/01/1990', 'dd/mm/yyyy') AND TO_DATE('01/01/2020')
WITH READ ONLY
;
---------------------------------------------------------------------------------------------------
-- Practice Activity 15
-- 1] Create a VIEW vw_by_category based on the following SQL code:
SELECT category_name, subcategory_name, SUM(quantity) AS total_quantity
FROM tbl_category
	NATURAL LEFT JOIN tbl_subcategory
	NATURAL LEFT JOIN tbl_product
	NATURAL LEFT JOIN tbl_transaction
GROUP BY category_name, subcategory_name
ORDER BY category_name, subcategory_name
;

CREATE OR REPLACE VIEW vw_by_category AS (
	SELECT category_name, subcategory_name, SUM(quantity) AS total_quantity
		FROM tbl_category
		NATURAL LEFT JOIN tbl_subcategory
		NATURAL LEFT JOIN tbl_product
		NATURAL LEFT JOIN tbl_transaction
	GROUP BY category_name, subcategory_name
	ORDER BY category_name, subcategory_name
) WITH READ ONLY -- This is extra for me. To me, all views should be like this by default
;

-- 2] Alter the view so that the following is also in the SELECT clause:
-- ,SUM(actual_cost) AS total_actual_cost
CREATE OR REPLACE VIEW vw_by_category AS (
	SELECT category_name, subcategory_name, SUM(quantity) AS total_quantity
			,SUM(actual_cost) AS total_actual_cost
		FROM tbl_category
		NATURAL LEFT JOIN tbl_subcategory
		NATURAL LEFT JOIN tbl_product
		NATURAL LEFT JOIN tbl_transaction
	GROUP BY category_name, subcategory_name, actual_cost
	ORDER BY category_name, subcategory_name
) WITH READ ONLY -- This is extra for me. All views should be like this by default
;

-- 3] Change the view so that the total_actual_cost is INVISIBLE
CREATE OR REPLACE VIEW vw_by_category 
		(category_name, subcategory_name, total_quantity, total_actual_cost INVISIBLE ) 
AS (
	SELECT category_name, subcategory_name, SUM(quantity) AS total_quantity
			,SUM(actual_cost) AS total_actual_cost
		FROM tbl_category
		NATURAL LEFT JOIN tbl_subcategory
		NATURAL LEFT JOIN tbl_product
		NATURAL LEFT JOIN tbl_transaction
	GROUP BY category_name, subcategory_name
	ORDER BY category_name, subcategory_name
) WITH READ ONLY -- This is extra for me. All views should be like this by default
;
---------------------------------------------------------------------------------------------------
-- UNION and UNION ALL
-- Combining rows together
-- Same number of columns with similar/compatible data types
-- VARCHAR2(1) + VARCHAR2(5) OK

-- Oracle SQL takes the name of the first field in the UNION ALL statement
-- UNION ALL => allows duplicate results
SELECT CAST('hi' AS CHAR(5)) || '.' as greeting
FROM DUAL
UNION ALL
SELECT CAST('hello there' AS CHAR(11)) as greeting_now
FROM DUAL
UNION ALL
SELECT CAST('bonjour' AS CHAR(11))
FROM DUAL
;

-- UNION does not allow duplicates:
SELECT 1
FROM DUAL
UNION
SELECT 1
FROM DUAL
UNION
SELECT 2
FROM DUAL
; -- 1,2


-- Casting from string -> date -> timestamp
SELECT TO_DATE('2021-01-01', 'YYYY-MM-DD') as my_date
FROM DUAL
UNION
SELECT CAST(TO_DATE('2022-01-01', 'YYYY-MM-DD') AS TIMESTAMP) as my_timestamp
FROM DUAL
; -- TIMESTAMP(9) OK
---------------------------------------------------------------------------------------------------
-- INTERSECT and MINUS operations	

CREATE OR REPLACE TABLE tbl_transaction_new
(
	amount NUMBER(15,2)
	,date_of_transaction DATE
	,employee_number NUMBER(4,0) DEFAULT 124
	,date_of_entry TIMESTAMP(6) DEFAULT ON NULL sysdate
	,should_i_delete NUMBER(1,0)
);

-- Feed a table from the data of another table:
INSERT INTO tbl_transaction_new
SELECT amount, date_of_transaction, employee_number, date_of_entry
	, mod(rownum, 3) AS should_i_delete -- Extra column based on 'rownum' -> Rownumber of the SELECT statement
FROM tbl_transaction;

-- DELETE every row with should_i_delete = 1
START TRANSACTION;

SELECT COUNT(*)
FROM tbl_transaction_new
WHERE should_i_delete = 1
;

DELETE
FROM tbl_transaction_new
WHERE should_i_delete = 1;

SELECT COUNT(*) 
FROM tbl_transaction_new
;

COMMIT;

UPDATE tbl_transaction_new
SET date_of_transaction = date_of_transaction + 1
WHERE should_i_delete = 2
;

COMMIT;

-- Idea: Create a similar, but not an identical data set and put them together via SET operators
-- A U B, A ^ B, A\B
SELECT amount, date_of_transaction, employee_number FROM tbl_transaction
INTERSECT -- UNION (ALL) / MINUS
SELECT amount, date_of_transaction, employee_number FROM tbl_transaction_new
ORDER BY employee_number
;
---------------------------------------------------------------------------------------------------
-- AMPERSAND (&) SUBSTITUTION
SELECT employee_number, employee_first_name, employee_middle_name, employee_last_name
	,employee_government, date_of_birth, department
FROM tbl_employee
ORDER BY &how_do_you_want_me_to_order_by -- Enter value for the variable :O
;

SELECT * 
FROM tbl_employee
ORDER BY &x -- Prompts a popup for the value for variable substitution
;

DEFINE VAR_AGE = 42;
SELECT &VAR_AGE AS my_variable FROM DUAL;

UNDEFINE VAR_AGE;

DEFINE sql_var = 'Hello, World';
SELECT &sql_var AS my_var FROM DUAL;

-- 2 ampersand substitutions:
SELECT employee_number, employee_first_name, employee_middle_name, employee_last_name
	,employee_government, date_of_birth, department
FROM tbl_employee
WHERE TRIM(UPPER(employee_first_name)) LIKE '%&required_employee_first_name%'
ORDER BY &column_name
;
---------------------------------------------------------------------------------------------------
-- CASE statement
SELECT 
	CASE
		WHEN '&my_option' = 'A' THEN 'First option'
		WHEN '&my_option' = 'B' THEN 'Second option'
		WHEN '&my_option' = 'C' THEN 'Third option'
	ELSE 'No option' -- ELSE is not compulsory. In this case, a (null) will be returned
	END AS my_options
FROM DUAL
;

-- First letter of the employee_name:
SELECT SUBSTR(employee_name, 1, 1) FROM tbl_employee;

DEFINE my_option = 'D';

-- Ask the user for an option
-- Dangerous?
ACCEPT user_option PROMPT 'Choose an option (Uppercase from A-Z)';
---------------------------------------------------------------------------------------------------
-- NVL, NVL2 and COALESCE
-- Null Value Logic
-- NVL(column_name, '-')
-- NVL2(column_name, 'not null case', 'null case')
-- COALESCE(columnA, columnB, columnC, columnD) -- Returns the FIRST NOT NULL value
-- 	  If all parameters are null, then the expression returns null

SELECT * FROM tbl_employee
WHERE employee_middle_name IS NULL;

SELECT NVL(employee_middle_name, 'NA') as middle_name
FROM tbl_employee;
---------------------------------------------------------------------------------------------------
-- Practice Activity 16

-- Set #1 => 181 rows
SELECT transaction_id, quantity, actual_cost
FROM tbl_transaction
WHERE MOD(quantity, 3) = 0; -- 0, 3, 6, 9, 12, ...

-- Set #2 => 201 rows
SELECT transaction_id, quantity, acutal_cost
FROM tbl_transaction
WHERE quantity >= 8;

-- UNION ALL   = 382 (allows duplicates)
-- UNION 	   = 313 (eliminates the 69 duplicates)
-- INTERSECT   = 69 
-- #1 MINUS #2 = 112 (181-69)
-- #2 MINUS #1 = 132 (201-69)

ACCEPT minimum_quantity PROMPT 'What is the minimum quantity for set 2?';

-- 7. There are some rows where the subcategory_name is NULL. Change the SELECT clause so that, when the
-- subcategory_name is NULL, then it says instead 'No subcategory'

SELECT NVL(subcategory_name, 'No subcategory')
	,COUNT(product_id) AS number_of_records
	, CASE WHEN COUNT(product_id) = 1
		THEN 'Only one'
	  ELSE 'More than one'
	END AS new_number_of_records
FROM tbl_product
NATURAL LEFT JOIN tbl_subcategory
GROUP BY subcategory_name
ORDER BY subcategory_name
;

-- ... Practice Activity Number 16
ACCEPT user_input PROMPT 'Enter a number of rows to be affected: ';
SELECT &user_input AS my_var FROM DUAL;
UNDEFINE user_input;
---------------------------------------------------------------------------------------------------
-- MERGE statement

CREATE TABLE tbl__transaction
(
    employee_number NUMBER(4,0) NOT NULL
    ,date_of_transaction DATE DEFAULT ON NULL current_date
    ,amount NUMBER (12,4) NOT NULL DEFAULT 0
);

-- Original table
-- Target
-- EMPLOYEE_NUMBER  | DATE  | VALUE
-------------------------------------
--        1         | 1-Jan |  100
--        2         | 2-Jan |  200
--        2         | 3-Jan |  300
-------------------------------------

-- New table
-- Source
-- EMPLOYEE_NUMBER  | DATE  | VALUE
-------------------------------------
--        2        | 3-Jan |  1000   -> Update this value. This will be the new value for id = 2
--                                     old_value + new_value for the amount :O
--        3        | 3-Jan |  1000   -> This is inserted in the normal way
-------------------------------------
-- This last data cannot be added to the target table, since a PK constraint would be violated

-- In summary, when MERGING, we have 3 actions based on 2 possibilities:

--                         UPDATE  |   INSERT  |  DELETE
-- 1] IDs match               x    |           |    x
-- 2] IDs do not match             |     x     |
---------------------------------------------------------------------------------------------------
-- MERGING in practice
-- Define the target (original) table = tbl_transaction
-- Define the source table = tbl_transaction_new
-- MERGE continuation
-- 11/Junio/2025

-- Target table: TBL_TRANSACTION
-- Source table: TBL_TRANSACTION_NEW


-- ON (condition) PARENTHESES are mandatory
MERGE INTO tbl_transaction t
USING tbl_transaction_new s
ON (t.employee_number = s.employee_number AND t.date_of_transaction = s.date_of_transaction)
WHEN MATCHED THEN
    UPDATE SET amount = t.amount + s.amount
WHEN NOT MATCHED THEN
    INSERT (amount, date_of_transaction, employee_number) VALUES (s.amount, s.date_of_transaction, s_employee_number)
;

SELECT t.*, s.*
FROM tbl_transaction t
    INNER JOIN tbl_transaction_new 
        ON t.employee_number = s.employee_number AND t.date_of_transaction = s.date_of_transaction
;

-- List all of the employee numbers in tbl_transaction_new which do not exist in tbl_employee
SELECT DISTINCT t.employee_number
FROM tbl_transaction_new t
LEFT JOIN tbl_employee e
    ON t.employee_number = e.employee_number
WHERE e.employee_number IS NULL
;

DELETE FROM tbl_transaction_new
WHERE employee_number IN 
(
    SELECT DISTINCT t.employee_number
    FROM tbl_transaction_new t
    LEFT JOIN tbl_employee e
        ON t.employee_number = e.employee_number
    WHERE e.employee_number IS NULL
);
COMMIT;

---------------------------------------------------------------------------------------------------
-- ADDING A COMMENTS FIELD
ALTER TABLE tbl_transaction ADD comments NVARCHAR2(50) NULL;

MERGE INTO tbl_transaction t
USING tbl_transaction_new s
ON (t.employee_number = s.employee_number AND t.date_of_transaction = s.date_of_transaction)
WHEN MATCHED THEN
	UPDATE SET amount = t.amount + s.amount, comments = 
		CASE WHEN s.amount > 0 THEN 'Updated row positive'
		CASE WHEN s.amount < 0 THEN 'Updated row negative'
		ELSE 'Same value' END
	WHERE s.amount > 0
	DELETE WHERE s.amount < 100
WHEN NOT MATCHED THEN
	INSERT (amount, date_of_transaction, employee_number, comments)
	VALUES (s.amount, s.date_of_transaction, s.employee_number, 'Inserted row') -- NEW COLUMN
;
---------------------------------------------------------------------------------------------------
-- Practice Activity 17
CREATE TABLE ptbl_subcategory_new
(
	product_subcategory_id NUMBER(2,0)
	,product_category_id NUMBER(1,0)
	,sub_category_name VARCHAR2(30 BYTE)
);
INSERT INTO ptbl_subcategory_new VALUES (24, 3, 'Tights (long)');
INSERT INTO ptbl_subcategory_new VALUES (38, 4, 'Water bottles');
COMMIT;
-- Create a MERGE statement that uses this new table to merge with ptbl_subcategory
-- Where the new product_subcategory_id matches an existing row, UPDATE the other fields in table ptbl_subcategory
-- Where the new product_subcategory_id does not match, then INSERT this new data
MERGE INTO ptbl_subcategory t
USING ptbl_subcategory_new s
ON (t.product_subcategory_id = s.product_subcategory_id)
WHEN MATCHED THEN
	UPDATE SET product_category_id = s.product_category_id
		,sub_category_name = s.sub_category_name
WHEN NOT MATCHED THEN
	INSERT (product_subcategory_id, product_category_id, sub_category_name)
	VALUES (s.product_subcategory_id, s.product_category_id, s.sub_category_name)
;
---------------------------------------------------------------------------------------------------
-- OVER()
-- Creating an attendance table

CREATE OR REPLACE TABLE tbl_attendance
(
	employee_number NUMBER(4,0)
	,attendance_month TIMESTAMP
	,number_of_attendance NUMBER(4,0)
	,CONSTRAINT pk_attendance PRIMARY KEY(employee_number, attendance_month)
	,CONSTRAINT fk_tbl_attendance_employee_number FOREIGN KEY (employee_number)
		REFERENCES tbl_employee(employee_number)
);

INSERT INTO tbl_attendance (employee_number, attendance_month, number_attendance)
	VALUES (199, TO_DATE('2025-06-17', 'YYYY-MM-DD'), 28);
COMMIT;

-- We want to sum all of the attendance days that a particular employee had per year
SELECT employee_number
 	   ,EXTRACT(YEAR FROM attendance_month) AS attendance_year
	   ,SUM(number_attendance) AS total_attendance
FROM tbl_attendance
GROUP BY employee_number, EXTRACT(YEAR FROM attendance_month)
ORDER BY employee_number, EXTRACT(YEAR FROM attendance_month)
; -- Entry examples for employee 123:
-- EMPLOYEE_NUMBER |  ATTENDANCE_YEAR  | TOTAL_ATTENDANCE
--      123 	   |      2023		   |        174
--      123 	   |      2024		   |        202

-- Let us explore another type of aggregation or sum:
SELECT employee_number
	,attendance_month
	,number_attendance
	,SUM(number_attendance) OVER() AS all_employees_total_attendance
	,ROUND(number_attendance / (SUM(number_attendance) OVER()) * 100, 4) AS percentage_attendance
FROM tbl_attendance
;
-- OVER() takes a particular range of rows and performs a calculation OVER this range.
-- At the moment, this calculation is performed OVER all the tbl_attendance, but we will refine this on the next lecture:
-- PARTITION BY and ORDER BY
-- PARTITION BY refines the range that OVER() is working on
-- OVER(PARTITION BY xxxx ORDER BY xxxxx)
SELECT employee_number
	,attendance_month
	,number_attendance
	,SUM(number_attendance) OVER(PARTITION BY employee_number ORDER BY attendance_month ASC) AS running_total
	,ROUND(number_attendance / (SUM(number_attendance) 
		OVER(PARTITION BY employee_number ORDER BY attendance_month DESC)) * 100, 4) AS percentage_attendance
FROM tbl_attendance
;
-- Add another PARTITION BY field: EXTRACT(YEAR FROM attendance_month)
SELECT employee_number
	,attendance_month
	,number_attendance
	,SUM(number_attendance) OVER(PARTITION BY employee_number
								,EXTRACT(YEAR FROM attendance_month)
								ORDER BY attendance_month ASC) AS running_total
	--,ROUND(number_attendance / (SUM(number_attendance) 
	--	OVER(PARTITION BY employee_number ORDER BY attendance_month DESC)) * 100, 4) AS percentage_attendance
FROM tbl_attendance
;
-- ROWS BETWEEN
SELECT
	SUM(number_attendance)
	OVER (
		PARTITION BY employee_number, EXTRACT(YEAR FROM attendance_month)
		ORDER BY attendance_month ASC
		ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS my_total
FROM tbl_attendance
;

