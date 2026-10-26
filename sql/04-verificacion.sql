-- Actividad 10 — Revisar extensiones
-- Consultar las extensiones habilitadas en la base de datos:
SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;

-- Actividad 15 — Verificar uso de TLS en la sesión activa
-- Consultar si la conexión actual está cifrada mediante TLS:
SELECT
    s.pid,
    a.usename,
    a.client_addr,
    s.ssl,
    s.version,
    s.cipher
FROM pg_stat_ssl s
JOIN pg_stat_activity a ON s.pid = a.pid
WHERE s.pid = pg_backend_pid();

-- Actividad 16 — Verificación de permisos asignados al rol de aplicación
-- Consultar privilegios específicos en el catálogo del sistema:
SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'app_comercializadora';

-- Verificación final de parámetros de seguridad activos:
SELECT name, setting, unit, context
FROM pg_settings
WHERE name IN (
    'listen_addresses',
    'ssl',
    'ssl_min_protocol_version',
    'password_encryption',
    'statement_timeout',
    'idle_in_transaction_session_timeout'
);