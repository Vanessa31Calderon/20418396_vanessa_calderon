-- 8. Actividad 2 — Principio de minimización
-- Crea una tabla que contenga únicamente los datos necesarios para la finalidad de soporte:
CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

-- Carga información a partir de clientes:
INSERT INTO clientes_soporte (
    id,
    nombre,
    correo,
    telefono
)
SELECT
    id,
    nombre,
    correo,
    telefono
FROM clientes;

-- Consulta:
SELECT *
FROM clientes_soporte;
