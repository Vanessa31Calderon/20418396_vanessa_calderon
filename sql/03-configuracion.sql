-- Actividad 7 — Revisar autenticación
-- Ajustar el mecanismo de cifrado de contraseñas a SCRAM-SHA-256:
ALTER SYSTEM SET password_encryption = 'scram-sha-256';

-- Actividad 11 — Revisar configuración relacionada con conexiones
-- Configurar tiempo máximo de ejecución de sentencias (30 segundos):
ALTER SYSTEM SET statement_timeout = '30s';

-- Configurar tiempo máximo para sesiones inactivas en transacción (60 segundos):
ALTER SYSTEM SET idle_in_transaction_session_timeout = '60s';

-- Actividad 15 — Revisar TLS
-- Forzar versión mínima de protocolo TLS 1.3:
ALTER SYSTEM SET ssl_min_protocol_version = 'TLSv1.3';

-- Habilitar registro de auditoría de conexiones y desconexiones:
ALTER SYSTEM SET log_connections = 'on';
ALTER SYSTEM SET log_disconnections = 'on';

-- Recargar la configuración del servidor para aplicar cambios en caliente:
SELECT pg_reload_conf();