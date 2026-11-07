# 17. Actividad 11 — Crear la función y el disparador
**1. ¿Por qué se ejecuta REVOKE ALL ON FUNCTION ... FROM PUBLIC si el disparador seguirá funcionando para app_ventas?**

* Para revocar la ejecución directa manual (EXECUTE): En PostgreSQL, por defecto, el rol PUBLIC cuenta con permiso EXECUTE sobre las funciones recién creadas. Si no se ejecuta REVOKE, cualquier usuario autenticado (como soporte_ana o app_ventas) podría invocar la función de forma explícita mediante un comando SQL (SELECT auditoria.registrar_cambio_cliente(...)).
* Inmunidad de los Disparadores (Triggers): Los disparadores son activados internamente por el motor PostgreSQL como una reacción automática a eventos DML sobre la tabla. El motor valida los permisos del disparador bajo el contexto del propietario de la función (SECURITY DEFINER), por lo que los usuarios operativos no necesitan permisos de ejecución directa sobre la función para que el disparador funcione correctamente.

**2. ¿Qué pasaría si la función no fuera SECURITY DEFINER?** (Hipótesis)

* Si la función fuera SECURITY INVOKER, se ejecutaría con los privilegios del usuario que invoca la operación DML (por ejemplo, app_ventas).

* Efecto de Fallo: Dado que el rol app_ventas carece de permisos de escritura (INSERT) sobre la tabla privada auditoria.cambios_clientes, cuando app_ventas ejecute un UPDATE sobre la tabla clientes, la transacción entera fallará con un error de permisos (ERROR: permission denied for table cambios_clientes), impidiendo que la aplicación pueda realizar ventas u operaciones legítimas.

**3. Consulta dba.bitacora. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué?**
Sí, quedó registrada la creación de todos estos objetos en dba.bitacora porque desde la Actividad 4 el parámetro del servidor log_statement fue configurado en ddl, lo que obliga al motor de PostgreSQL a capturar y escribir en la bitácora física cualquier sentencia de definición de estructura o control de catálogo (CREATE SCHEMA, CREATE TABLE, CREATE FUNCTION y CREATE TRIGGER) en el momento exacto en que son ejecutadas por la sesión del administrador.

# 18. Actividad 12 — El incidente auditado
**1. Compara tu hipótesis de la Actividad 11 con este resultado.**

El resultado confirmó la hipótesis planteada: el mecanismo de seguridad funcionó en dos niveles. Primero, la cláusula SECURITY DEFINER permitió que la función de disparador se ejecutara exitosamente con los derechos del propietario (usuario_efectivo = postgres), posibilitando la inserción en la tabla de auditoría sin que la aplicación sufriera errores. Segundo, el uso explícito de session_user garantizó la captura de la identidad real del autor (usuario_sesion = app_ventas). Por su parte, la revocación de permisos (REVOKE ALL ON SCHEMA auditoria) impidió de forma efectiva que el usuario operativo pudiera consultar o alterar el registro de auditoría.

**2. Escribe la sentencia UPDATE que restauraría el valor anterior.**

**3. ¿Qué columna conserva más valor para una investigación: aplicacion o ip_cliente? ¿Cuál puede falsificar el cliente con más facilidad?**
* Columna de mayor valor forense: ip_cliente. Es determinada a nivel de socket de red TCP/IP por la pila de red del sistema operativo al establecer la conexión, siendo una evidencia técnica sólida de la procedencia.
* Columna más fácil de falsificar: aplicacion (application_name). Es una variable de texto libre que el cliente o atacante declara arbitrariamente en la cadena de conexión, por lo que sirve para identificar sistemas legítimos bien configurados, pero no constituye una prueba irrefutable de identidad.