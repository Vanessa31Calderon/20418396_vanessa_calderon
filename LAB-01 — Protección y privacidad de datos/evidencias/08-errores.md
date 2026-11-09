**1. ¿El intento de soporte_ana causó algún daño?** No. El motor bloqueó la transacción antes de modificar la tabla clientes, manteniendo la integridad del dato intacta.

**¿Por qué debe auditarse de todos modos?**

Auditar los accesos denegados y violaciones de permisos es vital para la seguridad detectivesca:

* Detección Temprana de Amenazas Internas: Permite identificar usuarios o cuentas comprometidas que intentan sobrepasar sus funciones o probar suerte con comandos para los cuales no tienen autorización.
* Identificación de Errores de Aplicación: Ayuda al equipo de soporte a diagnosticar fallos legítimos en el código de las aplicaciones cuando se realizan llamadas SQL incorrectas a tablas restringidas.
* Demostración de Eficacia de los Controles: Sirve como evidencia ante auditores externos de que el control de acceso (RBAC) configurado en la Unidad II efectivamente bloquea y registra intentos no autorizados.

**2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?**

La diferencia fundamental radica en el momento y el objeto de verificación:

* Error de Autenticación (Actividad 5): Ocurre en la puerta de entrada (¿Quién eres?). El servidor valida tu identidad y rechaza la conexión antes de iniciar la sesión. Su severidad es FATAL y corta la comunicación inmediatamente.

* Error de Autorización (Actividad 8): Ocurre dentro de la sesión (¿Qué tienes permiso de hacer?). El servidor ya reconoció quién eres, pero rechaza la ejecución de un comando específico (por ejemplo, DELETE) porque tu rol carece de privilegios (GRANT). Su severidad es ERROR y cancela la instrucción, pero mantiene la conexión abierta.

**3. ¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?**
El error role "soporte_ana" cannot be dropped because some objects depend on it indica que PostgreSQL prohíbe eliminar un rol si existen objetos asignados a su propiedad o si aún cuenta con permisos (GRANT) vigentes dentro de algún catálogo.