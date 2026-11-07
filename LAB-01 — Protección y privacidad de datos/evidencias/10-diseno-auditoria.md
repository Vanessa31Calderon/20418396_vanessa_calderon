**1. ¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?**
Porque TIMESTAMPTZ (timestamp with time zone) convierte internamente la fecha y hora a UTC para su almacenamiento persistente y conserva el desplazamiento de la zona horaria del origen.

* Si se usara TIMESTAMP (sin zona horaria), el valor registrado dependería exclusivamente de la configuración local del servidor o de la sesión. Si el servidor cambia de zona horaria o se procesan consultas desde diferentes regiones, la cronología se corruptía haciendo imposible reconstruir la secuencia exacta de un incidente forense.

**2. ¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió?**
* Inmunidad a Cambios de Estructura: Al serializar la tupla completa con to_jsonb(OLD) / to_jsonb(NEW), si en el futuro la tabla clientes sufre modificaciones (se agregan o eliminan columnas, como en la Actividad 6 con segmento), la tabla de auditoría no requerirá un ALTER TABLE para adaptarse.
* Contexto Completo e Integridad Forense: Al examinar una modificación, tener el objeto completo permite consultar el contexto integral del cliente en ese instante sin depender de lecturas históricas adicionales.
* Optimización y Búsqueda Relacional: El formato binario JSONB en PostgreSQL permite indexar mediante sintaxis GIN y consultar campos específicos con operadores de extracción como -> o ->>, manteniendo el rendimiento de una base de datos relacional.

**3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?**
* Clasificación del Dato: Implica que la tabla auditoria.cambios_clientes pasa a ser clasificada como un contenedor de Datos Personales Sensibles / Confidenciales (sujeta a regulaciones como la LFPDPPP o GDPR), ya que almacena el historial completo de RFCs, nombres y teléfonos de los clientes.
* Control de Acceso Estricto (Principio de Menor Privilegio):
    * Debe revocarse explícitamente todo acceso de lectura (SELECT) y escritura (INSERT, UPDATE, DELETE) a roles operativos como app_ventas o PUBLIC.
    * Solamente la función de disparador debe poder insertar registros en ella.
    * El acceso de lectura debe ser exclusivo del equipo de Auditoría de Seguridad o Administradores de la BD, aplicando controles de auditoría adicionales a la propia tabla de auditoría para evitar la exfiltración masiva de datos personales.