**1. ¿Por qué el proceso que registra el cambio es el principal (postmaster/PID 1) y no tu sesión?**
Porque el comando SELECT pg_reload_conf() le envía una señal de sistema al proceso padre/principal de PostgreSQL (postmaster). Es el proceso principal el que se encarga de re-leer los archivos de configuración (postgresql.conf y postgresql.auto.conf) y notificar o propagar los nuevos parámetros de memoria a los procesos de backend subordinados. Por ello, el log asigna la línea del cambio de parámetros al PID principal, sin contexto de sesión individual (user= db= app= client=).

**2. ¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log_statement = 'none'?¿Quedaría rastro?** 
Sí, sí quedaría rastro.

Aunque la sentencia SQL ALTER SYSTEM en sí misma no quedara grabada en el momento exacto de escribirse (si estuviera desactivado DDL), al ejecutarse el posterior recargo de configuración (pg_reload_conf() o señal SIGHUP), el proceso maestro registrará explícitamente en el log la línea:

    LOG: parameter "log_statement" changed to "none"

Esto constituye una salvaguarda de auditoría clave: la desactivación o alteración de cualquier parámetro de registro siempre deja una huella inmutable del evento de reconfiguración en la bitácora física del motor.

**3. ¿Por qué no se recomienda editar postgresql.auto.conf a mano?**
porque esta diseñado para ser sobrescrito de forma automática por PostgreSQL al ejecutar comandos ALTER SYSTEM. Cualquier cambio o comentario manual puede ser sobrescrito o eliminado sin previo aviso en la siguiente ejecución de ALTER SYSTEM, 

Aparte existe: 
* Riesgo de corrupción de sintaxis: Si se introduce un error sintáctico manual en dicho archivo, la instancia puede fallar al reiniciar o al intentar recargar la configuración.
* Pérdida de trazabilidad de cambios: Los cambios directos en archivos del sistema operativo omiten las validaciones internas de tipos de datos y rangos que el motor realiza antes de aplicar ALTER SYSTEM. La buena práctica dicta modificar postgresql.conf para parámetros de infraestructura persistentes, o usar ALTER SYSTEM para ajustes remotos y administrados por SQL.