# POL-04 — Restauración

**Objetivo:** Evitar que una restauración mal hecha sobrescriba datos recientes válidos o exponga información sensible en ambientes sin control.
---
**Alcance:** Aplica a cualquier recuperación total o parcial de las bases comercial en PostgreSQL 18 y MongoDB 7, en producción o pruebas.
---
**Regla:** Ninguna restauración en producción puede ejecutarse sin autorización formal del propietario del dato y del responsable de TI, previa evaluación del impacto y pérdida de datos. Toda restauración debe probarse primero en un ambiente aislado si el tiempo del incidente lo permite, y quedar registrada con fecha, motivo y respaldo utilizado.
---
**Responsable:** Decide y autoriza el propietario del dato junto con TI / ejecuta el DBA.
---
**Excepciones:** En un desastre mayor donde el propietario no esté disponible, el responsable de TI puede autorizar la restauración de emergencia y documentarla al restablecer el servicio.
---
**Evidencia:** Registro de incidentes y actas de restauración autorizadas y bitácora del servidor de base de datos (LAB-01).
---
**Revisión:** Anual, o después de cada incidente real que haya requerido restaurar datos.
---