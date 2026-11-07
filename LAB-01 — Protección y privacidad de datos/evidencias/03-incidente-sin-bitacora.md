1. ¿Puedes demostrar quién modificó el RFC?
No. Dado que en el momento de la ejecución el servidor operaba con la configuración por defecto (log_connections = off y log_statement = 'none'), el motor PostgreSQL no generó ninguna línea de registro. Desde el punto de vista auditables y forense, no existe evidencia técnica que vincule el comando UPDATE con el usuario app_ventas.

2. ¿Puedes demostrar que el cambio no lo hizo soporte_ana?
Tampoco. Al no existir un registro cronológico (log) de las conexiones ni de las sentencias ejecutadas, es imposible deslindar responsabilidades. Aunque el usuario soporte_ana solo tenga permisos de SELECT (configurados en la Unidad II), si existiera alguna vulnerabilidad o si se hubieran alterado los privilegios temporalmente, no habría forma de comprobar si esta cuenta u otra interactuaron con la tabla clientes durante ese intervalo de tiempo.

3. Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?
¿Lo impidieron? No. El usuario app_ventas cuenta legítimamente con el privilegio UPDATE sobre la tabla clientes para operar la aplicación.

¿Debían impedirlo? No. El control de acceso (Unidad II) responde a la pregunta "¿Quién PUEDE hacer qué?". La aplicación de ventas necesita modificar la tabla de clientes para su operación normal. Impedirle el cambio bloquearía la funcionalidad del sistema. La responsabilidad de prevenir el uso indebido de permisos legítimos no es de la autorización, sino de la auditoría (Unidad III), que responde a "¿Quién LO HIZO y cuándo?".

4. ¿Qué tendría que haber estado configurado antes del incidente?
Para contar con no repudio y trazabilidad completa ante este incidente, se requería previa implementación de:

Configuración de bitácora central en PostgreSQL:

logging_collector = on

log_connections = on y log_disconnections = on

log_line_prefix = '%m [%p] %u@%d %h %a ' (para capturar usuario, IP y nombre de la aplicación).

log_statement = 'mod' o 'all' (para capturar el comando UPDATE).

Tabla y Trigger de Auditoría a nivel de datos (Parte B): Un disparador AFTER UPDATE que respaldara en una tabla de auditoría el valor anterior (GAMA780912GHI) y el nuevo (GAMA780912XXX), junto con el timestamp y session_user.