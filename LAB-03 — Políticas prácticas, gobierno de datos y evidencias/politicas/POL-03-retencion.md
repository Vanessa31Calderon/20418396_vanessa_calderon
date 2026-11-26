# POL-03 — Retención

**Objetivo:** Evitar que se pierda evidencia necesaria para auditorías e incidentes, pero sin guardar datos personales por más tiempo del permitido.
---
**Alcance:** Aplica a las tablas de clientes, tablas de auditoría y bitácoras de PostgreSQL 18 y MongoDB 7 en producción.
---
**Regla:** Los datos de clientes se conservan mientras exista relación comercial más el plazo fiscal que confirme el área jurídica. Las bitácoras de cambios de privilegios y estructura se conservan 24 meses, la tabla auditoria.cambios_clientes se conserva 12 meses en línea y las bitácoras de acceso o modificaciones 90 días; al vencer cada plazo se aplica borrado seguro o anonimización documentada.
---
**Responsable:** Decide el área jurídica junto con el propietario del dato / ejecuta el DBA.
---
**Excepciones:** Si hay una investigación legal o de seguridad abierta, Auditoría Interna o el área jurídica pueden autorizar suspender temporalmente el borrado de los registros involucrados.
---
**Evidencia:** Tabla de criterios de conservación (LAB-03, Actividad 5), hash SHA-256 de bitácoras exportadas y actas de borrado o anonimización (las actas de borrado hoy no existen).
---
**Revisión:** Anual, o cuando haya cambios en las leyes de protección de datos o fiscales.
---