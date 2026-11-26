# POL-01 — Acceso

**Objetivo:** Reducir el riesgo de accesos no autorizados o de que usuarios acumulen permisos que ya no necesitan.
---
**Alcance:** Aplica a todos los usuarios, roles y cuentas de aplicación en las bases de datos comercial de PostgreSQL 18 y MongoDB 7, en todos los ambientes.
---
**Regla:** Cualquier solicitud de acceso o cambio de privilegios en producción debe ser pedida por el jefe del área y aprobada por el propietario del dato antes de aplicarse. El DBA revisa cada mes los permisos activos y la bitácora de GRANT y REVOKE para verificar que coincidan con las solicitudes aprobadas y revocar accesos de personal dado de baja.
---
**Responsable:** Decide el propietario del dato (Gerencia Comercial o TI según el esquema) / ejecuta el DBA.
---
**Excepciones:** En una caída crítica del servicio se puede otorgar un acceso temporal de emergencia con autorización verbal del responsable de TI, pero debe documentarse y revocarse en menos de 24 horas.
---
**Evidencia:** Líneas statement: GRANT y REVOKE en la bitácora de PostgreSQL (LAB-01, Actividad 6), instantáneas de privilegios en auditoria.instantaneas_privilegios de MongoDB (LAB-02) y el registro de solicitudes de acceso (hoy no existe un registro formal de solicitudes de acceso).
---
**Revisión:** Semestral, o cuando cambie la estructura de roles de la empresa.
---