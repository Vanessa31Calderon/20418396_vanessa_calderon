# 15. Actividad 9 — Comparar los tres escenarios

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
| :--- | :--- | :--- | :--- |
| **Acceso exitoso** | **Sí (observado)** — Registrado en la bitácora del servidor (log_connections = on) con usuario, base de datos, IP origen y hora. | **Sí (observado)** — Registrado en systemLog / getLog con el mensaje "Successfully authenticated", usuario, conexión (ctx) y aplicación. | **Documentado, no practicado** — Registrado mediante el evento nativo authenticate en la bitácora de auditoría estructurada. |
| **Acceso fallido** | **Sí (observado)** — Registrado en la bitácora de PostgreSQL con el usuario intentado y el motivo del rechazo. | **Sí (observado)** — Registrado en systemLog / getLog con "Failed to authenticate", código de error (18 u 11) y motivo interno (storedKey mismatch o UserNotFound). | **Documentado, no practicado** — Registrado mediante el evento nativo authenticate con código de resultado distinto de cero. |
| **Cambio de privilegios** | **Sí (observado)** — Las sentencias GRANT y REVOKE quedan registradas en la bitácora al habilitar log_statement = ddl o all. | **Parcial** — Ni el perfilador ni la bitácora registran comandos como grantRolesToUser o revokeRolesFromUser; solo mediante un control compensatorio de instantáneas periódicas se detecta qué rol cambió, sin saber quién lo ejecutó ni el momento exacto. | **Documentado, no practicado** — Registra de forma nativa las acciones grantRolesToUser, revokeRolesFromUser, createUser y dropUser con autor y marca de tiempo. |
| **Cambio de estructura** | **Sí (observado)** — Las sentencias DDL (CREATE, ALTER, DROP) se registran en la bitácora con usuario y consulta completa. | **Parcial** — Aunque MongoDB no impone esquema fijo en documentos, el perfilador activo registra comandos estructurales (create, drop, createIndexes), pero el registro se desactiva al reiniciar y tiene límite circular de 1 MB. | **Documentado, no practicado** — Registra de forma nativa acciones DDL como createCollection, dropCollection, renameCollection y createIndex. |
| **Modificación de datos** | **Sí (observado)** — Capturado tanto por la bitácora (log_statement = mod) como por disparadores (AFTER INSERT/UPDATE/DELETE) en tabla dedicada. | **Sí (observado)** — Capturado en system.profile (nivel 1 con filtro de escritura o nivel 2) indicando operación (insert, update, remove), colección, usuario y comando ejecutado. | **Documentado, no practicado** — Registrado en la bitácora de auditoría al habilitar auditAuthorizationSuccess para operaciones CRUD. |
| **Valor anterior del dato** | **Sí (observado)** — El disparador en PL/pgSQL captura y guarda el registro completo antes del cambio mediante la variable OLD. | **No** — El perfilador solo guarda el filtro de búsqueda (command.q) y la operación solicitada (command.u), nunca el estado previo del documento. | **No** — La auditoría nativa registra el evento y los parámetros de la operación ejecutada, pero no almacena imágenes previas (before-images) de los documentos modificados. |
| **Lectura de datos sensibles** | **Parcial** — Los disparadores DML estándar no detectan SELECT; solo queda en bitácora si se activa log_statement = all, generando alto volumen de registros. | **Parcial** — Se observa en system.profile al activar el nivel 2 (all), pero penaliza el rendimiento, sobrescribe rápido el búfer de 1 MB y se apaga al reiniciar el servicio. | **Documentado, no practicado** — Registra operaciones de lectura (find, getMore, aggregate) cuando se habilita auditAuthorizationSuccess con filtros de auditoría. |
| **Cambio de configuración del registro** | **Parcial** — Queda en bitácora si se ejecuta vía SQL (ALTER SYSTEM o pg_reload_conf), pero modificaciones directas en postgresql.conf desde el sistema operativo no pasan por el motor. | **Sí (observado)** — Queda registrado en systemLog / getLog con el evento "Profiler settings changed", permitiendo correlacionar el identificador ctx con la autenticación del administrador. | **Documentado, no practicado** — Registra cambios de parámetros (setParameter), arranque y apagado del servicio en la bitácora de auditoría nativa. |

---

# Actividad 8 - Evidencias tecnicas del expediente

## Evidencias generadas

- E1 (E1-configuracion-registro.txt): Parametros activos de registro de PostgreSQL 18 (logging_collector, log_connections, log_disconnections, log_statement, log_line_prefix y log_min_error_statement)[cite: 13].
- E2 (E2-privilegios.txt): Permisos vigentes sobre tablas y vistas para roles distintos a postgres (analista, analista_vanessa_calderon, app_comercializadora, app_ventas, soporte_ana, soporte_vanessa_calderon, u_20418396_vanessa_calderon y usr_consulta)[cite: 9].
- E3 (E3-disparadores.txt): Disparador trg_auditoria_clientes habilitado (O) en la tabla clientes[cite: 10].
- E4 (E4-muestra-auditoria.txt): Muestra de eventos (id_evento 1 al 9) en auditoria.cambios_clientes con INSERT, UPDATE y DELETE realizados por u_20418396_vanessa_calderon desde pgAdmin 4[cite: 11].
- E5 (E5-bitacora-postgresql.log y E5-bitacora-postgresql.sha256): Bitacora exportada del colector con registros del 2026-11-24 y su hash SHA-256[cite: 12].
- E6: Archivos copiados desde LAB-02 (system-profile.json, bitacora-mongod.log, sus hashes y la comparacion de la Actividad 9).

## Preguntas

1. **Compara E2 con la matriz de roles de la Unidad II. ¿Coinciden? Si no, ¿es un hallazgo?**  
   No coinciden del todo. En E2 se ve que soporte_vanessa_calderon tiene SELECT sobre v_clientes_soporte, pero soporte_ana tiene SELECT directo sobre public.clientes y app_ventas tiene SELECT y UPDATE directo sobre public.clientes; ademas, app_comercializadora y usr_consulta tienen acceso directo a varias tablas base y vistas[cite: 9]. Si la matriz de la Unidad II restringia a soporte a usar solo vistas enmascaradas o limitaba accesos directos a tablas base, estos permisos mas amplios si son un hallazgo que conviene revisar.

2. **¿Por qué E4 muestra solo metadatos y no valores_antes ni valores_despues?**  
   Para no exponer datos personales completos de los clientes (como nombre, correo, telefono, RFC o edad) en una muestra de auditoria[cite: 11]. Con id_evento, momento, usuario_sesion, aplicacion, operacion e id_cliente se comprueba que trg_auditoria_clientes registro los cambios sin duplicar informacion sensible[cite: 10, 11].

3. **¿Qué evidencia demostraría que E1 estuvo vigente durante todo el periodo revisado y no solo hoy?**  
   Los archivos rotados anteriores de la bitacora (con pg_ls_logdir()), las entradas con distintas fechas y horas dentro de la bitacora (como los eventos del 2026-11-06 y 2026-11-24) y los respaldos o capturas historicas de configuracion del servidor[cite: 11, 12, 13].