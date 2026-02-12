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
/ -- Opcional, pero se coloca para indicar el fin del bloque PLSQL
-- (Tiene otra funcionalidad, pero la estudiaremos después)
---------------------------------------------------------------------------------------------------
-- Funciones de Oracle SQL llamadas dentro del bloque PL/SQL
SET SERVEROUTPUT ON;
DECLARE
	v_nombre NVARCHAR2(100) := '   Rodrigo  ';
	v_apellido NVARCHAR2(100) := '  Hurtado ';
	v_hoy DATE := sysdate;
BEGIN
	v_nombre := TRIM(v_nombre);
	v_apellido := TRIM(v_apellido);

	-- Funciones de STRING
	dbms_output.put_line('Largo del nombre = ' || LENGTH(v_nombre));
	dbms_output.put_line('Nombre completo MAYUS = ' || UPPER(v_nombre) || ' ' || UPPER(v_apellido)); 
	dbms_output.put_line('Cortar: ' || SUBSTR(v_nombre, 1, 3)); -- SUBSTR(string, inicio, longitud)

	-- Funciones de DATE

END;
/
---------------------------------------------------------------------------------------------------
-- DELETE, INSERT, UPDATE dentro de bloques PL/SQL (DML operations)
---------------------------------------------------------------------------------------------------
DECLARE
    v_salario_max NUMBER;
    v_salario_nuevo NUMBER := 100000;
    UMA CONSTANT NUMBER := 140;
BEGIN

SELECT max(salary)
INTO v_salario_max
FROM employees;

DBMS_OUTPUT.PUT_LINE('El salario maximo es = ' || v_salario_max);

UPDATE employees
SET salary = 80000
WHERE salary < 10 * UMA;

END;
/

-- INSERT de país 'Korea' en la tabla de países.
DECLARE
    v_region_id NUMBER;
    v_country_name VARCHAR(10);
    v_country_id VARCHAR(4);
BEGIN
    -- Obtener ID de la region para Asia
    SELECT region_id
        INTO v_region_id
    FROM tbl_regions
    WHERE region_name = 'Asia';

    v_country_name := 'Korea';
    v_country_id := 'KR';

    INSERT INTO tbl_countries (country_id, country_name, region_id)
    VALUES (v_country_id, v_country_name, v_region_id);
    COMMIT;

END;
/

-- DELETE 'Korea'
DECLARE
    v_country_id VARCHAR(2);
BEGIN
    SELECT country_id
        INTO v_country_id
    FROM tbl_countries
    WHERE country_name = 'Korea';

    DELETE FROM tbl_countries
    WHERE countr_id = v_country_id;

    COMMIT;
END;
/
---------------------------------------------------------------------------------------------------