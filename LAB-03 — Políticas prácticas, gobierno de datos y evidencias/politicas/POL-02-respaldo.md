# POL-02 — Respaldo

**Objetivo:** Evitar la pérdida definitiva de información comercial y de auditoría por fallas de hardware, errores humanos o ataques.
---
**Alcance:** Aplica a las bases de datos comercial en PostgreSQL 18 (incluyendo los esquemas public, auditoria y gobierno) y MongoDB 7 en ambiente de producción.
---
**Regla:** Se debe generar un respaldo completo diario de las bases de producción y guardarlo en una ubicación externa al servidor principal. El DBA debe hacer una prueba de restauración en un ambiente de pruebas al menos una vez al mes para comprobar que el respaldo realmente funciona.
---
**Responsable:** Decide la Gerencia de TI sobre la frecuencia y ubicación / ejecuta y verifica el DBA.
---
**Excepciones:** No se permiten excepciones para omitir respaldos en producción; si una ventana de respaldo falla, el DBA debe repetirlo en cuanto se resuelva el incidente con aviso a TI.
---
**Evidencia:** Bitácora de ejecución de respaldos y acta mensual de prueba de restauración.
---
**Revisión:** Anual, o cada vez que se agregue una base de datos crítica nueva.
---