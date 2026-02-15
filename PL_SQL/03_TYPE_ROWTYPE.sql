---------------------------------------------------------------------------------------------------
-- %TYPE ---> Anchored type
---------------------------------------------------------------------------------------------------
DECLARE
    -- v_job_id NUMBER; -- Error, pues es VARCHAR2
    v_job_id employees.job_id%TYPE; -- Mismo tipo de dato que el de la tabla "employees"
BEGIN
    SELECT e.job_id
        INTO v_job_id
    FROM employees e
    WHERE e.employee_id = 134;
END;
/
---------------------------------------------------------------------------------------------------
-- %ROWTYPE
---------------------------------------------------------------------------------------------------
DECLARE
    v_job           tbl_jobs%ROWTYPE;
    v_desc          tbl_jobs.job_title%TYPE;
    v_min_salary    tbl_jobs.min_salary%TYPE;
BEGIN
    SELECT j.*
        INTO v_job -- Guarda todo los campos del registro completo
    FROM tbl_jobs j
    WHERE j.job_id = 'IT_PROG';

    v_desc := v_job.job_title;
    v_min_salary := v_job.min_salary;

    DBMS_OUTPUT.PUT_LINE('Para el trabajo con titulo = ' || v_desc || ' el salario minimo es = ' );
    DBMS_OUTPUT.PUT_LINE(v_min_salary);
END;
/
-- INSERT + UPDATE. UPDATE tbl SET ROW = array WHERE id = 10;
DECLARE
    v_new_job   tbl_jobs%ROWTYPE; -- Es como un array, guardando los datos de una fila
BEGIN
    v_new_job.job_id = 'DBA';
    v_new_job.job_title = 'Database Administrator';
    v_new_job.min_salary = 45000;
    v_new_job.max_salary = 150000;

    INSERT INTO tbl_jobs VALUES v_new_job;
    COMMIT;

    UPDATE tbl_jobs
    SET ROW = v_new_job
    WHERE job_id = 'DBA';
    COMMIT;

END;
/