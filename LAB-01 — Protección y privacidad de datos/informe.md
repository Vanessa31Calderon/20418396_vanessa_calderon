

## 1. Despliegue y Situación Inicial

* **Despliegue:** Servidor PostgreSQL 18 ejecutado en entorno local/Windows con la base de datos `comercial` y roles segregados (`postgres`, `app_ventas`, `soporte_ana`).
* **Situación Inicial:** El motor operaba con la configuración predeterminada de fábrica (`logging_collector = off`, `log_statement = none` y `log_line_prefix = '%m [%p]'`).
* **Incapacidad de respuesta a Dirección:** Al ocurrir la modificación no autorizada del RFC en el incidente inicial, el motor no registraba sentencias DML, accesos ni direcciones IP de cliente. La falta de evidencias impidió determinar la identidad del responsable, exonerar a otros roles o reconstruir el valor previo del registro.

---

## 2. Configuración Aplicada

| Parámetro | Valor Aplicado | Acción Requerida | Justificación Forense |
| :--- | :--- | :--- | :--- |
| `logging_collector` | `on` | **Reinicio** | Habilita el proceso de fondo para captura, rotación y almacenamiento estructurado de bitácoras. |
| `log_destination` | `stderr` | Recarga | Define la salida estándar de errores capturada por el colector nativo del motor. |
| `log_connections` | `on` | Recarga | Registra los inicios de sesión exitosos, indicando IP de origen, aplicación y usuario. |
| `log_disconnections` | `on` | Recarga | Registra el cierre de sesiones y permite calcular la duración exacta de las conexiones. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h ` | Recarga | Enriquece cada línea con timestamp (ms), PID, usuario, BD, app e IP de origen para no repudio. |
| `log_statement` | `ddl` $\rightarrow$ `mod` | Recarga | Captura modificaciones de esquema/privilegios (`ddl`) y sentencias de datos DML (`mod`). |
| `log_min_error_statement` | `error` | Recarga | Registra la sentencia SQL exacta que generó cualquier error de permisos o sintaxis. |

---

## 3. Eventos Observados Interpretados

1. **Conexión Exitosa:**
   * `2026-11-06 19:30:00.100 [1234] user=app_ventas db=comercial app=app-ventas-web client=127.0.0.1 LOG: connection authorized: user=app_ventas database=comercial`
   * *Interpretación:* El usuario `app_ventas` se autenticó correctamente vía TCP/IP desde la IP local `127.0.0.1`.

2. **Fallo de Autenticación:**
   * `2026-11-06 19:30:00.334 [1235] user=[unknown] db=comercial app=[unknown] client=127.0.0.1 FATAL: password authentication failed for user "app_ventas"`
   * *Interpretación:* Intento fallido de inicio de sesión por contraseña incorrecta desde IP `127.0.0.1`.

3. **Modificación de Estructura (DDL):**
   * `2026-11-06 19:40:09.372 [1200] user=postgres db=comercial app=psql client=[local] LOG: statement: ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);`
   * *Interpretación:* El rol superusuario `postgres` alteró la estructura de la tabla agregando una columna desde una sesión local.

4. **Modificación de Datos (DML):**
   * `2026-11-06 19:46:20.601 [1234] user=app_ventas db=comercial app=app-ventas-web client=127.0.0.1 LOG: statement: UPDATE clientes SET telefono = '6679990000' WHERE id = 3;`
   * *Interpretación:* Ejecución de `UPDATE` bajo `log_statement = 'mod'`. Muestra la consulta enviada pero no captura el valor previo que tenía el registro.

5. **Fallo de Autorización (Error):**
   * `2026-11-06 19:48:10.123 [1250] user=soporte_ana db=comercial app=psql client=127.0.0.1 ERROR: permission denied for table clientes`
   * *Interpretación:* Intento fallido de eliminación (`DELETE`) por falta de privilegios DCL en el rol `soporte_ana`.

---

## 4. Auditoría del Dato mediante Disparador

* **Diseño de la Tabla (`auditoria.cambios_clientes`):** Tabla alojada en un esquema restrito `auditoria`, utilizando columnas `JSONB` (`valores_antes` y `valores_despues`) para registrar la tupla completa en cada operación DML.
* **Mecanismo `SECURITY DEFINER` y `session_user`:** La función disparadora corre con elevación de privilegios del propietario (`postgres`) para escribir en el esquema protegido, pero almacena `session_user` (`app_ventas`) e `inet_client_addr()` para evitar la suplantación de identidad.
* **Resultado del Incidente Auditado:** Al modificarse el RFC a `'GAMA780912ZZZ'`, el disparador registró automáticamente el evento (`id_evento = 1`), permitiendo identificar mediante consultas `LATERAL jsonb_each` la columna alterada (`rfc`) y el valor previo exacto (`GAMA780912XYZ`).

---

## 5. Limitaciones

1. **Lecturas (`SELECT`):** Con `log_statement = 'mod'`, las consultas de lectura no se registran. Capturar lecturas requiere `log_statement = 'all'`, lo cual genera un alto impacto de E/S en almacenamiento.
2. **Volumen de Almacenamiento:** El registro masivo de snapshots `JSONB` e hiper-logging incrementa de forma exponencial el consumo de disco.
3. **Control Total del Administrador:** El superusuario `postgres` puede desactivar disparadores (`ALTER TABLE ... DISABLE TRIGGER`) o apagar la bitácora (`log_statement = 'none'`), evadiendo los controles internos.

---

## 6. Riesgos de la Bitácora

* **Exposición de Secretos:** Sentencias de administración como `CREATE ROLE ... PASSWORD '...'` quedan grabadas en texto claro en el archivo de log.
* **Pérdida de Evidencia:** Rotación agresiva de archivos o borrado accidental/malintencionado del archivo `.log` en el sistema operativo.
* **Acceso de Terceros:** Permisos laxos a nivel de sistema operativo o sobre la vista `dba.bitacora` que permitan a usuarios no autorizados leer transacciones sensibles.

---

## 7. Cronología y Conclusión

### Cronología de Eventos Auditados

| # | Fecha y hora (UTC / Local) | Usuario | Cliente / IP | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente (Línea o `id_evento`) |
| :-: | :--- | :--- | :--- | :--- | :--- | :-: | :--- |
| **1** | `2026-11-06 19:16:00.001` | `postgres` (PID 1) | `[local]` | Configuración | Recarga del servidor: activación de `log_connections`, `log_disconnections`, `log_line_prefix` y `log_statement = 'ddl'`. | **Sí** | Bitácora líneas 8-11 |
| **2** | *No hay evidencia* | *No hay evidencia* | `127.0.0.1` | Datos | Ejecución de `UPDATE clientes SET rfc = 'GAMA780912XXX' WHERE id = 3` (Incidente inicial sin registro). | **Sí** | **No hay evidencia** (colector apagado) |
| **3** | `2026-11-06 19:30:00.334` | `app_ventas` | `127.0.0.1` | Acceso | Intento de conexión con contraseña incorrecta (`password authentication failed`). | **No** | Bitácora línea 15 |
| **4** | `2026-11-06 19:30:00.462` | `usuario_inexistente` | `127.0.0.1` | Acceso | Intento de conexión con rol no registrado en el sistema. | **No** | Bitácora líneas 18-19 |
| **5** | `2026-11-06 19:40:09.367` | `postgres` | `[local]` | Privilegio | Asignación de privilegios DCL: `GRANT UPDATE ON clientes TO app_ventas`. | **Sí** | Bitácora línea 25 |
| **6** | `2026-11-06 19:40:09.372` | `postgres` | `[local]` | Estructura | Alteración de esquema DDL: `ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)`. | **Sí** | Bitácora línea 26 |
| **7** | `2026-11-06 19:46:20.601` | `app_ventas` | `127.0.0.1` | Datos | Sentencia `UPDATE clientes SET telefono = '6679990000' WHERE id = 3` (Bajo `log_statement = 'mod'`). | **Sí** | Bitácora línea 28 |
| **8** | `2026-11-06 19:48:10.123` | `soporte_ana` | `127.0.0.1` | Error | Intento no autorizado de borrado: `DELETE FROM clientes WHERE id = 5` (`permission denied`). | **No** | Bitácora líneas 29-30 |
| **9** | `2026-11-06 20:05:52.903` | `app_ventas` | `127.0.0.1` | Datos | Modificación de RFC: `UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3`. | **Sí** | `auditoria.cambios_clientes` (`id_evento = 1`) |
| **10** | `2026-11-06 20:21:00.456` | `postgres` | `[local]` | Configuración / Datos | Deshabilitación manual de disparador `trg_auditoria_clientes` y modificación no auditada en tabla: `UPDATE clientes SET rfc = 'GAMA780912GHI'`. | **Sí** | Bitácora líneas 41-43 (Omisión en `auditoria`) |

### Dictamen Técnico y Conclusión

Con la arquitectura implementada (combinación de `logging_collector` enriquecido con prefijos + disparadores `JSONB` en esquema aislado), **SÍ es posible demostrar fehacientemente quién cambió un dato sensible, cuándo, desde qué IP y qué valor tenía antes del incidente**. La bitácora del servidor proporciona la trazabilidad del canal de comunicación y sentencias enviadas, mientras que la auditoría por disparador otorga la integridad forense del dato e inalterabilidad previa.

---

# 29. Preguntas de Reflexión

### 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?
La auditoría es un control de tipo **preventivo/detectivo pasivo**. El motor de base de datos solo registra los eventos en el instante exacto en que ocurren en memoria o transacciones. Si un parámetro estaba desactivado (`off`) durante un incidente, la información nunca fue escrita en ningún soporte físico, haciendo imposible su reconstrucción histórica retrospectiva.

### 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?
El colector nativo (`logging_collector = on`) garantiza la escritura sincrónica, estructurada y desacoplada del búfer de la consola. Delegar la bitácora al mecanismo de despliegue (ej. `stdout` de Docker o consola SO) arriesga pérdida de trazas por saturación de búfer, desformateo de prefijos y destrucción de archivos al reiniciar la instancia.

### 3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?
`log_statement` define *qué comando* se imprime, pero sin `log_line_prefix` la sentencia carece de valor legal o forense. El prefijo aporta el **contexto forense** de la acción: marca de tiempo (`%m`), PID (`%p`), usuario (`%u`), base de datos (`%d`), aplicación (`%a`) e IP de cliente (`%h`), elementos indispensables para el no repudio.

### 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?
* **Registrar la sentencia (`log_statement`):** Guarda la instrucción SQL textual enviada por el cliente (ej. `UPDATE clientes SET rfc = 'XXX' WHERE id = 3`). No muestra qué valores tenían los campos antes de la ejecución ni garantiza cuál fue el impacto real.
* **Registrar el cambio en el dato (Disparador JSONB):** Guarda el estado exacto de la tupla (*snapshot*) antes (`OLD`) y después (`NEW`). Permite realizar auditoría diferencial y restaurar el dato original con precisión.

### 5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?
* **`pg_stat_activity`:** Ofrece información **en tiempo real y en memoria RAM** sobre sesiones activas en este instante (PID, estado de la transacción, tiempo de espera, consulta en ejecución). No guarda historial pasado una vez que la sesión se desconecta.
* **Bitácora (`dba.bitacora`):** Ofrece un **registro histórico persistente en disco** de eventos pasados, conexiones cerradas, errores y modificaciones finalizadas.

### 6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?
Al administrador lo auditan **controles externos al motor de base de datos**:
1. **Envío centralizado de bitácoras (SIEM / Syslog remoto):** Redirección síncrona e inalterable de los archivos de log a un servidor externo de seguridad donde el DBA no posee privilegios de borrado ni modificación.
2. **Segregación de Funciones (SoD):** El personal que administra la base de datos no posee acceso a la administración del sistema operativo ni a las claves de firmado criptográfico de la bitácora (`.sha256`).