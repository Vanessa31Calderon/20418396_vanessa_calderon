# Línea Base de Seguridad — PostgreSQL 16
**Entidad:** Comercializadora Norte S.A. de C.V.

## Checklist de Parámetros de Seguridad

### SEC-01. Direcciones de Escucha
- **Parámetro:** listen_addresses
- **Valor Recomendado:** IP autorizadas o Loopback
- **Valor Configurado:** Restringido a 127.0.0.1 y direcciones IP internas
- **Estado:** Cumplido
- **Justificación de Seguridad:** Evita la exposición del puerto 5432 a redes públicas desprotegidas.

### SEC-02. Cifrado de Contraseñas
- **Parámetro:** password_encryption
- **Valor Recomendado:** scram-sha-256
- **Valor Configurado:** scram-sha-256
- **Estado:** Cumplido
- **Justificación de Seguridad:** Previene ataques de intermediario e intercepción de credenciales.

### SEC-03. Habilitación de Cifrado SSL
- **Parámetro:** ssl
- **Valor Recomendado:** on
- **Valor Configurado:** on
- **Estado:** Cumplido
- **Justificación de Seguridad:** Habilita la capacidad de cifrar el tráfico entre los clientes y el servidor.

### SEC-04. Versión Mínima de Protocolo TLS
- **Parámetro:** ssl_min_protocol_version
- **Valor Recomendado:** TLSv1.3
- **Valor Configurado:** TLSv1.3
- **Estado:** Cumplido
- **Justificación de Seguridad:** Invalida protocolos obsoletos y vulnerables como TLS 1.0, TLS 1.1 y SSLv3.

### SEC-05. Acceso Público en Esquema
- **Parámetro:** Acceso del rol PUBLIC en esquema public
- **Valor Recomendado:** Revocado mediante REVOKE
- **Valor Configurado:** Revocado
- **Estado:** Cumplido
- **Justificación de Seguridad:** Previene que cualquier usuario autenticado cree o altere objetos por defecto.

### SEC-06. Cuentas de Aplicación
- **Parámetro:** Atributos de privilegios en roles
- **Valor Recomendado:** NOSUPERUSER
- **Valor Configurado:** app_comercializadora configurada con NOSUPERUSER
- **Estado:** Cumplido
- **Justificación de Seguridad:** Cumple el principio de mínimo privilegio asignando únicamente sentencias DML sobre el esquema public.

### SEC-07. Tiempo Límite de Sentencias
- **Parámetro:** statement_timeout
- **Valor Recomendado:** Menor o igual a 30 segundos
- **Valor Configurado:** 30s
- **Estado:** Cumplido
- **Justificación de Seguridad:** Mitiga bloqueos prolongados y consultas maliciosas para prevenir denegación de servicio.

### SEC-08. Tiempo Límite de Sesión Inactiva en Transacción
- **Parámetro:** idle_in_transaction_session_timeout
- **Valor Recomendado:** Menor o igual a 60 segundos
- **Valor Configurado:** 60s
- **Estado:** Cumplido
- **Justificación de Seguridad:** Libera conexiones y bloqueos retenidos por transacciones abandonadas.

### SEC-09. Auditoría de Conexiones
- **Parámetro:** log_connections y log_disconnections
- **Valor Recomendado:** Activado en on
- **Valor Configurado:** log_connections y log_disconnections en on
- **Estado:** Cumplido
- **Justificación de Seguridad:** Genera trazabilidad completa en los archivos de registro para auditorías forenses.