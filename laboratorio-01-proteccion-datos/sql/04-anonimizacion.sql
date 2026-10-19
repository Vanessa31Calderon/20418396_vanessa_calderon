-- 12. Actividad 5 — Anonimización (anonymization)
-- 12.1 Generalizar la edad
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

-- 12.2 Generalizar la región
SELECT
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

-- 12.3 Combinar atributos
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2;

-- 12.4 Suprimir grupos pequeños
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2


-- Reto
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    RIGHT(telefono, 2) AS terminacion_numero,

    COUNT(*) AS total
FROM clientes
GROUP BY 1, 2, 3;


-- 	Para que la consulta muestre los datos, omití esta instrucción porque hay muy pocos datos HAVING COUNT(*) >= 5;

SELECT * FROM CLIENTES