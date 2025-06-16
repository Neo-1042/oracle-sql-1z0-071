---------------------------------------------------------------------------------------------------
-- 1Z0-071 Oracle SQL Database
-- SESSION 3
-- 14/april/2025
---------------------------------------------------------------------------------------------------
-- View data that generally does not meet a JOIN condition by using OUTER JOINS.
-- Use DML to manage the data in tables
-- DDL, DML, TCL
-- Constraints for tables
-- Simple and complex VIEWs
-- Set operator to combine multiple queries
-- Control the order of rows returned
-- Merge rows in a table
---------------------------------------------------------------------------------------------------
-- Missing Data
SELECT
	e.employee_number AS e_number
	,t.employee_number AS t_number
	,e.employee_first_name
	,e.employee_last_name
	,SUM(t.amount) AS total_amount
FROM tbl_employee e
	LEFT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
WHERE t.employee_number IS NULL
GROUP BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
ORDER BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
; -- Returns 107 results; none of which have corresponding t_number (IS NULL)
-- Warning: in some versions of SQL, ORDER BY are NOT allowed in derived sub-queries
-- Making the last query a sub-query for a new one
SELECT *
FROM (
	SELECT
		e.employee_number AS e_number
		,t.employee_number AS t_number
		,e.employee_first_name
		,e.employee_last_name
		,SUM(t.amount) AS total_amount
	FROM tbl_employee e
		LEFT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
	WHERE t.employee_number IS NULL
	GROUP BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
	ORDER BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
)
;
---------------------------------------------------------------------------------------------------
-- Selecting only some fields from the derived table:
SELECT 
	e_number -- This is allowed, because the alias has already been processed
FROM (
	SELECT
		e.employee_number AS e_number
		,t.employee_number AS t_number
		,e.employee_first_name
		,e.employee_last_name
		,SUM(t.amount) AS total_amount
	FROM tbl_employee e
		LEFT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
	WHERE t.employee_number IS NULL -- *************************
	GROUP BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
	ORDER BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
) 
WHERE e_number BETWEEN 100 AND 50000
;
---------------------------------------------------------------------------------------------------
SELECT
	e.employee_number AS e_number
	,t.employee_number AS t_number
	,e.employee_first_name
	,e.employee_last_name
	,SUM(t.amount) AS total_amount
FROM tbl_employee e
	RIGHT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
WHERE e.employee_number IS NULL -- *************************
GROUP BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
ORDER BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
; -- 104 transactions where the employee_number is NULL (phantom transactions)
---------------------------------------------------------------------------------------------------
-- Tracking down the phantom transactions and deleting data
SELECT
	e.employee_number AS e_number
	,t.employee_number AS t_number
	,e.employee_first_name
	,e.employee_last_name
	,t.amount AS total_amount
FROM tbl_employee e
	RIGHT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
WHERE e.employee_number IS NULL -- *************************
-- GROUP BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name. t.amount
ORDER BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
; -- 256 phantom transactions

SELECT * FROM tbl_employee e
	RIGHT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
; -- Real transactions + phantom transactions
---------------------------------------------------------------------------------------------------
-- Deleting phantom transactions
-- DELETE GOOD PRACTICES
---------------------------------------------------------------------------------------------------
START TRANSACTION; -- BEGIN; BEGIN WORK;

SELECT COUNT(*) AS number_of_transactions
FROM tbl_transaction;

DELETE
FROM tbl_transaction
WHERE employee_number IN
(
	SELECT
		t.employee_number AS t_number
	FROM tbl_employee e
	RIGHT OUTER JOIN tbl_transaction t ON e.employee_number = t.employee_number
		WHERE e.employee_number IS NULL -- *************************
	-- ORDER BY e.employee_number, t.employee_number, e.employee_first_name, e.employee_last_name
);-- *** Flashbacked tables will be seen later ***
SELECT COUNT(*) AS number_of_transactions
FROM tbl_transaction;

ROLLBACK; -- Undo the changes
COMMIT; -- Save the changes
---------------------------------------------------------------------------------------------------
-- UPDATE rows based on certain criteria
START TRANSACTION;

UPDATE tbl_transaction
SET employee_number = 194
WHERE employee_number IN (3,5,7,9)
	AND date_of_transaction >= TO_DATE('19850101', 'YYYYMMDD') -- Philip uses "TO_CHAR() ¿?"
;

ROLLBACK;
COMMIT;
---------------------------------------------------------------------------------------------------
-- Practice Activity number 13
-- 1] Find the product_ids in table tbl_product that have not had any transactions
SELECT p.*, t.*
FROM tbl_product p 
	LEFT OUTER JOIN tbl_transaction t ON p.product_id = t.product_id
WHERE t.product_id IS NULL
;
-- Fetch only the product_id in table tbl_product and order the results to look for patterns
SELECT 
	p.product_id
FROM tbl_product p 
	LEFT OUTER JOIN tbl_transaction t ON p.product_id = t.product_id
WHERE t.product_id IS NULL
;
-- 2] Change all the transactions with transaction_date 2013 -> 2023, 2014 -> 2024
-- ADD_MONTHS()
START TRANSACTION;

UPDATE tbl_transaction
SET transaction_date = ADD_MONTHS(transaction_date, 12*10) -- Adds 10 years
WHERE EXTRACT(YEAR FROM transaction_date) = 2013
;

UPDATE tbl_transaction
SET transaction_date = ADD_MONTHS(transaction_date, 12*10) -- Adds 10 years
WHERE EXTRACT(YEAR FROM transaction_date) = 2014
;

SELECT * FROM tbl_transaction WHERE EXTRACT(YEAR FROM transaction_date) = 2023;

ROLLBACK;
COMMIT;

-- 3] Delete all the transactions from 31 July 2013
-- Query from the 1st of August, 2013, to avoid deleting data on the 31 July 2013 at 5PM, for example
SELECT COUNT(*) 
FROM tbl_transaction
WHERE transaction_date >= TO_DATE('2013-08-01', 'YYYY-MM-DD')
;

DELETE 
FROM tbl_transaction
WHERE transaction_date >= TO_DATE('2013-08-01', 'YYYY-MM-DD')
;
COMMIT;
ROLLBACK;
---------------------------------------------------------------------------------------------------
-- TERMINOLOGY
---------------------------------------------------------------------------------------------------
-- C:\app\plb\product\18.0.0\oradata\XE
-- *.DBF files => Table spaces to the system. 
-- SYSAUX01.DBF, SYSTEM01.DBF are table spaces. Data dictionary. Tables, procedures
-- TEMP01.DBF
-- UNDOTBS01.DBF
-- USERS01.DBF
---------------------------------------------------------------------------------------------------
-- DML = Data Manipulation Language
-- 		DIU = DELETE, INSERT, UPDATE + MERGE, SELECT
-- DDL = Data Definition Language
-- 		CREATE, DROP, ALTER, TRUNCATE + GRANT, COMMENT ... db objects
-- DCL = Data Control Language (infrequent)
-- 		Privileges, roles, grants
-- TCL = Transaction Control Language
-- 	     COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION
---------------------------------------------------------------------------------------------------
-- Transaction = a group of one or more database statements
-- Transactions are treated as a group. If the group fails half-way, then all the group fails.
-- Transactions are either COMMITted or ROLLBACKed.

-- 100'000 records belong to one transaction
-- 20'000 records run successfully, but then, the power shuts down in all of the bank
-- Power comes back on, Oracle SQL comes on and recognizes the error, and then 
-- performs a ROLLBACK on those 20'000 affected records.
-- The properties of a transaction are ACID:
-- A = Atomic     > Either all commited or all rollbacked
-- C = Consistent > Must leave the DB in a consistent state, i.e.,it refers to constraints
-- I = Isolated   > If multiple users are performing transactions on the same rows/objects, then
--					transactions are isolated by locking off individual rows or pages 
-- D = Durable	  > Effects are permanent
---------------------------------------------------------------------------------------------------
-- IMPLICIT TRANSACTIONS
--
-- DDL does NOT need explicit transaction statements (START TRANSACTION, COMMIT, ROLLBACK)
-- Implicit transactions take place:
-- COMMIT transaction;
-- BEGIN transaction;
DROP TABLE tbl_employee;
-- COMMIT transaction;

-- DML need explicit: COMMIT or ROLLBACK; for Oracle SQL
INSERT INTO tbl_employee VALUES (1,2,3,4,5);
COMMIT; -- NECESSARY
-- However, Oracle SQL Developer will try to COMMIT the transactions before closing the session.

-- EXPLICIT TRANSACTIONS
START TRANSACTION;

--SET TRANSACTION NAME 'my_transactionRRHG';

UPDATE tbl_employee
SET employee_number = 122
WHERE employee_number = 123
;
COMMIT;
---------------------------------------------------------------------------------------------------
-- TCL. SAVEPOINTS
---------------------------------------------------------------------------------------------------
-- As soon as you put in a DDL statement, any previous transaction will be automaticallly committed.

-- START TRANSACTION;
-- DML statements
-- 
-- SAVEPOINT 1
-- DML statements
--
-- SAVEPOINT 2
-- DML statements

-- ROLLBACK TO SAVEPOINT 2
-- DML statements

-- ROLLBACK TO SAVEPOINT 1
-- DML statements

-- COMMIT;
-- ROLLBACK;

START TRANSACTION;

UPDATE tbl_employee
SET employee_name = 'Luis'
WHERE employee_name = 'Lewis'
;

SAVEPOINT spt_1;

UPDATE tbl_employee
SET employee_name = 'Julia'
WHERE employee_name = 'Steve'
;

UPDATE tbl_employee
SET employee_name = 'Maquiavelo'
WHERE employee_name = 'Poli'
;

SAVEPOINT spt_2;

SELECT * FROM tbl_employee;

ROLLBACK spt_1;
---------------------------------------------------------------------------------------------------
-- Formatting in Oracle SQL Developer
-- Ctrl + F7
-- Tools > Preferences > Format > Advanced Format
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- DATA INTEGRITY
-- CREATE and MODIFY CONSTRAINTS
---------------------------------------------------------------------------------------------------
-- tbl_employee
-- tbl_transaction
-- tbl_product

-- Find all transactions that have no employee_number associated.
-- Find all employees with the same employee_number
-- UPDATE date_of_birth with a date that is in the future. Wrong
-- employee_government_id should have a predetermined format
---------------------------------------------------------------------------------------------------
-- CONSTRAINTS
--
-- NOT NULL
-- UNIQUE      => Prevent duplicate values from being entered into some determined column or
--		          multiple columns.
-- PRIMARY KEY => 
-- FOREIGN KEY => 
-- CHECK

-- INSERT 2001 -> This will still be done
-- INSERT NULL -> Error
-- INSERT 2001 -> This will still be done

ALTER TABLE tbl_employee
ADD CONSTRAINT unq_government_id UNIQUE (employee_government_id); -- ERROR

-- Finding out which records have duplicate employee_government_ids:
SELECT employee_government_id, COUNT(employee_government_id) AS my_count
FROM tbl_employee
GROUP BY employee_government_id
HAVING COUNT(employee_government_id) > 1
;

SELECT * FROM tbl_employee
WHERE employee_government_id IN (
	'AHVKAD34', '124JAHFUWVB'
);

START TRANSACTION;

DELETE FROM tbl_employee
WHERE employee_number < 3
;

COMMIT;

DELETE FROM tbl_employee
WHERE employee_number IN (131, 132); 
-- How to delete only one of the records? (not both)
-- Easy fix: Export the INSERT statements, delete the records, and then run the desired INSERT statements.

ALTER TABLE tbl_employee
ADD CONSTRAINT unq_government_id UNIQUE (employee_government_id); -- OK

-- UNIQUE constraint on 3 columns
ALTER TABLE tbl_transaction 
ADD CONSTRAINT unq_transaction UNIQUE (amount, date_of_transaction, employee_number);

ALTER TABLE tbl_transaction
DISABLE CONSTRAINT unq_transaction; -- Temporarily disabling the constraint

ALTER TABLE tbl_transaction
ENABLE CONSTRAINT unq_transaction;

CREATE OR REPLACE TABLE tbl_transaction2 (
	amount NUMBER(15,2) NOT NULL -- in-line specification
	-- ...
	,CONSTRAINT unq_transaction2 UNIQUE (amount, date_of_transaction, employee_number)
		-- This is called an out-of-line specification
);
---------------------------------------------------------------------------------------------------
-- DEFAULT values CONSTRAINT
-- If you don't specify a value for a column, then the default value will be assigned
-- Example: date_of_entry (current_timestamp or systimestamp or sysdate)

ALTER TABLE tbl_transaction
ADD date_of_entry TIMESTAMP(6) DEFAULT SYSDATE; -- in-line specification

ALTER TABLE tbl_transaction
MODIFY (date_of_entry TIMESTAMP DEFAULT SYSDATE);

START TRANSACTION;

UPDATE tbl_transaction
SET date_of_entry = NULL
; -- Set all the previous transactions' date_of_entry to NULL, since we don't know when were they done
COMMIT;

-- 1] No info       > SYSDATE (default)
-- 2] Override info > 07-JUN-1042
-- 3] Explicit NULL > (null) Since the column is nullable
---------------------------------------------------------------------------------------------------
-- DEFAULT ON NULL
-- So, if I want to still have a default value even when people send a "NULL" value, then
ALTER TABLE tbl_transaction
MODIFY (date_of_entry TIMESTAMP DEFAULT ON NULL SYSDATE); -- Only from Oracle 12c onwards

---------------------------------------------------------------------------------------------------
-- CHECK constraint
-- Go through an entire row for a specific criteria

ALTER TABLE tbl_employee
ADD CONSTRAINT chk_amount CHECK (amount > -1000 AND amount < 1000);

ALTER TABLE tbl_employee
ADD CONSTRAINT chk_middlename CHECK (
	REPLACE(employee_middle_name,'.','') = employee_middle_name OR employee_middle_name IS NULL
) ENABLE NOVALIDATE -- Ignore pre-existing non-compliant middle names.
; -- If there are any dots, the condition is FALSE and the middle name does NOT pass
-- e.g. Rodrigo R. Hurtado

ALTER TABLE tbl_employee
ADD CONSTRAINT chk_date_of_birth CHECK (
	EXTRACT(YEAR FROM date_of_birth) BETWEEN 1900 AND 2099 -- Constraints do not allow to call functions
) ENABLE NOVALIDATE
; -- A more elaborated solution would be to create a TRIGGER that activates when trying to insert birthdate > sysdate

-- OUT OF LINE SPECIFICATION for CONSTRAINTs in CREATE TABLE statements
CREATE TABLE tbl_employee
(
	employee_middle_name NVARCHAR2(50) NULL
	,CONSTRAINT chk_middlename CHECK (
		REPLACE(employee_middle_name,'.','') = employee_middle_name OR employee_middle_name IS NULL
	)
);
-- IN-LINE SPECIFICATION for CONSTRAINTs in CREATE TABLE statements
CREATE TABLE tbl_employee
(
	employee_middle_name NVARCHAR2(50) NULL
		CONSTRAINT chk_middlename CHECK (
		REPLACE(employee_middle_name,'.','') = employee_middle_name OR employee_middle_name IS NULL
	)
);
---------------------------------------------------------------------------------------------------
ALTER TABLE tbl_employee
DROP CONSTRAINT chk_date_of_birth;
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- PRIMARY KEY constraint
-- UNIQUE + NOT NULL
-- (By itself, UNIQUE allows at most one NULL)

-- When you add a PK to a table, the table is automatically, physically sorted by this field
-- Only ONE column can be made a primary key

-- PRIMARY KEY
-- Not nullable
-- Clustered (sorted)
-- Only one per table

-- Alternatives:
-- SURROGATE (artificial) KEY > Have no resemblance to real life, but can be used as identificators
-- NATURAL KEY
---------------------------------------------------------------------------------------------------
ALTER TABLE tbl_employee
ADD CONSTRAINT PK_tbl_employee PRIMARY KEY (employee_number); 

ALTER TABLE tbl_employee2
ADD CONSTRAINT PK_tbl_employee2 PRIMARY KEY (employee_number); 
-- The constraint name is over the entire SCHEMA (user). Be careful with the names

-- Automatically generate PKs (ids):
CREATE TABLE tbl_employee3
(
	employee_number NUMBER(6,0) GENERATED ALWAYS AS IDENTITY
	,employee_name NVARCHAR2(20)
	,CONSTRAINT PK_tbl_employee3 PRIMARY KEY (employee_number)
);

INSERT INTO tbl_employee3 (employee_name)
VALUES ('Rodrigo'); -- PK = 1

INSERT INTO tbl_employee3 (employee_name)
VALUES ('Compare'); -- PK = 2

INSERT INTO tbl_employee3 (employee_name)
VALUES ('Os'); -- PK = 3

-- Make the PK column INVISIBLE (I don't like this practice)
-- It only makes it invisible for 'SELECT *' and 'INSERT' statements
CREATE OR REPLACE TABLE tbl_employee3
(
	employee_number NUMBER(6,0) INVISIBLE GENERATED ALWAYS AS IDENTITY
	,employee_name NVARCHAR2(20)
	,CONSTRAINT PK_tbl_employee3 PRIMARY KEY (employee_number)
);

-- ** NOT recommended
-- GENERATED BY DEFAULT AS IDENTITY (NOT ALWAYS)
-- This allows to overrides the employee_number and INSERT any number I want (not already in use)
CREATE OR REPLACE TABLE tbl_employee3
(
	employee_number NUMBER(6,0) GENERATED BY DEFAULT AS IDENTITY
	,employee_name NVARCHAR2(20)
	,CONSTRAINT PK_tbl_employee3 PRIMARY KEY (employee_number)
);
-- Better: GENERATED ALWAYS AS IDENTITY
---------------------------------------------------------------------------------------------------
-- FOREIGN KEY
-- The FK is the counterpart to the PK
-- SEEKING => A FOREIGN KEY uses the dictionary (sorted list of ids) set up by the PRIMARY KEY
-- SCANNING => Going through a table without an index (e.g. when no PK has been setup)

-- A FOREIGN KEY value is constrained to the corresponding values of the PRIMARY KEY.

-- FK refers to another table.

-- A FOREIGN KEY can be NULL (e.g. NULL employee_number on the tbl_transaction table)
-- FK are not UNIQUE constraints

-- Now, what happens when the PK in the main table changes?
-- If an employee number changes on tbl_employee, it won't automatically change in tbl_car.
-- For this, you need to use a TRIGGER (PL/SQL)

-- Options of behavior when changing an employee number on tbl_employee
-- 1] No action (do not allow) DEFAULT
-- 2] Cascade
-- 3] Set NULL (when employee_number = 6 is deleted, then set null on tbl_car)
---------------------------------------------------------------------------------------------------
-- Attempt 1
ALTER TABLE tbl_transaction
ADD CONSTRAINT fk_tbl_transaction_emp_number FOREIGN KEY (employee_number)
REFERENCES tbl_employee(employee_number);
-- Error: an alter table validating constraint failed because the table has child records

-- Solution:
ALTER TABLE tbl_transaction
ADD CONSTRAINT fk_tbl_transaction_emp_number FOREIGN KEY (employee_number)
REFERENCES tbl_employee(employee_number)
ENABLE NOVALIDATE;

SELECT T.*
FROM tbl_transaction T
LEFT JOIN tbl_employee e
	ON t.employee_number = e.employee_number
WHERE e.employee_number IS NULL;

-- Deleting employee_numbers
SET TRANSACTION NAME 'deleting_employee_numbers'
SELECT * FROM tbl_employee WHERE employee_number = 123;
SELECT * FROM tbl_transaction WHERE employee_number = 123;

DELETE FROM tbl_employee
WHERE employee_number = 123;
-- Error: integrity constraint (SYS.FK_TBL_TRANSACTION_EMP_NUMBER) violated. Child record found

ALTER TABLE tbl_transaction
DROP CONSTRAINT fk_tbl_transaction_emp_number;

ALTER TABLE tbl_transaction
ADD CONSTRAINT fk_tbl_transaction_emp_number FOREIGN KEY (employee_number)
REFERENCES tbl_employee(employee_number)
ON DELETE CASCADE
-- ON DELETE SET NULL
ENABLE NOVALIDATE
;
DELETE FROM tbl_employee
WHERE employee_number = 123; -- OK

COMMIT;
-- Remember: every time you do an ALTER, you implicitly COMMIT all pending transactions
ALTER TABLE tbl_transaction
MODIFY employee_number DECIMAL(4,0) NULL; -- Allow nulls

SELECT * FROM tbl_transaction WHERE employee_number IS NULL;

-- Out of line specification for FK constraints
CREATE OR REPLACE TABLE tbl_transaction2
(
	employee_number INT
	,CONSTRAINT fk_tbl_transaction2_emp_number FOREIGN KEY (employee_number) REFERENCES tbl_employee(employee_number)
);

ALTER TABLE tbl_transaction2
DROP[DISABLE] fk_tbl_transaction2_emp_number;

DROP TABLE tbl_transaction2;
---------------------------------------------------------------------------------------------------
-- How are FK constraints shown in ERDs? (Entity-Relationship Diagram)

-- Oracle SQL Developer:
-- View > Data Modeler > Browser > Relational Models > New Relational Model > Drag and drop tables

-- <> = INDEX
-- *  = NOT NULL
-- P  = PRIMARY KEY
-- U  = UNIQUE
-- UF = UNIQUE + FOREIGN KEY

-- In Oracle, a PRIMARY_KEY constraint automatically creates an INDEX of the same name, 
-- UNLESS you already have an INDEX and you tell the PRIMARY_KEY constraint to just re-use your existing INDEX.
---------------------------------------------------------------------------------------------------
-- Practice Activity Number 14
---------------------------------------------------------------------------------------------------
-- 1 Create a UNIQUE constraint on tbl_category.category_name
ALTER TABLE tbl_category
ADD CONSTRAINT unq_category_name UNIQUE (category_name)
;

-- 2 Add a default value of 1 on tbl_transaction.quantity (It already was NOT NULL)
ALTER TABLE tbl_transaction
MODIFY (quantity NUMBER(4,0) DEFAULT 1 NOT NULL)
;

-- 3 Create a CHECK constraint on tbl_category.product_category_id so that it cannot be negative
ALTER TABLE tbl_category
ADD CONSTRAINT chk_tbl_cat_product_cat_id_non_negative CHECK (product_category_id >= 0)
;

-- 4 Create a PK on tbl_subcategory.product_subcategory_id
ALTER TABLE tbl_subcategory
ADD CONSTRAINT pk_tbl_sub_c_product_sub_id PRIMARY KEY (product_subcategory_id)
;

-- 5 Create a FOREIGN KEY on tbl_product.product_subcategory_id so that future values are limited to the
-- values in the column tbl_subcategory.product_subcategory_id. When setting it up, don't check the existing
-- values in tbl_product.product_subcategory_id
ALTER TABLE tbl_product
ADD CONSTRAINT fk_tbl_product_prod_sub_id FOREIGN KEY (product_subcategory_id)
REFERENCES tbl_subcategory(product_subcategory_id)
ENABLE NOVALIDATE
;

----------------------------------------------------------------------------------------------
-- END OF SESSION 3
----------------------------------------------------------------------------------------------