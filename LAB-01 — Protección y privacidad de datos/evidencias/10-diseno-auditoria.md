# 16. Actividad 10 — Diseñar y crear el registro de auditoría

| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
| :--- | :--- | :--- | :--- |
| **`id_evento`** | `BIGSERIAL` | Identificador único y correlativo del evento de auditoría. | **No nulo.** Es la llave primaria indispensable para ordenamiento e integridad. |
| **`momento`** | `TIMESTAMPTZ` | ¿Cuándo ocurrió el cambio? Marca de tiempo exacta con zona horaria. | **No nulo.** Todo evento auditado debe ser temporalmente ubicable sin ambigüedad. |
| **`usuario_sesion`** | `TEXT` | ¿Quién hizo el cambio? Identidad real del usuario que inició la sesión (`session_user`). | **No nulo.** Garantiza el no repudio, incluso si la función se ejecuta con elevación de privilegios. |
| **`usuario_efectivo`** | `TEXT` | Contexto de ejecución. Rol cuyos privilegios estaban vigentes (`current_user`). | **No nulo.** Permite auditar ejecuciones bajo `SECURITY DEFINER` o tras un `SET ROLE`. |
| **`aplicacion`** | `TEXT` | ¿Desde qué aplicación? Nombre de la aplicación cliente (`application_name`). | **Sí puede ser nulo.** Si el cliente no especifica la variable de entorno, el sistema devuelve nulo o `[unknown]`. |
| **`ip_cliente`** | `INET` | ¿Desde qué equipo/IP? Dirección IP del cliente remoto (`inet_client_addr()`). | **Sí puede ser nulo.** Es nula en conexiones locales por socket de Unix o memoria donde no existe IP TCP. |
| **`operacion`** | `TEXT` | Tipo de acción DML realizada (`INSERT`, `UPDATE` o `DELETE`). | **No nulo.** Es indispensable categorizar la naturaleza de la modificación. |
| **`id_cliente`** | `BIGINT` | Identificador del registro afectado en la tabla `clientes`. | **Sí puede ser nulo.** Aunque habitualmente existe, previene fallos si se auditan operaciones globales. |
| **`valores_antes`** | `JSONB` | ¿Qué valor tenía el dato antes del cambio? Snapshot completo de la tupla previo a la acción (`OLD`). | **Sí puede ser nulo.** En una operación `INSERT`, no existen valores previos (`NULL`). |
| **`valores_despues`** | `JSONB` | ¿Qué valor tiene el dato después del cambio? Snapshot completo de la tupla posterior a la acción (`NEW`). | **Sí puede ser nulo.** En una operación `DELETE`, el registro deja de existir (`NULL`). |


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