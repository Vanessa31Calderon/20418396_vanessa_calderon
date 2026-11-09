**1. Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?**

* En la Bitácora del Servidor (log_statement = 'mod'): Se registraría únicamente 1 línea con la sentencia UPDATE clientes SET segmento = 'regular';.

* En la Tabla de Auditoría (auditoria.cambios_clientes): Se dispararía 1,000,000 de veces la función de auditoría, intentando insertar 1,000,000 de registros nuevos en JSONB.

* Consecuencias en el Motor:

    * Degradación Crítica del Rendimiento (I/O & Amplificación de Escritura): La transacción tardaría órdenes de magnitud más en completarse debido al sobrecosto de procesar, serializar a JSONB e insertar un millón de registros adicionales.
    * Bloqueo y Crecimiento Desmedido de Disco: Generaría gigabytes de espacio ocupado en disco instantáneamente y un volumen masivo de archivos WAL (Write-Ahead Logging), corriendo el riesgo de agotar el almacenamiento de la base de datos y provocar la caída por Out-Of-Space del servidor.

**2. Propón quién podría autorizar la depuración de auditoria.cambios_clientes.**

La depuración, purga o archivado de la tabla auditoria.cambios_clientes nunca debe ser autorizada ni ejecutada de forma unilateral por el Administrador de Base de Datos (DBA) ni por el equipo de desarrollo.

Debe ser autorizada mediante un protocolo formal por un comité interdisciplinario integrado por:
* El Oficial de Seguridad de la Información (CISO) / Comité de Auditoría: Para verificar que los registros a depurar ya superaron el periodo de cumplimiento y ventana de investigación forense requerida.
* El Oficial de Privacidad y Cumplimiento Legal (Data Privacy Officer): Para constatar que la purga o anonimización cumple con las leyes de retención de datos personales aplicables.
* El Propietario del Negocio / Gobierno de Datos: Quien firma formalmente la orden de destrucción o migración a almacenamiento frío de la evidencia.

**3. ¿Por qué log_statement = 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?**
Porque al activar all, el motor PostgreSQL escribe en texto plano dentro del archivo de registro en disco (.log) el contenido íntegro de cada consulta SELECT, INSERT y UPDATE ejecutada por cualquier usuario o aplicación.

Si un usuario consulta información confidencial (ej. SELECT rfc, tarjeta_credito, password_hash FROM usuarios WHERE id = 10;), los valores buscados y devueltos quedan plasmados literalmente en el prefijo y cuerpo del archivo de log. Si este archivo no cuenta con permisos de cifrado y aislamiento superiores a los de la propia base de datos, cualquier analista con acceso a los logs o a herramientas de monitoreo podrá extraer la información confidencial sin dejar rastro en las tablas operativas, convirtiendo la bitácora en una brecha de seguridad y fuga de información sensible.