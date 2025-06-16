---------------------------------------------------------------------------------------------------
-- FUNCTIONS vs STORED PROCEDURES
---------------------------------------------------------------------------------------------------
-- FUNCTIONS are written for specific tasks or computations, whereas
-- STORED PROCEDURES are used to execute business logic

-- FUNCTIONS return at least one value of any data type. More values can be returned using
-- OUT parameters. STORED PROCEDURES need not return any value

-- FUNCTIONS can be called from SQL statements. But if a FUNCTION has a DML (DIU) operation,
-- then it cannot be called from a SQL statement.
-- STORED PROCEDURES cannot be called from SQL statements

-- PACKAGES are used to group logically related object like TYPES, VARIABLES, CONSTANTS, etc.

-- STORED PROCEDURE (EXEC command) vs TRIGGER (event: DIU operation)
-- TRIGGERs cannot contain DIU operation statements, STORED PROCEDURES can

-- SPs can be invoked from the front end

-- Standalone stored procedure is not defined in a PACKAGE
CREATE PROCEDURE my_prod ;




