# Bitácora de Control de Cambios de Configuración
**Proyecto:** Hardening de PostgreSQL 16  
**Organización:** Comercializadora Norte S.A. de C.V.

## 1. Ajustes en postgresql.conf mediante ALTER SYSTEM SET

### Cambio 1. Cifrado de Contraseñas
- **Fecha:** 25/10/2026
- **Parámetro Modificado:** password_encryption
- **Valor Anterior:** md5
- **Valor Nuevo:** scram-sha-256
- **Motivo:** Actividad 7. Reemplazo de algoritmo obsoleto por hashing con sal de alto rendimiento.

### Cambio 2. Tiempo Límite de Consultas
- **Fecha:** 25/10/2026
- **Parámetro Modificado:** statement_timeout
- **Valor Anterior:** 0 deshabilitado
- **Valor Nuevo:** 30s
- **Motivo:** Actividad 11. Cancelación automática de consultas que superen 30 segundos.

### Cambio 3. Tiempo Límite de Transacciones Inactivas
- **Fecha:** 25/10/2026
- **Parámetro Modificado:** idle_in_transaction_session_timeout
- **Valor Anterior:** 0 deshabilitado
- **Valor Nuevo:** 60s
- **Motivo:** Actividad 11. Cierre automático de transacciones inactivas tras 1 minuto.

### Cambio 4. Versión Mínima TLS
- **Fecha:** 25/10/2026
- **Parámetro Modificado:** ssl_min_protocol_version
- **Valor Anterior:** TLSv1.2
- **Valor Nuevo:** TLSv1.3
- **Motivo:** Actividad 15. Restricción para exigir el protocolo más seguro de cifrado en tránsito.

### Cambio 5. Registro de Conexiones
- **Fecha:** 25/10/2026
- **Parámetro Modificado:** log_connections
- **Valor Anterior:** off
- **Valor Nuevo:** on
- **Motivo:** Actividad 15. Habilitar registro de cada conexión exitosa al servidor.

### Cambio 6. Registro de Desconexiones
- **Fecha:** 25/10/2026
- **Parámetro Modificado:** log_disconnections
- **Valor Anterior:** off
- **Valor Nuevo:** on
- **Motivo:** Actividad 15. Habilitar registro de fin de sesión y desconexiones.



## 2. Ajustes en Control de Acceso en pg_hba.conf

### Regla Global Insegura
- **Tipo:** host
- **Base de Datos:** all
- **Usuario:** all
- **Dirección IP:** 0.0.0.0/0
- **Método de Autenticación:** md5 o trust
- **Acción Tomada:** Eliminada por alto riesgo de seguridad.

### Regla Restringida de Aplicación
- **Tipo:** host
- **Base de Datos:** db_comercializadora
- **Usuario:** app_comercializadora
- **Dirección IP:** 10.10.10.0/24
- **Método de Autenticación:** scram-sha-256
- **Acción Tomada:** Agregada para permitir únicamente la red de servidores de aplicaciones.

### Regla Local de Administración
- **Tipo:** local
- **Base de Datos:** all
- **Usuario:** postgres
- **Dirección IP:** Socket Unix
- **Método de Autenticación:** peer o scram-sha-256
- **Acción Tomada:** Mantenida para administración local controlada.