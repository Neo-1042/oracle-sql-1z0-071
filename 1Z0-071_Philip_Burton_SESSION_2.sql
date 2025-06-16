---------------------------------------------------------------------------------------------------
-- 1Z0-071 Oracle SQL Database
-- SESSION 2
-- 11/march/2025

-- Using SELECT statements to access data from more than one table using equijoins and non-equijoins
-- Join a table to itself by using a self-join
-- View data that generallt does not meet a join condition by using outer joins

-- Using a SET OPERATOR to combine multiple queries into a single query :O
---------------------------------------------------------------------------------------------------
-- Creating TBL_EMPLOYEE
DROP TABLE tbl_employee;

CREATE TABLE tbl_employee (
	employee_number 			DECIMAL(4,0) NOT NULL
	,employee_first_name 		VARCHAR2(50 CHAR) NOT NULL
	,employee_middle_name		VARCHAR2(50 CHAR) NULL
	,employee_last_name			VARCHAR2(50 CHAR) NOT NULL
	,employee_government_id     CHAR(10 CHAR) NULL
	,date_of_birth              DATE NOT NULL -- Could be TIMESTAMP(6); it depends
);

-- Right-click on the table > Quick DDL > Export to clipboard/workbook/file > CREATE TABLE
-- When automatically generating the DDL for the table, the NOT NULL CONSTRAINTS are moved down to:
ALTER TABLE "SYS"."TBL_EMPLOYEE" MODIFY ("EMPLOYEE_NUMBER" NOT NULL ENABLE);

SELECT * FROM tbl_employee;

ALTER TABLE tbl_employee
ADD department VARCHAR2(20 CHAR); -- Careful with BYTES and CHARs

INSERT INTO tbl_employee 
	   (employee_number, employee_first_name, employee_middle_name, employee_last_name, employee_government_id, date_of_birth, department)
VALUES (132, 'Dylan', 'A', 'Word', 'asascasc23', '14-SEP-1992', 'Customer Relations' );
COMMIT; -- Necessary for DML operations (DELETE, INSERT, UPDATE)

ALTER TABLE tbl_employee DROP COLUMN department; -- !! Column owned by SYS
---------------------------------------------------------------------------------------------------
SELECT *
FROM tbl_employee
WHERE employee_last_name = 'Word'; -- case sensitive
;

SELECT *
FROM tbl_employee
WHERE UPPER(TRIM(employee_last_name)) <> 'WORD';
;

SELECT *
FROM tbl_employee
WHERE UPPER(TRIM(employee_last_name)) != 'WORD';
;

SELECT *
FROM tbl_employee
WHERE UPPER(TRIM(employee_last_name)) LIKE 'W%';
;

-- WILDCARDS
-- % ----> 0 to inifite (as many) characters
-- _ ----> 1 character

-- Example: the second character is a 'W' and the rest is whatever
UPPER(TRIM(employee_last_name)) LIKE '_W%'; -- aWmian"

SELECT * FROM tbl_employee
WHERE UPPER(department) NOT LIKE '_pple';

SELECT * FROM tbl_employee
WHERE employee_number BETWEEN 200 and 300; -- [200,300] closed interval (inclusive)

SELECT * FROM tbl_employee
WHERE employee_number IN (200, 203, 207, 210);

-- DATES
SELECT * FROM tbl_employee
WHERE date_of_birth >= TO_DATE('1995-12-07', 'YYYY-MM-DD')  AND date_of_birth <= TO_DATE('2007-01-01', 'YYYY-MM-DD'); 
-- The computer assumes 00:00 when dates are actually TIMESTAMP

-- SARG -> Indexes
------------------------------------------------------------------------------------------------------
-- Practice Activity 8
-- p stands for practice
CREATE TABLE ptbl_transaction
(
	transaction_ud NUMBER(6,0) NOT NULL
	,product_id NUMBER(3,0) NOT NULL
	,reference_Order_ID NUMBER(5,0) NOT NULL
	,transaction_Date DATE NOT NULL
	,transaction_Type CHAR (1 CHAR) NOT NULL -- Instead of BYTE, since it depends on the enconding and so on
	,quantity NUMBER(4,0) NOT NULL
	,actual_cost (8,4) NOT NULL
);

CREATE TABLE ptbl_product
(
	product_id NUMBER(3,0) NOT NULL
	,product_name VARCHAR2(40) NOT NULL
	,standard_cost NUMBER(8,4) NOT NULL
	,list_price NUMBER(7,3) NOT NULL
	,weight NUMBER(6,2) NULL
	,product_line CHAR (2 CHAR) NULL -- Careful with hidden spaces
	,product_subcategory_id NUMBER(2,0) NULL
);

CREATE TABLE ptbl_subcategory
(
	product_subcategory_id NUMBER(1,0)
	,product_category_id NUMBER(1,0)
	,subcategory_name VARCHAR2(30)
	
);

CREATE TABLE ptbl_category
(
	product_category_id NUMBER(1,0)
	,category_name VARCHAR2(20)
);

-- Practice Activity 9
SELECT *
FROM ptbl_subcategory
WHERE UPPER(TRIM(subcategory_name)) LIKE '%BIKE%'
;
------------------------------------------------------------------------------------------------
SELECT SUBSTR(employee_first_name,1,1)
	,COUNT(*) AS times_per_initial_letter -- COUNT(*) counts number of rows that have the same initial letter,...
FROM tbl_employee
GROUP BY SUBSTR(employee_first_name,1,1)
HAVING COUNT(*) >= 50 -- Only works on data that has been AGGREGATE
ORDER BY COUNT(*) DESC
;

SELECT 
	TO_CHAR(date_of_birth, 'Month', 'NLS_DATE_LANGUAGE=Spanish') AS "Month Name"
	,COUNT(*) AS "number of employees"
FROM tbl_employee
GROUP BY TO_CHAR(date_of_birth, 'Month', 'NLS_DATE_LANGUAGE=Spanish')
;

SELECT 
	TO_CHAR(date_of_birth, 'FMMM') AS "Month Name"
	,COUNT(*) AS "number of employees"
FROM tbl_employee
GROUP BY TO_CHAR(date_of_birth, 'FMMM')
;

SELECT
	TO_CHAR(date_of_birth, 'FMMonth') as Month_Name
FROM tbl_employee
GROUP BY TO_CHAR(date_of_birth, 'FMMonth'),TO_CHAR(date_of_birth, 'MM')
ORDER BY TO_CHAR(date_of_birth, 'MM')
; -- Display the months in the right order (ordering by the month numbers)
------------------------------------------------------------------------------------------------
-- NULL is not the same as '' (a string with zero characters)
-- How many employees have a middle name, how many don't and
-- What is the date of birth range (min/max)
-- Next training: try it out for yourself before continuing taking the course
SELECT
	TO_CHAR(date_of_birth, 'FMMonth') AS month_name
	,COUNT(*) AS number_of_employees
 	,COUNT(employee_middle_name) AS "Number of middle names"
 	,COUNT(*) -  COUNT(employee_middle_name) AS "Emps with no middle name"
FROM tbl_employee
GROUP BY TO_CHAR(date_of_birth, 'FMMonth'), TO_CHAR(date_of_birth, 'MM')
ORDER BY TO_CHAR(date_of_birth, 'MM')
;

SELECT 
	MAX(date_of_birth) AS "latest_date_of_birth"
	,MIN(date_of_birth) AS "earliest_date_of_birth"
	,
FROM tbl_employee
;

-- NULLS FIRST/LAST
SELECT employee_middle_name
FROM tbl_employee
ORDER BY employee_middle_name NULLS FIRST
;
------------------------------------------------------------------------------------------------
-- Retrieve the statistics of transactions for every reference_order_id
-- Filter the results only where (HAVING) number_of_transactions is at least 10
SELECT
	reference_order_id
	,SUM(quantity) AS total_quantity
	,SUM(actual_cost) AS total_actual_cost
	,COUNT(*) AS number_of_transactions
FROM ptbl_transaction
GROUP BY reference_order_id
HAVING COUNT(*) >= 10
ORDER BY reference_order_id
;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Adding a second table for money transactions
-- Creating TBL_EMPLOYEE
DROP TABLE tbl_employee;

CREATE TABLE tbl_employee (
	employee_number 			NUMBER(4,0) NOT NULL
	,employee_first_name 		VARCHAR2(50 CHAR) NOT NULL
	,employee_middle_name		VARCHAR2(50 CHAR) NULL
	,employee_last_name			VARCHAR2(50 CHAR) NOT NULL
	,employee_government_id     CHAR(10 CHAR) NULL
	,date_of_birth              DATE NOT NULL -- Could be TIMESTAMP(6); it depends
	,department 				VARCHAR2(20 CHAR)
);

-- NUMBER is preferred over DECIMAL in Oracle SQL (although they are almost the same)
CREATE TABLE tbl_transaction
(
	amount 					NUMBER(15,2) NOT NULL
	,date_of_transaction    DATE NULL
	,employee_number		NUMBER(4,0) NOT NULL
);

NUMBER(15,2) -- FLOAT,BINARY DOUBLE, etc. are APPROXIMATIONS. NOT recommended for money
-- SCD => Slowly Changing Dimensions
-- How to choose a proper identifier? i.e. a PRIMARY KEY
-- Adding full name of the employee BAD IDEA
------------------------------------------------------------------------------------------------
TRUNCATE TABLE tbl_transaction;
COMMIT;
------------------------------------------------------------------------------------------------
-- ERD = Entity Relationalship Diagrams on Oracle SQL Developer
------------------------------------------------------------------------------------------------
-- View > Data Modeler > Browser
-- Relational Models > New Relational Model 
-- Drag and drop
-- Red stars or asterisks (*) indicate that the field is NOT NULL(ABLE)
------------------------------------------------------------------------------------------------
SELECT
	employee_number
	,SUM(amount) AS total_amount
FROM tbl_transaction
GROUP BY employee_number
;
-- What if I need information from tbl_employee as well?
-- We write a JOIN query
SELECT *
FROM tbl_employee e
	INNER JOIN tbl_transaction t
	ON e.employee_number = t.employee_number -- TRUE when it's the same person
;

SELECT 
	e.employee_number
	,e.employee_first_name
	,e.employee_last_name
	,SUM(amount) AS total_amount
FROM tbl_employee e
	INNER JOIN tbl_transaction t
	ON e.employee_number = t.employee_number -- TRUE when it's the same person
GROUP BY
	e.employee_number,e.employee_first_name,e.employee_last_name
;
-----------------------------------------------------------------------------------------------------
-- Different types of JOINs
-- (INNER) JOIN
-- LEFT/RIGHT (OUTER) JOIN 
-- FULL (OUTER) JOIN
-- CROSS JOIN (Not recommended. Cartesian product A x B = {(a,b) | a in A, b in B})
-----------------------------------------------------------------------------------------------------
-- INNER JOIN example
SELECT 
	emp.employee_number
	,emp.employee_first_name
	,emp.employee_last_name
	,SUM(tr.amount) AS transaction_total_per_employee_id
FROM tbl_employee emp
	INNER JOIN tbl_transaction tr 
		ON emp.employee_number = tr.employee_number
GROUP BY emp.employee_number, emp.employee_first_name, emp.employee_last_name
; -- 898 results
-- LEFT OUTER JOIN example
SELECT 
	emp.employee_number
	,emp.employee_first_name
	,emp.employee_last_name
	,SUM(tr.amount) AS transaction_total_per_employee_id
FROM tbl_employee emp
	LEFT OUTER JOIN tbl_transaction tr 
		ON emp.employee_number = tr.employee_number
GROUP BY emp.employee_number, emp.employee_first_name, emp.employee_last_name
; -- 1005 results
-- RIGHT OUTER JOIN example
SELECT 
	emp.employee_number
	,emp.employee_first_name
	,emp.employee_last_name
	,SUM(tr.amount) AS transaction_total_per_employee_id
FROM tbl_employee emp
	RIGHT OUTER JOIN tbl_transaction tr 
		ON emp.employee_number = tr.employee_number
GROUP BY emp.employee_number, emp.employee_first_name, emp.employee_last_name
; -- 50 rows
-- FULL OUTER JOIN example
SELECT 
	emp.employee_number
	,emp.employee_first_name
	,emp.employee_last_name
	,SUM(tr.amount) AS transaction_total_per_employee_id
FROM tbl_employee emp
	FULL OUTER JOIN tbl_transaction tr 
		ON emp.employee_number = tr.employee_number
GROUP BY emp.employee_number, emp.employee_first_name, emp.employee_last_name
; -- 1109 results (fetches rows where almost every field is null)
------------------------------------------------------------------------------------------------
-- Practice Activity 11. JOINs
-- 1. Code a SELECT statement which joins tbl_transaction with tbl_product (ON product_id)
-- For each product_name, calculate:
-- a) Total actual_cost
-- b) Total quantity
-- Finally, sort by product_name
SELECT
	p.product_name
	,SUM(p.actual_cost) AS total_cost
	,SUM(p.quantity) AS total_quantity
FROM tbl_transaction t
	INNER JOIN tbl_product p
		ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY p.product_name
;
-- 2. Code a SELECT statement which joins together tbl_subcategory and tbl_category and returns the
-- 	category_name and the sub_category_name
SELECT
	category_name
	,subcategory_name
FROM tbl_subcategory sub 
	INNER JOIN tbl_category cat
		ON sub.product_category_id = cat.product_category_id
;
-- 3. Code a SELECT statement which counts the number of product_id in tbl_product for each 
-- subcategory_name in tbl_subcategory. There are some product_id which do not have any subcategories, so make
-- sure that your JOIN allows this.
SELECT 
	s.subcategory_name -- For each subcategory name, COUNT the number of product_ids
	,COUNT(product_id) AS number_of_products
FROM tbl_product p
	LEFT OUTER JOIN tbl_subcategory s
GROUP BY sub.product_subcategory_id
;
------------------------------------------------------------------------------------------------
-- ALL vs DISTINCT
SELECT COUNT(ALL department) AS number_of_departments
FROM tbl_employee
;

SELECT COUNT(DISTINCT department) AS number_of_departments
FROM tbl_employee
;

SELECT DISTINCT department AS departents
FROM tbl_employee
;
-- Retrieve the DISTINCT combination of (employee_last_name, department)
SELECT DISTINCT employee_last_name, department
FROM tbl_employee
;
------------------------------------------------------------------------------------------------
SELECT tablet_model_name, COUNT(*) as "Number of tablets per model"
FROM tbl_tablets
GROUP BY tablet_model_name
;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Adding a third table
-- 1] tbl_employee
-- 2] tbl_transaction
-- 3] tbl_department

SELECT department, COUNT(*) AS number_per_department
FROM tbl__employee
GROUP BY department
;
--|DEPARTMENT |  #   |
----------------------
-- Litigation | 231  |
-- HR         | 231  |
-- Customer   | 290  |
-- Commercial | 255  |
----------------------
-- Sub-query. Derived tables
SELECT department FROM (	
	SELECT department, COUNT(*) AS number_per_department
	FROM tbl_employee
	GROUP BY department
);
-- DEPARTMENT | 
---------------
-- Litigation | 
-- HR         |
-- Customer   | 
-- Commercial |
---------------
-- From this sub-query let's create a new table
CREATE TABLE tbl_department AS
(
	SELECT department FROM (	
		SELECT department, COUNT(*) AS number_per_department
		FROM tbl_employee
		GROUP BY department
	)
);

SELECT * FROM tbl_department;
-- Add a new column to tbl_department
ALTER TABLE tbl_department 
ADD department_head VARCHAR2(20 CHAR);
------------------------------------------------------------------------------------------------
-- JOINING three tables
-- tbl_department -> tbl_employee -> tbl_transaction
-- Bypasses tbl_employee, but it's necessary, since there is no direct connection between
-- tbl_department and tbl_transaction
SELECT
	d.department
	,d.department_head
	,SUM(t.amount) AS sum_of_amount
FROM tbl_department d
	LEFT JOIN tbl_employee e 
		ON d.department = e.department
	LEFT JOIN tbl_transaction t
		ON e.employee_number = t.employee_number
GROUP BY d.department, d.department_head
;
-- DEPARTMENT | sum_amount   |
-----------------------------
-- Litigation | 23525.9      |
-- HR         | 12412.09     |
-- Customer   | 124124124.12 |
-- Commercial | 255.1421     |
------------------------------
TRUNCATE TABLE tbl_department;
COMMIT;
INSERT INTO tbl_department VALUES('Customer', 'Andrew');
INSERT INTO tbl_department VALUES('Commercial', 'Bryan');
INSERT INTO tbl_department VALUES('HR', 'Catherine');
INSERT INTO tbl_department VALUES('Litigation', 'Andrew');
INSERT INTO tbl_department VALUES('Accounts', 'James');
-- !! Oracle SQL does not permit using 'AS' when: INNER JOIN tbl_foo AS f :c
------------------------------------------------------------------------------------------------
-- Practice Activity 12
-- Joining three tables
SELECT
	s.subcategory_name
	,t.transaction_date
	,SUM(t.actual_cost) AS total_actual_cost
	,SUM(t.quantity) AS total_quantity
FROM tbl_transaction t
	LEFT OUTER JOIN tbl_product p ON t.product_id = p.product_id
	LEFT OUTER JOIN tbl_subcategory s ON p.product_subcategory_id = s.product_subcategory_id
GROUP BY s.subcategory_name, t.transaction_date
ORDER BY s.subcategory_name, t.transaction_date
;
------------------------------------------------------------------------------------------------
SELECT 
	c.category_name
	,s.subcategory_name
	,COUNT(p.product_id) AS number_of_products
FROM tbl_product p
	FULL OUTER JOIN tbl_subcategory s ON p.product_subcategory_id = s.product_subcategory_id
	FULL OUTER JOIN tbl_category c    ON s.category_id = c.category_id
GROUP BY c.category_name, s.subcategory_name
;

----------------------------------------------------------------------------------------------
-- END OF SESSION 2
----------------------------------------------------------------------------------------------