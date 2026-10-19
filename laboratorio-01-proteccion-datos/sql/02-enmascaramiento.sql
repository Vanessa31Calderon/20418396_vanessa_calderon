 -- 8. Actividad 2 — Enmascaramiento (masking)
 -- 8.1 Crear el rol
CREATE ROLE soporte_vanessa_calderon NOLOGIN;

ALTER ROLE soporte_vanessa_calderon LOGIN
PASSWORD 'Soporte12';

--8.2 Crear una vista de acceso restringido
CREATE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,

    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,

    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,

    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc

FROM clientes;

SELECT * FROM v_clientes_soporte;

-- 8.3 Conceder acceso a la vista
GRANT USAGE
ON SCHEMA public
TO soporte_vanessa_calderon;

GRANT SELECT
ON v_clientes_soporte
TO soporte_vanessa_calderon;

-- Revocar el acceso directo a la tabla:
REVOKE ALL
ON clientes
FROM soporte_vanessa_calderon;

-- 8.4 Verificar el resultado
SELECT * FROM v_clientes_soporte;
-- El acceso directo a la tabla debe estar restringido para el rol soporte:
SELECT * FROM clientes;