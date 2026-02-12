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
/
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
-------------------------------------------------------------------------------------------------
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
/
---------------------------------------------------------------------------------------------------