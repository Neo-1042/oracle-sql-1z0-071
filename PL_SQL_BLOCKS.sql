-- PL/SQL blocks basics
-- DBEE = DECLARE, BEGIN, EXCEPTION, END;

set serveroutput on;
DECLARE
	-- Definir variables, procedimientos y funciones
BEGIN
	DBMS_OUTPUT.PUT_LINE('Hola, mundo de Oracle PL_SQL');
	DBMS_OUTPUT.PUT('MacBook ');
	DBMS_OUTPUT.PUT_LINE('Air M1');
END;
/ -- Opcional, pero se coloca para indicar el fin del bloque PLSQL
-- (Tiene otra funcionalidad, pero la estudiaremos después)
---------------------------------------------------------------------------------------------------
-- VARIABLES BÁSICAS
set serveroutput on;
DECLARE
	salario NUMBER := 1500;
	nombre_empleado NVARCHAR2(100);
	activo BOOLEAN;
	fecha DATE;
BEGIN
	nombre_empleado := 'Rodrigo Hurtado';
	activo := true;
	fecha := sysdate;

	DBMS_OUTPUT.PUT_LINE('Datos del empleado ' || nombre);
	DBMS_OUTPUT.PUT_LINE('Salario: ' || salario);
	DBMS_OUTPUT.PUT_LINE('Fecha: ' || fecha);
	DBMS_OUTPUT.PUT_LINE('Activo: ' || CASE WHEN activo THEN 'SI' ELSE 'NO' END);
END;
/
---------------------------------------------------------------------------------------------------
-- CONSTANTES
DECLARE
	-- CONSTANTES en MAYUSCULAS
	PI CONSTANT NUMBER := 3.14159;

	-- Variables
	area NUMBER;
	radio NUMBER;
BEGIN
	radio := 5;
	 
	area := PI * (radio * radio);
	DBMS_OUTPUT.PUT_LINE('El area del circulo es = ' || ROUND(area,2) || 'cm^2');
END;
/
---------------------------------------------------------------------------------------------------
-- Asignación de variables con queries SQL
-- SELECT campo INTO v_foo FROM DUAL;
SELECT user FROM DUAL;

set serveroutput on;
DECLARE
	cantidad NUMBER;
	usuario NVARCHAR2(100);
BEGIN
	SELECT user, COUNT(*) INTO usuario, cantidad FROM DUAL;
	dbms_output.put_line('Usuario = ' || usuario);
	dbms_output.put_line('Cantidad = ' || cantidad);
END;
/

-- Funciones de Oracle SQL llamadas dentro del bloque PL/SQL
set serveroutput on;
DECLARE
	nombre NVARCHAR2(100) := '   Rodrigo  ';
	apellido NVARCHAR2(100) := '  Hurtado ';
	hoy DATE := sysdate;
BEGIN
	nombre := TRIM(nombre);
	apellido := TRIM(apellido);

	-- Funciones de STRING
	dbms_output.put_line('Largo del nombre = ' || LENGTH(nombre));
	dbms_output.put_line('Nombre completo MAYUS = ' || UPPER(nombre) || ' ' || UPPER(apellido)); 
	dbms_output.put_line('Cortar: ' || SUBSTR(nombre, 1, 3)); -- Rod

	-- Funciones de DATE

END;
/