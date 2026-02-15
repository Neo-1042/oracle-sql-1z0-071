SET SERVEROUTPUT ON;

DECLARE
    v_first_name VARCHAR2(25);
    v_last_name  VARCHAR2(25);
BEGIN
    v_last_name := 'Hurtado';

    DBMS_OUTPUT.PUT_LINE('Apellido en mayus = ' || UPPER(v_last_name));
    DBMS_OUTPUT.PUT_LINE(SUBSTR(v_last_name,2,2)); -- SUBSTR(var, inicio, fin)
    DBMS_OUTPUT.PUT_LINE(REPLACE('abxdefg', 'x', 'c'));

END;
/

-- Funciones para fechas
DECLARE
    v_fecha DATE;
    v_fecha2 DATE;
    v_fecha3 DATE;
    v_fecha4 DATE;

    v_fecha_texto VARCHAR2(25);
    v_fecha_convertida DATE;
    v_fecha_recortada VARCHAR2(25);

    v_numero_decimal NUMBER;
    v_numero_decimal2 NUMBER;
BEGIN
    v_fecha := sysdate;
    DBMS_OUTPUT.PUT_LINE(v_fecha);

    -- last_day() -> Ultimo dia del mes de la fecha pasada en la variable
    v_fecha2 := LAST_DAY(v_fecha); -- 28/feb/2026 para hoy 14/feb/2026

    -- MONTHS_BETWEEN() -> Meses transcurridos entre dos fechas
    v_fecha3 := DATE'2026-02-14';
    v_fecha4 := DATE'2025-08-16';

    DBMS_OUTPUT.PUT_LINE('Meses transcurridos entre fechas 3 y 4: ');
    DBMS_OUTPUT.PUT_LINE(MONTHS_BETWEEN(v_fecha3, v_fecha4)); -- # meses en número "DOUBLE" (e.g. 3.5814 meses)

    -- TO_DATE(v_string, 'yyyy-mm-dd');
    v_fecha_texto := '07/12/1995';

    v_fecha_convertida := TO_DATE(v_fecha_texto, 'dd/mm/yyyy');

    DBMS_OUTPUT.PUT_LINE(v_fecha_convertida);
    DBMS_OUTPUT.PUT_LINE(v_fecha_convertida + 5); -- +5 dias

    -- TO_CHAR(v_date, )
    v_fecha_recortada := TO_CHAR(v_fecha_convertida, 'dd-mm');

    -- Functiones para numeros.
    v_numero_decimal := 10.5432;
    v_numero_decimal_2 := TRUNC(v_numero_decimal);
    v_numero_decimal_2 := ROUND(v_numero_decimal);

    -- NVL(variable, 'Viene NULL');
    -- NVL2(variable, 'Not null case', 'Null case');


END;
/