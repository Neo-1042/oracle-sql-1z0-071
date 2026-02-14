# Running SQL Scripts from the Command Line

This method runs the script and then immediately exits
SQL*Plus when finished:

```cmd
sqlplus username/password@connect_identifier @"path\to\your\script.sql"

rem @connect_identifier (optional) The Oracle Net db alias
rem if connecting to a specific non-default db instance
rem e.g. @XE, @ORCL

rem Example:
sqlplus HR/admin@XE @"C:\oracle_scripts\create_tables.sql"
```

> You can also omit the password in the command line for
security; SQL*Plus will prompt for it interactively.

# Run within an Active SQL*Plus Session

```sql
sqlplus
-- Enter user: HR
-- Enter password:
-- Enter host string: XE
-- Alternatively:
CONNECT HR/people@XE;

SQL> @"C:\bank\script_01.sql"
```

# Key SQL*Plus Commands for Scripts

```sql
@script.sql -- Run the specified script
@@script.sql -- Run a nested script from within another
-- script, lookin in the same path as the calling script.

SPOOL filename.log -- Directs all subsequent output to a log file
SPOOL OFF -- Stops spooling the output and closes the file.
SET ECHO ON
EXIT -- Exit the SQL*Plus Session
```

# Oracle SQL Developer

To run SQL scripts in Oracle SQL Developer and simulate the
SQL*Plus environment, use the **"Run Script"** functionality
(shortcut F5) and ensure you are using the correct syntax
for SQL*Plus commands, since the IDE has built-in compliance.

1. Open your SQL script in a new worksheet in Oracle SQL
Developer.

2. Click the **"Run Script"** icon (a green arrow next to a
page icon) in the editor toolbar, or press F5.

3. The script will execute. The output, including any errors,
will appear in the "Script Output" pane.

Oracle SQL Developer's script engine supports most core
SQL*Plus commands, which are essential for simulating the
SQL*Plus experience.

| SQL*Plus Command| Description | Oracle SQL Developer Usage |
| :-----  | :----- | :----- |
| `@` or `START` | Runs a specified script from a file | Can be used within a script to call other scripts (`@another.sql`) |
| `SPOOL` | Directs output to an OS log file | `SPOOL 20260213.log` |
| `COLUMN` | Specifies display characteristics and formatting for a column in a report | Fully supported for formatting query results in the script output |
| `PROMPT`/`ACCEPT` | Prompts the user for input and stores it in a variable  | Interactive dialog box |
| `DEFINE` | Defines a user variable  | Used in conjunction with `&` or `&&` substitution syntax |

# master.sql Orchestrator + F5 Run Script

SQL Developer's **"Run Script (F5)"** uses a
SQL*Plus-compatible script engine.
That means that most SQL*Plus commands (@, @@, START, PROMPT,
SPOOL, WHENEVER SQLERROR, SET options) work, so you can drive
your execution from a single `master.sql` file.

Example project layout:
```bash
/sql-scripts
|-- master.sql
    01_schema.sql
    02_objects.sql/
        tables.sql
        views.sql
    03_data.sql
```
