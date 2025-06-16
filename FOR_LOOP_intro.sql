-- FOR LOOP

SET SERVEROUTPUT ON;

BEGIN
	<<ciclo_tabla_2>>
	FOR i IN 1..10 LOOP
		--DBMS_OUTPUT.PUT_LINE(i || '* 2 = ' || (i*2));
		DBMS_OUTPUT.PUT(i);
		DBMS_OUTPUT.PUT(' * 2 = ');
		DBMS_OUTPUT.PUT_LINE(i*2);
	END LOOP ciclo_tabla_2;

END;
/
-- EXIT and CONTINUE

DECLARE


BEGIN
	<<continue_exit>>
	FOR i IN 1..10 LOOP
		IF (i=5) THEN
			-- EXIT
			CONTINUE
		END IF;

		DBMS_OUTPUT.PUT(i);
		DBMS_OUTPUT.PUT(' * 2 = ');
		DBMS_OUTPUT.PUT_LINE(i*2);

	END LOOP continue_exit;

	<<pares>>
	FOR i IN 1..10 LOOP

		IF ( MOD(i,2) = 0 ) THEN
			CONTINUE;
		END IF;

		DBMS_OUTPUT.PUT(i);
		DBMS_OUTPUT.PUT(' * 2 = ');
		DBMS_OUTPUT.PUT_LINE(i*2);
	END LOOP PARES;

END;
/
---------------------------------------------------------------------------------------------------
-- Basic LOOP (indefinite repetitions)
BEGIN
	LOOP
		dbms_output.put_line(x);
		x := x + 10;
		IF ( x > 120 ) THEN
			EXIT;		
		END IF;
	END LOOP;
END;
/
---------------------------------------------------------------------------------------------------
-- WHILE LOOP

DECLARE
	y NUMBER := 20;
BEGIN
	
	WHILE y < 100 LOOP
		dbms_output.put_line(y);
		y := y + 20;

	END LOOP;
END;
/
---------------------------------------------------------------------------------------------------
-- TAREA 1 de CICLOS
-- Dado el siguiente código PL/SQL, determine el promedio de las notas contenidas en el arreglo

-- SET SERVEROUTPUT ON;

DECLARE
	type notasArray IS VARRAY(4) OF NUMBER;
	notas notasArray := notasArray(95,60,75,85);

	promedio NUMBER(6,2) := 0;
BEGIN
	
	FOR n IN 1..4 LOOP
		promedio := promedio + notas(i);
	END LOOP;

	promedio := promedio / 4;

	dbms_output.put_line('El promedio es: ' || promedio);
END;
/
---------------------------------------------------------------------------------------------------
-- TAREA 2 de CICLOS
-- Obtener el factorial de un número usando ciclos PL/SQL

DECLARE
	numero NUMBER := 4;
	factorial NUMBER;
BEGIN
	factorial := numero;

	<<factorial>>
	WHILE (numero > 1) LOOP
		numero := numero - 1;
		factorial := factorial * numero;
	END LOOP factorial;

	dbms_output.put_line('El factorial de ' || numero || ' es = ' || factorial );
END;
/
---------------------------------------------------------------------------------------------------