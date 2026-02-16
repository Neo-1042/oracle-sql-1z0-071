---------------------------------------------------------------------------------------------------
-- Oracle SQL Developer > Otros Usuarios > Crear usuario > Roles Otorgados > Otorgar Todo > Aplicar
-- [+] Nueva Conexión de BD > NUEVO_USUARIO, contraseña, localhost, etc.
-- Importar script de esquema nuevo (Run as Script F5)
---------------------------------------------------------------------------------------------------
-- Ejercicio Variables y SQL

DECLARE
    v_anio_alto         NUMBER;
    v_descripcion       VARCHAR2(255);
    v_descripcion_corta VARCHAR2(40);
    v_anio              NUMBER;
    v_id_pelicula       NUMBER;
BEGIN
    -- 1. Trae e imprime el año de estreno más alto
    SELECT max(anio)
        INTO v_anio
    FROM tbl_pelicula;

    -- 2. Trae la descripción de la película "Coco". Si es nula, reemplazar
    SELECT NVL(descripcion, 'SIN DESCRIPCION')
        INTO v_descripcion
    FROM tbl_pelicula
    WHERE id = 6;

    -- 3. Descripción corta de cualquier película con el siguiente formato:
    -- (anio_estreno) - Primeros 40 caracteres de la descripcion
    SELECT descripcion, anio
        INTO v_descripcion, v_anio
    FROM tbl_pelicula
    WHERE id_pelicula = 1;

    v_descripcion_corta := SUBSTR(v_descripcion, 1, 40);

END;
/
---------------------------------------------------------------------------------------------------