**1. ¿Por qué no apareció SELECT nombre, ciudad ...?**

Porque el rol auditor (auditor_datos) solo tiene concedido el privilegio SELECT sobre las columnas rfc y telefono. Como la consulta SELECT nombre, ciudad únicamente leyó columnas no sensibles, pgaudit la filtró e ignoró por completo.

**¿Por qué SÍ apareció SELECT *?***

Porque el comodín * expande dinámicamente todas las columnas de la tabla clientes, incluyendo rfc y telefono. Al tocar explícitamente columnas donde el rol auditor_datos tiene otorgados privilegios, pgaudit activa la alerta y genera la entrada de auditoría en la bitácora.

**2. ¿Por qué no apareció UPDATE ... ciudad ...?**
No apareció porque el rol auditor_datos solo cuenta con permiso UPDATE restringido a las columnas rfc y telefono (GRANT UPDATE (rfc, telefono)). Al ejecutarse UPDATE clientes SET ciudad = 'Navolato', la sentencia afectó una columna fuera del ámbito de interés definido para el auditor, permitiendo ignorar modificaciones masivas u operativas sobre campos ordinarios que no requieren fiscalización de seguridad.

**3. ¿Qué diferencia de volumen esperarías frente a log_statement = 'all'?**
Se espera una reducción drástica de volumen de bitácora (de hasta un 90% a 99%) en servidores de producción con alta carga transaccional:

* Con log_statement = 'all': El motor graba indiscriminadamente absolutamente todas las sentencias enviadas (SELECT, INSERT, UPDATE, DELETE) sobre todas las tablas del sistema (catálogos internos, tablas temporales, datos no sensibles), provocando saturación de I/O y agotamiento rápido de almacenamiento.

* Con pgaudit en Modo Objeto (pgaudit.role): El motor actúa como un bisturí de precisión: solo escribe en disco cuando una sentencia consulta o modifica de forma específica las columnas clasificadas como críticas (rfc, telefono). Las miles de lecturas operativas sobre el resto de las tablas transaccionales no generan registro alguno, conservando el espacio en disco y el rendimiento del procesador.

**4. El README oficial advierte que pgaudit no puede auditar de forma confiable a los superusuarios. ¿Qué implica para la separación de funciones?**
* Implicación Forense y de Seguridad: Los superusuarios (postgres / superuser) tienen la capacidad nativa de omitir las verificaciones de permisos, cambiar variables de sesión sobre la marcha (SET pgaudit.role = ''), deshabilitar la extensión o recargar la configuración del motor sin pasar por los filtros de pgaudit.role.
* Relación con la Separación de Funciones: Confirma de nuevo que el control técnico dentro de la base de datos es insuficiente para fiscalizar al superusuario. Para lograr una auditoría con validez legal e inalterabilidad:
    * Las cuentas de superusuario deben estar estrictamente limitadas y auditadas desde fuera del motor.
    *  Las bitácoras generadas por pgaudit deben transmitirse de forma síncrona mediante Syslog/TLS hacia un sistema de gestión de eventos independiente (SIEM) bajo el control exclusivo del área de Auditoría Interna o Seguridad de la Información, privando al DBA de la capacidad de modificar o eliminar los rastros de sus propias acciones.