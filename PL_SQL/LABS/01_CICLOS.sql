-- 1] Dada una determinada opinión, si fue de 1 ó 2 puntos, llenar con
-- una variable con el valor "MALA". Si fue de 3 ó 4, "BUENA"
-- Si es de 5 puntos, "EXCELENTE". Luego, imprimir el resultado junto al título de la película.
DECLARE
    v_id_opinion NUMBER;
    v_id_pelicula NUMBER;
    v_puntuacion NUMBER;
    v_calificacion VARCHAR2(10);
    v_titulo VARCHAR2(10);
BEGIN

    v_id_opinion := 16;

    SELECT puntuacion, id_pelicula
        INTO v_puntuacion, v_id_pelicula
    FROM tbl_opiniones
    WHERE id_opinion = v_id_opinion;

    SELECT titulo INTO v_titulo
    FROM tbl_pelicula
    WHERE id_pelicula = v_id_pelicula;

    CASE
        WHEN v_puntuacion IN (1,2) THEN
            v_calificacion := 'Mala';
        WHEN v_puntuacion IN (3,4) THEN
            v_calificacion := 'Buena';
        WHEN v_puntuacion = 5 THEN
            v_calificacion := 'Excelente';
        ELSE 'Puntuacion no valida';
    END CASE;
END;
/

-- 2] Calcular la potencia entera de un número cualquiera e imprimir el resultado.

DECLARE
    v_base NUMBER;
    v_exponente NUMBER;
    v_resultado NUMBER;
    v_contador NUMBER;
BEGIN
    v_base := 2;
    v_exponente := 4;
    v_resultado := 1;

    WHILE (v_contador <= v_exponente) LOOP
        v_resultado := v_resultado * v_base;
        v_contador := v_ contador + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Resultado = ' || v_resultado);
END;
/