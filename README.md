# Laboratorio 04 — Hardening

## Objetivo
Reducir la superficie de ataque, establecer el control de acceso basado en roles bajo el principio de mínimo privilegio, forzar el cifrado en tránsito con TLS 1.3, asegurar las credenciales con el algoritmo SCRAM-SHA-256 y configurar tiempos de espera y auditoría en el servidor PostgreSQL 16 de Comercializadora Norte S.A. de C.V.

## Entorno
- Sistema Operativo: Linux
- Motor de Base de Datos: PostgreSQL 16
- Herramienta de Administración: pgAdmin 4 y psql
- Entidad: Comercializadora Norte S.A. de C.V.

## Superficie de ataque inicial
- Puerto por defecto 5432 expuesto en todas las interfaces de red mediante listen_addresses con valor asterisco.
- Reglas permisivas en el archivo pg_hba.conf autorizando conexiones globales 0.0.0.0/0.
- Permisos predeterminados excesivos sobre el esquema public otorgados al rol PUBLIC.
- Autenticación mediante algoritmos obsoletos o débiles.
- Ausencia de cifrado obligatorio en tránsito mediante protocolo TLS.
- Inexistencia de tiempos límite para la cancelación de consultas prolongadas o sesiones inactivas.

## Hallazgos
- La cuenta de la aplicación poseía privilegios elevados no requeridos para su operación normal.
- Ausencia de registro detallado de eventos de conexión y desconexión en los registros del servidor.
- Inexistencia de un perfil de configuración endurecido para la infraestructura crítica de datos.

## Cambios realizados
- Restricción del parámetro listen_addresses a la dirección de red local y subredes internas autorizadas.
- Eliminación de reglas universales en pg_hba.conf y adición de reglas específicas para la subred 10.10.10.0/24 con autenticación scram-sha-256.
- Revocación de todos los privilegios sobre el esquema public al rol PUBLIC mediante la sentencia REVOKE.
- Creación de los roles app_comercializadora con atributos NOSUPERUSER NOCREATEDB NOCREATEROLE y usr_consulta para lectura exclusiva.
- Configuración del parámetro password_encryption en scram-sha-256.
- Configuración de ssl_min_protocol_version en TLSv1.3.
- Establecimiento de statement_timeout en 30s e idle_in_transaction_session_timeout en 60s.
- Activación de log_connections y log_disconnections en el servidor.

## Justificación de los cambios
- La restricción de red previene accesos no autorizados desde segmentos fuera del control organizacional.
- La eliminación de accesos globales mitiga los intentos de fuerza bruta sobre la base de datos.
- La segregación de funciones mediante roles acotados limita el impacto técnico en caso de vulnerabilidades en la aplicación.
- El algoritmo SCRAM-SHA-256 evita la extracción o intercepción de contraseñas.
- El protocolo TLS 1.3 garantiza la confidencialidad de la información en tránsito.
- Los tiempos límite salvan recursos del servidor ante bloqueos o ataques de denegación de servicio.
- La auditoría de eventos asegura la trazabilidad ante incidentes de seguridad.

## Verificación
- Ejecución del script sql/04-verificacion.sql comprobando el estado de la sesión activa en pg_stat_ssl con el valor ssl en true.
- Confirmación de los roles en pg_roles verificando que app_comercializadora posee el valor false en rolsuper.
- Inspección de los privilegios asignados en information_schema.role_table_grants.
- Validación de los parámetros globales en pg_settings confirmando la aplicación de los valores configurados.

## Checklist de hardening
- SEC-01. Restricción de listen_addresses a interfaces autorizadas: Cumplido
- SEC-02. Cifrado de contraseñas mediante scram-sha-256: Cumplido
- SEC-03. Cifrado de tráfico en tránsito con TLS 1.3 obligatorio: Cumplido
- SEC-04. Revocación de accesos globales del rol PUBLIC en esquema public: Cumplido
- SEC-05. Creación de roles de aplicación sin privilegios de superusuario: Cumplido
- SEC-06. Configuración de statement_timeout en 30 segundos: Cumplido
- SEC-07. Configuración de idle_in_transaction_session_timeout en 60 segundos: Cumplido
- SEC-08. Habilitación de registro para conexiones y desconexiones: Cumplido

## Conclusiones
El proceso de hardening aplicado al servidor PostgreSQL 16 de Comercializadora Norte S.A. de C.V. permitió establecer una postura defensiva sólida y alineada con las buenas prácticas de la industria. Se redujo significativamente la exposición a ataques externos, se aseguró la autenticación y el cifrado de datos en tránsito, y se aplicó exitosamente el principio de mínimo privilegio en el modelo de accesos del servidor.