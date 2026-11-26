-- Comentarios en la tabla y columnas de public.clientes
COMMENT ON TABLE clientes IS 'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificación: confidencial (contiene datos personales).';
COMMENT ON COLUMN clientes.id IS 'Identificador interno del cliente. Generado por el sistema.';
COMMENT ON COLUMN clientes.nombre IS 'Nombre completo. Dato personal identificador directo.';
COMMENT ON COLUMN clientes.correo IS 'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';
COMMENT ON COLUMN clientes.telefono IS 'Teléfono de contacto. Dato personal. Uso: atención y soporte al cliente.';
COMMENT ON COLUMN clientes.rfc IS 'RFC del cliente. Dato personal. Uso: facturación. Cambios auditados en auditoria.cambios_clientes.';
COMMENT ON COLUMN clientes.edad IS 'Edad en años cumplidos. Dato personal. Uso: analítica agregada.';
COMMENT ON COLUMN clientes.ciudad IS 'Ciudad de residencia del cliente. Dato demográfico. Uso: logística y segmentación.';
COMMENT ON COLUMN clientes.codigo_postal IS 'Código postal del domicilio. Dato geográfico. Uso: envíos y validación fiscal.';
COMMENT ON COLUMN clientes.fecha_alta IS 'Fecha y hora de registro del cliente en el sistema. Metadato operativo.';
COMMENT ON COLUMN clientes.segmento IS 'Clasificación comercial del cliente (ej. minorista, mayorista, VIP). Uso: estrategia comercial.';

-- Consulta del diccionario combinando metadatos y comentarios
SELECT c.ordinal_position          AS pos,
       c.column_name               AS columna,
       c.data_type                 AS tipo,
       c.character_maximum_length  AS longitud,
       c.is_nullable               AS acepta_nulos,
       c.column_default            AS valor_por_defecto,
       col_description('public.clientes'::regclass, c.ordinal_position) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;

--Exporta el diccionario en CSV
SELECT c.column_name AS columna,
       c.data_type AS tipo,
       c.character_maximum_length AS longitud,
       c.is_nullable AS acepta_nulos,
       col_description('public.clientes'::regclass, c.ordinal_position) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;