---------------------------------------------------------------------------------------------------
-- LOOP, END LOOP, CONTINUE, WHILE, FOR
---------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    v_counter NUMBER := 0;
BEGIN
    LOOP
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE('El número es = ' || v_counter);

        /* IF v_counter = 7 THEN
            EXIT;
        END IF; */
        EXIT WHEN v_counter = 7;

    END LOOP;
END;
/
---------------------------------------------------------------------------------------------------
-- CONTINUE
DECLARE
    v_counter NUMBER := 0;
BEGIN
    v_counter := v_counter + 1;

    IF v_counter = 4 THEN
        CONTINUE;
    END IF;

    DBMS_OUTPUT.PUT_LINE('El número es = ' || v_counter);
END;
/
---------------------------------------------------------------------------------------------------
-- WHILE
DECLARE
    v_counter NUMBER := 0;
BEGIN

    WHILE v_counter < 10 LOOP
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE('El número es = ' || v_counter);
    END LOOP;
END;
/
---------------------------------------------------------------------------------------------------
-- FOR
DECLARE
    v_texto  VARCHAR2(25);
BEGIN
    v_texto := 'El valor del numero es = ';

    -- No es necesario declarar 'numero'. Siempre es una variable numérica y es local al ciclo FOR
    FOR numero IN 1..7 LOOP
        DBMS_OUTPUT.PUT_LINE(v_texto || numero);
    END LOOP;
END;
/