-- 14. Actividad 7 — Retención de datos
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';
-- Cambio a dias para que si me aparezcan porque fueron recientemente agg	  
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '1 day';

-- 15. Verificación final
-- Área de soporte
-- Si debe dejar consultar
SELECT *
FROM v_clientes_soporte;
-- No debe dejar consultar
SELECT *
FROM clientes;

-- Área de analítica
-- Si debe dejar consultar
SELECT *
FROM analitica.clientes;
-- No debe dejar consultar
SELECT *
FROM pii.mapa_cliente;
-- No debe dejar consultar
SELECT *
FROM public.clientes;

-- Información para dirección
-- Debe contener información agregada y no identificadores directos.
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

--Retención
-- Debe existir una consulta que permita identificar los registros que exceden el periodo establecido.
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '2 day';