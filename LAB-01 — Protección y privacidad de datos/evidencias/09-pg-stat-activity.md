**1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?**

La columna pid (Process ID del backend del servidor).

* En pg_stat_activity, la columna pid identifica de forma única al proceso hijo de PostgreSQL que atiende la conexión activa.

* En la bitácora física (.log), este mismo número aparece entre corchetes mediante el marcador %p del prefijo de línea (log_line_prefix), por ejemplo: [189]. Esto permite correlacionar instantáneamente lo que ocurre en memoria con el registro en disco.

**2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?**

La bitácora física del servidor (dba.bitacora / archivos .log).pg_stat_activity es un mecanismo de observabilidad en tiempo real que destruye los registros de la sesión tan pronto como esta finaliza o se desconecta. La bitácora actúa como el archivo histórico permanente donde persisten la fecha/hora de inicio, la desconexión con la duración total de la sesión, e incluso la sentencia ejecutada (si aplica el nivel de registro configurado).

**3. ¿Por qué client_addr aparece vacío (o como NULL) en la sesión del administrador?**

Porque la sesión del administrador se estableció mediante un socket de dominio Unix, es decir, una conexión local directa entre procesos dentro del propio sistema operativo donde corre PostgreSQL, sin pasar por la pila de red TCP/IP. Al no utilizar una interfaz de red, no existe una dirección IP de origen.