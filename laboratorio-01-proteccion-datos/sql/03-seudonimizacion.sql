-- 9. Actividad 3 — Seudonimización (pseudonymization)
-- 9.1 Crear los esquemas
CREATE SCHEMA pii;

CREATE SCHEMA analitica;

-- 9.2 Crear la tabla de correspondencia
CREATE TABLE pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE
        REFERENCES public.clientes(id)
);

-- 9.3 Generar los tokens
CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- Generar un token para cada cliente:
INSERT INTO pii.mapa_cliente
(token, cliente_id)
SELECT
    gen_random_uuid(),
    id
FROM clientes;
-- Verificar:
SELECT *
FROM pii.mapa_cliente;
-- 10. Crear el conjunto de datos para analítica
CREATE TABLE analitica.clientes AS
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente m
JOIN clientes c
    ON c.id = m.cliente_id;
	
-- Verificar:
SELECT *
FROM analitica.clientes;

-- Crear el rol:
CREATE ROLE analista_vanessa_calderon NOLOGIN;

-- Conceder acceso al conjunto de datos analítico:
GRANT USAGE
ON SCHEMA analitica
TO analista_vanessa_calderon;

GRANT SELECT
ON analitica.clientes
TO analista_vanessa_calderon;

-- 11.1 Verificar los permisos
-- El acceso al conjunto analítico debe estar permitido:
SELECT *
FROM analitica.clientes;
-- El acceso al mapa de correspondencia debe estar restringido:
SELECT *
FROM pii.mapa_cliente;
-- También debe estar restringido el acceso directo a los datos originales:
SELECT *
FROM public.clientes;