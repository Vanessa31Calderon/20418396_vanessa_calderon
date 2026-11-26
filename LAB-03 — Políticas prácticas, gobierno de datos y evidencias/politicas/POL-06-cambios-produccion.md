# POL-06 — Cambios en producción

**Objetivo:** Evitar caídas del servicio, corrupción de datos o cambios no autorizados en el ambiente real donde operan los usuarios.
---
**Alcance:** Aplica a cualquier cambio de estructura (DDL), disparadores, vistas o configuración en el ambiente de producción (donde residen los datos reales y activos del negocio, separado de desarrollo y pruebas según la Unidad I) en PostgreSQL 18 y MongoDB 7.
---
**Regla:** Antes de aplicar un cambio en producción, debe probarse en desarrollo y pruebas, contar con un folio aprobado en gobierno.solicitudes_cambio y tener un respaldo previo. Durante el cambio solo se puede ejecutar dentro de la ventana autorizada, y después debe conciliarse contra la bitácora del motor para confirmar que solo se aplicó lo aprobado.
---
**Responsable:** Decide y aprueba el Comité de Cambios / ejecuta el DBA.
---
**Excepciones:** En fallas críticas de producción se puede aplicar un cambio de emergencia autorizado por el responsable de TI, pero el folio y la conciliación deben registrarse a más tardar el siguiente día hábil.
---
**Evidencia:** Tabla gobierno.solicitudes_cambio (LAB-03, Actividad 7), vista dba.bitacora con líneas CREATE, ALTER y DROP (LAB-01) y tabla de conciliación de cambios (LAB-03, Actividad 7).
---
**Revisión:** Semestral, o después de cualquier cambio fallido en producción.
---