# 12. Actividad 6 — Correlacionar un cambio de configuración con su autor
**1. ¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?** 
El cambio lo realizó el usuario admin. Esto se demuestra relacionando dos eventos distintos de la bitácora a través del mismo número de conexión.
* **El cambio de ajuste (`Profiler settings changed`):** Registra que dentro de la conexión `conn45` se modificó la configuración del perfilador en la base de datos `comercial`.
* **El inicio de sesión previo (`Successfully authenticated`):** Confirma que en esa misma conexión `conn45` el usuario `admin` fue quien ingresó sus credenciales y abrió la sesión.

---

**2. ¿Qué condición debe cumplirse para que esta correlación sea válida?**
Ambos eventos deben haber ocurrido dentro de una misma sesión continua del servidor, sin que el servicio de MongoDB se haya apagado o reiniciado entre un registro y otro. Cuando el servidor se reinicia, la numeración de las conexiones vuelve a empezar desde cero, por lo que un mismo identificador podría pertenecer a usuarios diferentes en momentos distintos. Asimismo, el evento de autenticación debe ocurrir antes que el cambio de configuración dentro de ese mismo encendido.

---

**3. ¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?** 
Porque si un atacante o alguien con malas intenciones consigue acceso de administrador, una de las primeras medidas que suele tomar es apagar o modificar los controles de vigilancia para no dejar rastro antes de robar o alterar datos. Que el sistema guarde de forma automática quién cambió las reglas del perfilador permite detectar si alguien intentó dejar ciega la auditoría a propósito.