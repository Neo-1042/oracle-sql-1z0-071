-- Bloques PL/SQL
-- 1] ANONYMOUS
-- 2] STORED PROCEDURE
-- 3] FUNCTION
SET SERVEROUTPUT ON; -- Habilitar OUTPUT

-- ANONYMOUS PL/SQL Block:
DECLARE
-- Declaración de variables
    v_mi_texto VARCHAR2(20);
BEGIN
    v_mi_texto := '¡Hola, mundo!';
    DBMS_OUTPUT.PUT_LINE(v_mi_texto);
EXCEPTION
    WHEN OTHERS
END;
---------------------------------------------------------------------------------------------------
DECLARE
    nombre VARCHAR2(20);
    edad   NUMBER;
    f_nacimiento DATE;
    acepta_terminos BOOLEAN;
    -- Si agregamos 'NOT NULL', debemos asignar un valor en esta sección.
    salario NUMBER NOT NULL := 45000;
    -- Constantes:
    sexo constant VARCHAR2 := 'Masculino';
BEGIN
    nombre := 'Rodrigo';
    edad := 30;
    f_nacimiento := DATE'1995-12-07';
    acepta_terminos := true;

    nombre := &mi_valor; -- Antes de la ejecución, lanza prompt para ingresar un valor (entre comillas simples)

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || nombre);
    DBMS_OUTPUT.PUT_LINE('Edad: ' || edad);
    DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: ' || f_nacimiento);
END;
---------------------------------------------------------------------------------------------------
-- SELECT INTO
-- Si dejamos un SELECT * FROM tbl WHERE condition; solo, habrá un error, porque se debe hacer
-- algo con el (los) resultado(s) obtenido(s).
---------------------------------------------------------------------------------------------------
DECLARE
    v_first_name VARCHAR2(15);
    v_last_name VARCHAR2(15);
    v_salary employees.salary%TYPE; -- Anchored type
BEGIN
    -- El número de variables debe coincidir con los resultados obtenidos
    SELECT e.first_name, e.last_name 
        INTO v_first_name, v_last_name
    FROM employees e
    WHERE e.employee_id = 100;

    DBMS_OUTPUT.PUT_LINE('Nombre del empleado con id 100 = ' || v_first_name || ' ' || v_last_name);
END;
---------------------------------------------------------------------------------------------------