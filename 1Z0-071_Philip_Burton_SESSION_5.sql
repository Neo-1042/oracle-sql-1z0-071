---------------------------------------------------------------------------------------------------
-- 1Z0-071 Oracle SQL Database
-- SESSION 5
-- START = 20261028
-- LAST REVIEW = 20261028
---------------------------------------------------------------------------------------------------
-- GROUP FUNCTIONS
-- SUBQUERIES
-- SELF JOIN
---------------------------------------------------------------------------------------------------
-- ADDING TOTALS
-- Original query:
SELECT
	department
	,employee_number
	,attendance_month
	,sum(number_attendance) AS number_attendance -- total = 35366
FROM tbl_employee JOIN tbl_attendance
USING (employee_number) -- Oracle SQL syntax
GROUP BY department, employee_number, attendance_month
ORDER BY department, employee_number, attendance_month
;

-- Adding a Total per employee
SELECT
	department
	,employee_number
	,attendance_month AS attendance_month -- TIMESTAMP: must match
	,sum(number_attendance) AS number_attendance
FROM tbl_employee JOIN tbl_attendance
USING (employee_number)
GROUP BY department, employee_number, attendance_month
	UNION -- to add total per employee with the 'null' field
SELECT
	department
	,employee_number
	,null -- Gives you the TOTAL
	-- ,TO_DATE('2999-01-01','YYYY-MM-DD')
	,sum(number_attendance) AS number_attendance
FROM tbl_employee JOIN tbl_attendance
USING (employee_number)
GROUP BY department, employee_number -- NOTICE: no 'attendance_month' in here
ORDER BY department, employee_number, attendance_month
	UNION -- to add
SELECT
	department
	,null
	,null
	,sum(number_attendance) AS number_attendance
FROM tbl_employee JOIN tbl_attendance
USING (employee_number)
GROUP BY department -- NOTICE: no 'attendance_month', nor 'employee_number' in here.
ORDER BY department, employee_number, attendance_month
;





---------------------------------------------------------------------------------------------------
-- END OF SESSION 5
---------------------------------------------------------------------------------------------------