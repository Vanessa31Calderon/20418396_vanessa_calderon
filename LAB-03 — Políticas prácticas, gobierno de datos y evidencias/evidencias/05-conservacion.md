# Actividad 5 - Criterio de conservación de bitácoras

## Tabla de conservación

| Registro | Ubicación actual | Riesgo de pérdida observado | Sensibilidad | Periodo propuesto | Justificación | Dónde se conserva | Quién puede leerlo | Acción al vencer |
|---|---|---|---|---|---|---|---|---|
| Accesos de PostgreSQL | Archivo del colector (pg_current_logfile()) | Rotación del archivo; reinstalación o recreación del servidor | Media | 90 días activos y 1 año archivado | Sirve para revisar intentos de acceso raros o conexiones fuera de horario | En un servidor o carpeta externa de solo lectura | DBA y Seguridad / Auditoría | Borrado seguro |
| Cambios de privilegios y estructura | Archivo del colector | Rotación del archivo o que alguien con permisos altos lo borre si solo está en el mismo servidor | Alta | 2 años (Plazo a confirmar con el área jurídica para temas de auditoría) | Son pocos eventos pero muy delicados; si alguien se dio permisos indebidos puede tardar meses en notarse | En un almacenamiento externo donde no se pueda modificar | Seguridad y Auditoría Interna | Borrado seguro con autorización |
| Modificaciones de datos (log_statement = mod) | Archivo del colector | Crece rápido y rota seguido; además guarda datos en texto plano | Alta | 90 días | Alcanza para investigar errores o incidentes recientes sin acumular copias innecesarias de datos personales | Almacenamiento externo cifrado | DBA y Auditoría Interna | Eliminación automática |
| auditoria.cambios_clientes | Tabla en comercial | Puede crecer mucho o borrarse por error si no se restringe bien | Alta (contiene datos personales) | 1 año en la tabla; el archivo histórico a confirmar con el área jurídica (por el choque entre obligaciones fiscales y eliminación de datos personales) | Permite comprobar cambios en clientes, pero teniendo cuidado de no guardar para siempre datos de personas que ya pidieron borrarlos | En la base comercial (solo insertar/leer) y respaldo cifrado aparte | Auditoría (solo lectura) y DBA | Anonimizar los datos personales o borrar de forma segura |
| Bitácora de mongod | systemLog.path o salida estándar; getLog solo en memoria | Si se reinicia el servicio se pierde lo que estaba en memoria; los archivos locales rotan | Media | 90 días | Sirve para revisar fallas del servicio, reinicios y errores de inicio de sesión | Carpeta o servidor externo de logs | Admin MongoDB y Seguridad | Borrado automático |
| system.profile | Colección limitada de 1 MB | Se sobrescribe sola cuando se llena | Alta (guarda consultas con datos personales) | 30 días (si se exporta fuera de la colección) | Solo se necesita para revisar consultas lentas recientes, no tiene caso guardarla años | Almacenamiento de monitoreo cifrado | DBA y Seguridad | Eliminación automática |
| Instantáneas de privilegios (MongoDB) | auditoria.instantaneas_privilegios | Si se borra la base sin respaldo externo se pierde el historial | Alta | 1 a 2 años (Plazo a confirmar con el área jurídica) | Permite comparar qué permisos tenía cada usuario en fechas pasadas | Base de auditoría y copia externa | Auditoría Interna y Seguridad | Archivo histórico o borrado autorizado |

Nota: Como vimos en el LAB-01, guardar tablas de auditoría o logs con datos de clientes choca con la regla de borrar datos personales cuando ya no se necesitan. Por eso los plazos largos se deben revisar con el área jurídica y, si se puede, anonimizar los datos personales en lugar de borrar todo el registro de auditoría.

## Preguntas

1. **¿Por qué la bitácora de cambios de privilegios merece más tiempo de conservación que la de consultas rutinarias?**  
   Porque los cambios de permisos casi no ocupan espacio pero son críticos para la seguridad: si alguien altera roles o se da acceso extra, a veces se descubre meses después en una auditoría. En cambio, las consultas diarias generan archivos enormes, casi no sirven a largo plazo y solo aumentan el riesgo de exponer datos personales.

2. **¿Qué control de integridad aplicarás a las bitácoras exportadas?**  
   Sacarles un hash SHA-256 en cuanto se exporten y guardarlo aparte, además de mover los archivos a una carpeta o servidor externo de solo lectura. Así, si después se necesitan revisar, se vuelve a calcular el hash para comprobar que nadie los modificó ni les borró líneas.

3. **¿Qué diferencia hay entre conservar una bitácora y respaldar una base de datos?**  
   Respaldar una base de datos sirve para poder recuperarla y seguir trabajando si se daña el servidor o se borran datos por accidente. Conservar una bitácora sirve para tener pruebas de qué pasó, quién hizo un cambio y cuándo ocurrió, por lo que lo más importante es que nadie la altere y que esté separada de la operación normal.