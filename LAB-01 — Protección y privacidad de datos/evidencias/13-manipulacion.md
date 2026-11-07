**1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?**

La bitácora central del servidor.
Aunque la tabla auditoria.cambios_clientes no haya registrado el evento DML debido a la deshabilitación del disparador, la bitácora del servidor escrita bajo el nivel log_statement = 'ddl'conservó las sentencias secuenciales del administrador:

* ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes (Línea 41).
* UPDATE clientes SET rfc = 'GAMA780912GHI' WHERE id = 3 (Línea 42).
* ALTER TABLE clientes ENABLE TRIGGER trg_auditoria_clientes (Línea 43).

Al realizar una auditoría cruzada entre la bitácora del servidor y la tabla de auditoría a nivel de datos, la discrepancia entre ambas fuentes delata de inmediato la omisión del registro.

**2. ¿Qué control administrativo (no técnico) reduciría este riesgo?**  
La implementación de una política estricta de Gestión de Cambios en Producción (Change Management) respaldada por supervisión y revisión periódica de auditorías independientes:

* Prohibición de Cambios Directos en Producción: Exigir que cualquier cambio de estructura o alteración de estado de disparadores sea ejecutado mediante ventanas de mantenimiento autorizadas y scripts automatizados de despliegue (CI/CD), suprimiendo la interacción manual por consola de los administradores sobre bases en producción.

* Envío Centralizado y Remoto de Bitácoras (SIEM): Configurar la transmisión síncrona o en tiempo real de los logs del motor hacia un servidor de almacenamiento inmutable (como un SIEM o colector Syslog externo), cuyo acceso esté vetado de manera absoluta para el equipo de Administradores de la Base de Datos (DBA).

**3. Relaciona esta actividad con el principio de separación de funciones de la Unidad II.**
La actividad demuestra de forma práctica que ningún sistema dentro del propio motor puede auditar con no repudio pleno a su propio superusuario (DBA).
En la Unidad II se estableció que las funciones operativas (quien ejecuta las ventas) y las funciones administrativas (quien gestiona el motor) deben recaer en roles diferenciados. En el ámbito de la auditoría (Unidad III), este principio se extiende a la separación entre quien opera la base de datos y quien custodia la evidencia.

Si la misma persona o rol que administra PostgreSQL (postgres) tiene la capacidad técnica de apagar los registros, deshabilitar triggers o alterar la bitácora en disco, el mecanismo de auditoría pierde su valor legal y forense. La evidencia solo mantiene su validez cuando la recolección, almacenamiento y revisión de las bitácoras es custodiada por un área independiente de Seguridad de la Información o Auditoría Interna.