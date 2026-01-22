-- Bloques PL/SQL
-- 1] ANONYMOUS
-- 2] STORED PROCEDURE
-- 3] FUNCTION
SET SERVEROUTPUT ON; -- Habilitar OUTPUT

-- ANONYMOUS PL/SQL Block:
DECLARE
-- Declaración de variables
    v_mi_texto VARCHAR2(20)
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
