-- Actividad 6 — Aplicar mínimo privilegio a conexiones
-- Otorgar permisos acotados exclusivamente al rol de aplicación:
GRANT USAGE ON SCHEMA public TO app_comercializadora;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_comercializadora;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_comercializadora;

-- Otorgar permisos de solo lectura para el rol de consulta:
GRANT USAGE ON SCHEMA public TO usr_consulta;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO usr_consulta;

-- Actividad 8 — Revisar usuarios y privilegios
-- Consultar el inventario de roles y sus privilegios en el servidor:
SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- Actividad 9 — Separar cuentas administrativas y de aplicación
-- Crear rol para la aplicación con privilegios mínimos (sin superusuario):
CREATE ROLE app_comercializadora WITH LOGIN PASSWORD 'PasswordSeguraApp2026!' NOSUPERUSER NOCREATEDB NOCREATEROLE;

-- Crear rol para consultas y auditoría:
CREATE ROLE usr_consulta WITH LOGIN PASSWORD 'PasswordSeguraConsulta2026!' NOSUPERUSER NOCREATEDB NOCREATEROLE;

-- Revocar privilegios predeterminados sobre el esquema público:
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

