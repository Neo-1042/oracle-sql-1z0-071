-- Query to find all column_names that are like some string:

SELECT owner, table_name, column_name
FROM all_tab_columns
WHERE column_name LIKE '%BRANCH%';