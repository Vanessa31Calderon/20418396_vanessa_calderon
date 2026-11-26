# 13. Actividad 7 - Registro de cambios y conciliación

## Tabla de conciliación

| Momento (bitácora) | Usuario | Sentencia | Folio que lo autoriza | ¿Autorizado? | Hallazgo |
|---|---|---|---|---|---|
| 2026-11-24 23:04:33.6... | u_20418396_vanessa_calderon | CREATE SCHEMA IF NOT EXISTS gobierno; | Sin folio (preparación de la actividad) | No | Cambio de estructura sin folio previo registrado |
| 2026-11-24 23:04:36.4... | u_20418396_vanessa_calderon | REVOKE ALL ON SCHEMA gobierno FROM PUBLIC; | Sin folio (preparación de la actividad) | No | Cambio de permisos sin folio previo registrado |
| 2026-11-24 23:04:39.4... | u_20418396_vanessa_calderon | CREATE TABLE IF NOT EXISTS gobierno.solicitudes_cambio... | Sin folio (preparación de la actividad) | No | Creación de tabla de gobierno sin folio previo registrado |
| 2026-11-24 23:05:13.4... | u_20418396_vanessa_calderon | ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20)... | CAM-2026-014 | Sí | Ninguno (ejecutado dentro de la ventana autorizada) |

Nota: La creación de la vista dba.bitacora no aparece en esta conciliación porque cuando se creó el parámetro log_statement estaba en none, lo cual se declara como un hueco de evidencia. Además, las líneas anteriores del LAB-01 (como cambios de roles, permisos o el disparador trg_auditoria_clientes) no figuran en esta extracción puntual de la bitácora actual, por lo que cualquier revisión histórica completa debe contemplar también los registros previos del servidor y cuidar que no queden contraseñas expuestas en texto plano.

## Preguntas

1. **¿Qué cambios de la bitácora no tienen folio? Clasifícalos: ¿son de preparación del laboratorio o representan hallazgos?**  
   Las sentencias de creación del esquema gobierno, revocación de permisos en PUBLIC y creación de la tabla gobierno.solicitudes_cambio (líneas 66, 67 y 68) no tienen folio. Son de preparación del laboratorio para montar el control de cambios, aunque en un entorno de producción real contarían como hallazgos de cambios sin folio previo; en cambio, los cambios de privilegios y la desactivación del disparador de auditoría observados en el LAB-01 representan hallazgos de control y seguridad.

2. **La desactivación del disparador del LAB-01 (Actividad 14), ¿qué tan grave es como hallazgo? ¿Por qué? ¿Qué distingue la línea 163 de la 169?**  
   Es un hallazgo crítico porque desactivar trg_auditoria_clientes deja sin registro en auditoria.cambios_clientes las modificaciones o eliminaciones hechas sobre la tabla clientes. Lo que distingue la línea 163 de la 169 es quién ejecutó la sentencia y el resultado: en la 163 lo intentó app_ventas y falló por falta de privilegios (evidencia de un intento no autorizado), mientras que en la 169 lo ejecutó postgres y sí procedió por tener privilegios de superusuario.

3. **¿Qué limitación tiene esta conciliación si log_statement estuvo en none durante algún periodo?**  
   Deja un periodo ciego sin trazabilidad donde no queda constancia en la bitácora de las sentencias ejecutadas (como ocurrió al crear dba.bitacora). Por lo tanto, no se puede asegurar con certeza que no se hayan hecho cambios de estructura o permisos durante ese lapso.

4. **¿Quién debería realizar la conciliación: el DBA que hizo los cambios u otra persona?**  
   Debe realizarla otra persona distinta, como un auditor interno o alguien de Seguridad de la Información, para respetar la separación de funciones y evitar que quien ejecuta los cambios valide por sí mismo su propio trabajo.