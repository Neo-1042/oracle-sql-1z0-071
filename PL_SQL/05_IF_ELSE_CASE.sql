---------------------------------------------------------------------------------------------------
-- IF, END IF, ELSE
---------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    v_edad NUMBER;
BEGIN 
    v_edad := 25;

    -- Los paréntesis son opcionales
    IF (v_edad >= 18) THEN
        DBMS_OUTPUT.PUT_LINE('Eres mayor de edad');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Eres menor de edad');
    END IF;
END;
/
---------------------------------------------------------------------------------------------------
DECLARE
    v_salary NUMBER;
BEGIN
    SELECT e.salary INTO v_salary
    FROM tbl_employees e
    WHERE e.employee_id = 200;

    IF (v_salary > 1000 AND v_salary <= 5000) THEN
        DBMS_OUTPUT.PUT_LINE('Empleado de categoría C');
    ELSIF (v_salary > 5000 AND v_salary <= 10000) THEN
        DBMS_OUTPUT.PUT_LINE('Empleado de categoría B');
    ELSIF (v_salary > 10000) THEN
        DBMS_OUTPUT.PUT_LINE('Empleado de categoría A');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salario no valido');
    END IF;

    -- BETWEEN (Intervalo cerrado, es decir, incluye los extremos.
END;
/
---------------------------------------------------------------------------------------------------
-- CASE expr
---------------------------------------------------------------------------------------------------
DECLARE
    v_departamento tbl_department.department_name%TYPE;
BEGIN
    SELECT d.department_name
        INTO v_departamento
    FROM tbl_department d
    WHERE d.department_id = 200;

    CASE v_departamento
        WHEN 'Operations' THEN 
            DBMS_OUTPUT.PUT_LINE('El departamento se encuentra en el piso 4');
        WHEN 'IT Support' THEN
            DBMS_OUTPUT.PUT_LINE('El departamento se encuentra en el piso 3');
        WHEN 'NOC' THEN
            DBMS_OUTPUT.PUT_LINE('El departamento se encuentra en el piso 3');
    ELSE 'Departamento no valido'
    END CASE;
END;
/
---------------------------------------------------------------------------------------------------
-- SEARCHED CASE
---------------------------------------------------------------------------------------------------
DECLARE
    v_departamento tbl_department.department_name%TYPE;
BEGIN
    SELECT d.department_name
        INTO v_departamento
    FROM tbl_department d
    WHERE d.department_id = 200;

    CASE 
        WHEN v_departamento = 'Operations' THEN 
            DBMS_OUTPUT.PUT_LINE('El departamento se encuentra en el piso 4');
        WHEN v_departamento IN ('IT Support','NOC','IT Help Desk') THEN
            DBMS_OUTPUT.PUT_LINE('El departamento se encuentra en el piso 3');
    ELSE 'Departamento no valido'
    END CASE;
END;
/
---------------------------------------------------------------------------------------------------