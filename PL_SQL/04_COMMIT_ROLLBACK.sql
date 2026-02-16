---------------------------------------------------------------------------------------------------
-- COMMIT y ROLLBACK
-- Oracle SQL es una BD transaccional
---------------------------------------------------------------------------------------------------
SELECT * FROM tbl_employees;

UPDATE tbl_employees
SET first_name = 'Charizard'
WHERE employee_id = 100
; -- Solo yo puedo ver este cambio, pues se realizó solamente para MI SESIÓN.

COMMIT; -- Aquí ya se ven reflejados los cambios para cualquier sesión.

INSERT INTO tbl_regions(region_id, region_name)
VALUES (5, 'Oceania');

COMMIT;

DELETE FROM tbl_regions
WHERE region_id = 5;

ROLLBACK; -- Se deshacen los cambios para todas las sesiones.
-- Se regresa al estado del ÚLTIMO COMMIT

UPDATE tbl_regions
SET region_name = 'Americaaaas'; -- ERROR, UPDATE sin WHERE

ROLLBACK; -- Todo OK, fiu.
---------------------------------------------------------------------------------------------------