-- Actividad 1 — Identificar la superficie de ataque
-- Consultar la versión del servidor PostgreSQL:
SELECT version();

-- Consultar puerto, direcciones de escucha, SSL y método de cifrado de contraseñas:
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

-- Identificar conexiones activas a la base de datos:
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;

-- Actividad 2 — Identificar los archivos de configuración
-- Consultar las rutas de los archivos de configuración principales:
SHOW config_file;
SHOW hba_file;
SHOW ident_file;

-- Consultar rutas de almacenamiento de datos y registros:
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

-- Actividad 4 — Revisar pg_hba.conf
-- Consultar las reglas activas de autenticación basadas en host:
SELECT
    line_number,
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;