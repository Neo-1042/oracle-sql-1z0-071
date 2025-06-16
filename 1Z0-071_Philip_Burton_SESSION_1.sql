-- Oracle Database 11g, 12c, 19c, 21c
-- 1Z0-071

-- GROUP BY
SELECT name
FROM col_tbl
WHERE col# > 3;

SELECT name
FROM col_tbl
WHERE col# > 3
GROUP BY name
;

SELECT name, COUNT(*) AS "Number of times"
FROM col_tbl
WHERE col# = 1
GROUP BY name
; 

SELECT name, last_name, COUNT(*) AS "Number of times"
FROM tlb_names
GROUP BY name, last_name
;

--------------------------------------------------------------------------------------------------
-- HAVING clause (least used)
-- Equivalent of a 'WHERE' clase after the GROUP BY has been done

-- Motivation: suppose I have a query that gets me the number of units that a model of iPad
-- has been sold. iPad mini => 978 M, iPad Pro M2 11" => 829 M, and so on.
-- So, you'd query something like this:
SELECT iPad_model, units_sold, COUNT(*) AS "Number of sold units"
FROM iPad_Sales -- In reality, this would be an 'join' query
GROUP BY iPad_model, units_sold
;
-- But now, I would like to filter by a minimum # of iPad sales, say, 500 M units sold.
-- Then, I must add the "HAVING" clause

SELECT iPad_model, units_sold, COUNT(*) AS "Number of sold units"
FROM iPad_Sales -- In reality, this would be an 'join' query
GROUP BY iPad_model, units_sold
HAVING COUNT(*) >= 500000000
;
-- COUNT(*) need not be in the SELECT part of the query
-- techonthenet.com => Oracle SQL Documentation with examples
--------------------------------------------------------------------------------------------------
-- ORDER BY
SELECT * 
FROM iPad_Sales
ORDER BY processor_clock_speed DESC, name ASC
;

-- Order of execution by the SQL engine
        5 SELECT
1 FROM
  2 WHERE
    3 GROUP BY
      4 HAVING
          6 ORDER BY
;
--------------------------------------------------------------------------------------------------
-- Creating tables (DDL = Data Definition Language)

CREATE TABLE iPad_Models
(
	year_of_release NUMBER(4,0),
	model VARCHAR(50)
);

-- Inserting and deleting records (DIU operations => DML = Data Manipulation Language)
INSERT INTO iPad_Models (year_of_release, model)
VALUES (2010, "iPad 4");
COMMIT;

DELETE FROM iPad_Model 
WHERE year_of_release = 2010 AND model = "iPad 4";
COMMIT;

-- What is the difference between DELETE FROM and TRUNCATE TABLE ??
TRUNCATE TABLE iPad_Models; -- Does NOT allow a WHERE clause

DROP TABLE iPad_Models; -- This completely erases the table, not only its data
--------------------------------------------------------------------------------------------------
CREATE TABLE tbl_employee
(
	id NUMBER,
	name VARCHAR(30),
	last_name VARCHAR(30),
);

-- The DUAL table
SELECT 1+12 AS RESULT
FROM DUAL; -- DUMMY column with an 'X' value

DROP TABLE tbl_employee;
CREATE TABLE tbl_employee ();

-- NUMERIC TYPE(precision, scale) in Oracle SQL

-- Default is
NUMERIC = NUMERIC(38,0)

-- Precision => Number of total digits to be held
-- Scale => Number of digits after the decimal point

-- e.g. 12345.67
-- Precision = 7
-- Scale = 2
NUMERIC(7,2) -- 12345.67

NUMERIC(7,7) -- 0.1234567
---------------------------------------------------------

DROP TABLE testing_numbers;
CREATE TABLE testing_numbers
(
	my_field NUMERIC(6,3)
);

INSERT INTO testing_numbers(my_field)
VALUES (1555.5555); -- does not entirely fit
COMMIT;

SELECT * FROM testing_numbers;
---------------------------------------------------------------------------------------------------
-- DECIMAL == NUMERIC (official/native Oracle SQL)
---------------------------------------------------------------------------------------------------
-- It is NOT RECOMMENDED to use FLOAT
-- FLOAT(precision)
FLOAT(20) -- Stores everything in binary
-- FLOAT 0.1 is NOT stored precisely
BINARY_FLOAT == FLOAT(32)

-- Use DECIMAL(p,s) or NUMERIC(p,s) instead
---------------------------------------------------------------------------------------------------
-- Character data types
CHAR 			-- Fixed length, unknown encoding system
NCHAR 			-- N refers to UNICODE
VARCHAR2        -- Variable length, computer decides encoding system. 10 Bytes, ? characters.
NVARCHAR2       -- UNICODE
-- VARCHAR might change in the future. Thus, it is NOT recommended
-- NCHAR and NVARCHAR2 are the most recommended.
NVARCHAR2 -- Ranges from 10 to 4000 characters (or bytes)

CHAR(100) -- Will allocate 100 places for whatever string you put into it
					-- The remainder (if any) will be filled with spaces.
LENGTH(my_field)
LENGTHB(my_field) -- Length in bytes

DROP TABLE tbl_numeric_examples;

CREATE TABLE tbl_numeric_examples
(
	my_field VARCHAR2(5 CHAR),
	my_field2 VARCHAR2(5 CHAR),
);
---------------------------------------------------------------------------------------------------
-- NULL

INSERT INTO tbl_names (FIRSTNAME, LASTNAME, MIDDLENAME)
VALUES ('JOHN', 'DOE', 'MURIEL');

INSERT INTO tbl_names (FIRSTNAME, LASTNAME, MIDDLENAME)
VALUES ('PATRICK', 'SMITH', NULL);

-- What if MIDDLENAME is NULL?
SELECT 
FIRSTNAME, LASTNAME, MIDDLENAME,
FIRSTNAME || ' ' || NVL(MIDDLENAME, '(no middle name)') || ' ' || LASTNAME AS FULLNAME
FROM DUAL;

-- NVL2(expr1, not_null_case, null_case)
NVL2(MIDDLENAME, ' ' || MIDDLENAME, ' ')

-- COALESCE takes the FIRST not null argument
COALESCE(arg1, arg2, arg3, '(no args provided)')

-- NULLIF(arg1, arg2)
-- If arg1 == arg2, then return NULL. else, return arg1

SELECT
	REPLACE('The first person is called Simon', 'first', 'second') AS RESULT
FROM DUAL;

-- Escaping quotation marks
-- Using pairs of delimiters with Q = quote: 
-- <> [] () !!
SELECT 'Graham''s Book' AS RESULT
FROM DUAL;

SELECT Q'!Graham's Book!' AS RESULT
FROM DUAL;

SELECT Q'(Graham's Book)' AS RESULT
FROM DUAL;

SELECT 'The total cost is $' || '10542 MXN' AS COST
FROM DUAL;

-- Formatting money
TO_CHAR(1234.0, 'TM') -- Text Minimum
TO_CHAR(-1237.10.0, '9999.99')

SELECT 'The total cost is $' || TO_CHAR(10542.00, '9999.99') AS COST
FROM DUAL;

TO_CHAR(0.9,'999990.99')
-----------------------------------------------
SELECT 'The total cost is: ' || TO_CHAR(-1234567.89, 'S$9G999G999G999D99') AS total_cost
FROM DUAL; -- Notice the G for grouping and the D for decimal dot
-- Converting a String into a Number
SELECT 1 + TO_NUMBER('12345') AS result
FROM DUAL;

SELECT 1 + TO_NUMBER('1,234,567.99', '9,999,999.99') AS result
FROM DUAL;

-- DEFAULT NULL ON CONVERSION ERROR
SELECT 1 + TO_NUMBER('$1,234,567.99' DEFAULT 0 ON CONVERSION ERROR, '9,999,999.99') AS result
FROM DUAL;
SELECT 1 + TO_NUMBER('$1,234,567.99' DEFAULT NULL ON CONVERSION ERROR, '9,999,999.99') AS result
FROM DUAL; -- Better default value (NULL)

-- CAST() allows a much wider range of data types to convert to
SELECT CAST('$1,234,567.99' AS NUMBER, '$9,999,999.99') AS result
FROM DUAL; 

-- International conversions. TO_NUMBER('1234', '9999999.99', x)
-- National Language Support
NLS_NUMERIC_CHARACTERS 
NLS_CURRENCY
NLS_ISO_CURRENCY

SELECT TO_CHAR(1234567.89, 'L999G999G999G999D99'
								, 'NLS_NUMERIC_CHARACTERS = '',.'' NLS_CURRENCY = ''€''') AS Result
FROM DUAL;
-----------------------------------------------------------------------------------------
-- More Data Types
-- DATE and TIMESTAMP
-- Japan: 2025-03-10

DROP TABLE tbl_dates_demo;

CREATE TABLE tbl_dates_demo
(my_date DATE,
my_timestamp TIMESTAMP(6) -- DEFAULT: 6 decimal places
);

INSERT INTO tbl_dates_demo(my_date)
VALUES (DATE '2025-03-10');
COMMIT;

INSERT INTO tbl_dates_demo(my_date)
VALUES (TIMESTAMP '2025-03-10 11:06:30')

SELECT * FROM tbl_dates_demo;

-- DATE and TIMESTAMP functions
SELECT my_date + 1 as RESULT -- +1 day
FROM tbl_dates_demo;

SELECT my_date + 3/24 as RESULT -- +3 hours
FROM tbl_dates_demo;

SELECT ADD_MONTHS(my_date,1) as RESULT -- +1 month
FROM tbl_dates_demo;

SELECT ADD_MONTHS(my_date,-1) as RESULT -- -1 month
FROM tbl_dates_demo;

ROUND(my_date) -- Rounds up or down depending on time being past or before 12:00:00 hrs
TRUNC(my_date) -- Chops off the time after 00:00:00 hrs
LAST_DAY(my_date) -- Last day of the month
NEXT_DAY(my_date, 'MONDAY') -- Get the next monday from 'my_date'

-- EXTRACT works only with TIMESTAMP
EXTRACT(YEAR FROM my_timestamp)
EXTRACT(MONTH FROM my_timestamp)
EXTRACT(DAY FROM my_timestamp)
EXTRACT(HOUR FROM my_timestamp)

SELECT my_date, TRUNC(my_date) - EXTRACT(DAY FROM my_date) + 1 AS RESULT
FROM DUAL;

my_timestamp1 - my_timestamp2
MONTHS_BETWEEN(my_timestamp2, my_timestamp1)

SELECT current_date, sysdate, current_timestamp
FROM DUAL;
----------------------------------------------------------------------------------------------
-- Converting DATES to STRINGs
-- YeaR: First (Y) vs last(R) letter
SELECT 'The date is: ' || TO_CHAR(sysdate, 'YYYY') AS result
FROM DUAL;

SELECT 'The date is: ' || TO_CHAR(sysdate, 'RRRR AD') AS result
FROM DUAL;

SELECT 'The date is: ' || TO_CHAR(sysdate, 'DDD') AS result
FROM DUAL; -- 14/365 days of the year

SELECT 'The date is: ' || TO_CHAR(sysdate, 'DL') AS result
FROM DUAL; -- Date Local

SELECT 'The date is: ' || TO_CHAR(sysdate, 'IW') AS result
FROM DUAL; -- Week number x

SELECT 'The date is: ' || TO_CHAR(sysdate, 'IYYY') AS result
FROM DUAL; -- ISO year
----------------------------------------------------------------------------------------------
-- Converting STRING to DATE
-- NLS_DATE_LANGUAGE = Spanish
SELECT 
	TO_DATE('Diciembre 16, 2022, 09:45 am', 'Month DD, YYYY, HH12:MI am', 'NLS_DATE_LANGUAGE = Spanish')
FROM DUAL;
----------------------------------------------------------------------------------------------
SELECT DATE '2025-03-11' AS fecha_actual
FROM DUAL;

SELECT ADD_MONTHS(current_timestamp, +1) AS fecha_mas_1_mes
FROM DUAL;

SELECT EXTRACT(MONTH FROM current_timestamp) AS mes_actual
FROM DUAL;

SELECT TRUNC(TIMESTAMP '2025-03-11 20') AS time_stamp_custom
FROM DUAL;

SELECT sysdate, current_date, current_timestamp
FROM DUAL;

-- Convert an american string into a date:
SELECT TO_DATE('02/03/2030 11:30:33', 'MM/DD/YYYY HH:MI:SS') AS fecha_convertida
FROM DUAL;

----------------------------------------------------------------------------------------------
-- END OF SESSION 1
----------------------------------------------------------------------------------------------