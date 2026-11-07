| # | Fecha y hora (UTC / Local) | Usuario | Cliente / IP | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente (Línea o `id_evento`) |
| :-: | :--- | :--- | :--- | :--- | :--- | :-: | :--- |
| **1** | `2026-11-06 19:16:00.001` | `postgres` (PID 1) | `[local]` | Configuración | Recarga del servidor: activación de `log_connections`, `log_disconnections`, `log_line_prefix` y `log_statement = 'ddl'`. | **Sí** | Bitácora líneas 8-11 |
| **2** | *No hay evidencia* | *No hay evidencia* | `127.0.0.1` | Datos | Ejecución de `UPDATE clientes SET rfc = 'GAMA780912XXX' WHERE id = 3` (Incidente inicial sin registro). | **Sí** | **No hay evidencia** (colector apago) |
| **3** | `2026-11-06 19:30:00.334` | `app_ventas` | `127.0.0.1` | Acceso | Intento de conexión con contraseña incorrecta (`password authentication failed`). | **No** | Bitácora línea 15 |
| **4** | `2026-11-06 19:30:00.462` | `usuario_inexistente` | `127.0.0.1` | Acceso | Intento de conexión con rol no registrado en el sistema. | **No** | Bitácora líneas 18-19 |
| **5** | `2026-11-06 19:40:09.367` | `postgres` | `[local]` | Privilegio | Asignación de privilegios DCL: `GRANT UPDATE ON clientes TO app_ventas`. | **Sí** | Bitácora línea 25 |
| **6** | `2026-11-06 19:40:09.372` | `postgres` | `[local]` | Estructura | Alteración de esquema DDL: `ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)`. | **Sí** | Bitácora línea 26 |
| **7** | `2026-11-06 19:46:20.601` | `app_ventas` | `127.0.0.1` | Datos | Sentencia `UPDATE clientes SET telefono = '6679990000' WHERE id = 3` (Bajo `log_statement = 'mod'`). | **Sí** | Bitácora línea 28 |
| **8** | `2026-11-06 19:48:10.123` | `soporte_ana` | `127.0.0.1` | Error | Intento no autorizado de borrado: `DELETE FROM clientes WHERE id = 5` (`permission denied`). | **No** | Bitácora líneas 29-30 |
| **9** | `2026-11-06 20:05:52.903` | `app_ventas` | `127.0.0.1` | Datos | Modificación de RFC: `UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3`. | **Sí** | `auditoria.cambios_clientes` (`id_evento = 1`) |
| **10** | `2026-11-06 20:21:00.456` | `postgres` | `[local]` | Configuración / Datos | Deshabilitación manual de disparador `trg_auditoria_clientes` y modificación no auditada en tabla: `UPDATE clientes SET rfc = 'GAMA780912GHI'`. | **Sí** | Bitácora líneas 41-43 (Omisión en `auditoria`) |

**1. ¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?**

* Actividad 3 (Incidente inicial): No hay evidencia. En el momento en que se modificó el RFC a 'GAMA780912XXX', el servidor operaba con logging_collector = off y log_statement = 'none'. No existe timestamp, usuario ni dirección IP registrada. No es posible afirmar ni descartar técnicamente la autoría de app_ventas ni de ningún otro rol.

* Actividad 7 (Intento bajo ddl vs. mod): Demostrado: El usuario de conexión fue app_ventas, desde la dirección IP 127.0.0.1 y la aplicación app-ventas-web. (Se modificó el RFC a 'GAMA780912XYZ'). Evidencia: Bitácora del servidor bajo log_statement = 'mod'.

* Actividad 12 (Incidente auditado): Demostrado: El cambio fue realizado por app_ventas, autenticado como session_user, desde la IP 127.0.0.1 y la aplicación app-ventas-web. (Se modificó el RFC a 'GAMA780912ZZZ'). Evidencia: auditoria.cambios_clientes (id_evento = 1).

* Actividad 14 (Manipulación/Bypass): Demostrado: El cambio final del RFC a 'GAMA780912GHI' fue ejecutado por el usuario administrador postgres desde una conexión local. Evidencia: Bitácora del servidor (Línea 42), detectada tras la deshabilitación del disparador de auditoría.

**2. ¿Quién cambió el teléfono?**

Demostrado: La actualización del teléfono a '6679990000' para la clienta María García (id = 3) fue realizada por el rol app_ventas, desde la IP 127.0.0.1 utilizando el cliente app-ventas-web a las 19:46:20.601. Evidencia: Bitácora del servidor bajo nivel log_statement = 'mod' (Línea 28).

**3. ¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?**

Demostrado: Se registraron dos (2) intentos de acceso fallidos, ambos provenientes de la dirección IP 127.0.0.1 (TCP/IP local):

* Usuario app_ventas: Fallo de autenticación por contraseña errónea (password authentication failed). Timestamp: 19:30:00.334. Evidencia: Bitácora línea 15.

* Usuario usuario_inexistente: Fallo de autenticación debido a que el rol especificado no existe en el catálogo de PostgreSQL (Role "usuario_inexistente" does not exist). Timestamp: 19:30:00.462. Evidencia: Bitácora líneas 18 y 19.


**4. ¿Qué valor tenía el RFC antes de cada cambio?**
* Actividad 3 (Incidente inicial): No hay evidencia. En el momento de la modificación, el colector de bitácora estaba desactivado (logging_collector = off). Aunque por los datos iniciales de prueba se infiere que era GAMA780912GHI, no existe ningún registro técnico ni archivo de log que lo demuestre.

* Actividad 7 (Cambio bajo log_statement = 'mod'): No hay evidencia del valor anterior. La bitácora física del servidor con el nivel mod registra únicamente la sentencia SQL enviada por el cliente (UPDATE ... SET rfc = 'GAMA780912XYZ'), pero no tiene la capacidad técnica de capturar ni guardar el estado previo del registro.

* Actividad 12 (Incidente auditado): GAMA780912XYZ (cambió a GAMA780912ZZZ). Demostrado. Fue capturado de forma completa e inmutable mediante la función de disparador en auditoria.cambios_clientes (id_evento = 1), extrayendo el atributo del objeto JSONB en el snapshot previo (valores_antes ->> 'rfc').

* Actividad 14 (Manipulación / Deshabilitación de trigger): GAMA780912ZZZ (cambió a GAMA780912GHI). Demostrado en bitácora de servidor, omitido en tabla de auditoría. El disparador fue deshabilitado manualmente, por lo que la tabla de auditoría no capturó el evento; sin embargo, la bitácora del servidor (dba.bitacora, líneas 41 a 43) corrobora la deshabilitación, la ejecución del UPDATE por el usuario postgres y la reactivación del disparador, permitiendo reconstruir la secuencia.