# 16. Actividad 10 — Responder a Dirección


**1. ¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?**
* **En la Actividad 2:** **No hay evidencia con esta edición.**  Durante la Actividad 2 el perfilador de operaciones (database profiler) se encontraba desactivado en su valor predeterminado (profiling level = 0), y la bitácora del servidor (systemLog) únicamente registra eventos de red, autenticación y administración del servicio, sin auditar operaciones de lectura o modificación sobre los datos.
* **En la Actividad 3:** La modificación fue ejecutada por el usuario **app_ventas@comercial** (conectado desde la dirección 127.0.0.1), según consta en el documento de operación op: "update" sobre el espacio de nombres **comercial.clientes** registrado en la colección system.profile tras habilitar el nivel 2 de perfilado.

---

**2. ¿Cuándo y desde qué aplicación?**
* **En la Actividad 2:** **No hay evidencia con esta edición.**  Al estar apagado el perfilador (level = 0), no se generó ningún registro con marca de tiempo (ts) ni identificador de cliente para esa operación.
* **En la Actividad 3:** La operación se ejecutó en la fecha y hora registradas en el campo **ts** del evento capturado en system.profile durante la Actividad 3, y provino de la aplicación identificada como **app-ventas-web** (valor declarado en el atributo appName de la cadena de conexión utilizada por el cliente).

---

**3. ¿Qué valor tenía antes?**
* **No hay evidencia con esta edición.**  
El perfilador de MongoDB (system.profile) registra exclusivamente la instrucción enviada al motor de base de datos, el criterio de búsqueda y la operación de actualización, pero no captura ni conserva una imagen previa (before-image) del documento antes de aplicar la modificación.

---

**4. ¿Cambió alguien los privilegios de app_ventas?**
* **No hay evidencia con esta edición** respecto a la identidad del autor o el instante exacto del cambio.  

En MongoDB Community Edition los comandos de administración de usuarios y asignación de roles no son registrados ni por el perfilador de operaciones ni por la bitácora estándar del servidor. Únicamente mediante el control compensatorio de instantáneas periódicas (auditoria.instantaneas_privilegios) se evidenció que el rol dbAdmin sobre comercial fue agregado temporalmente a app_ventas entre dos capturas consecutivas y posteriormente revocado, sin posibilidad técnica de atribuir el comando a un usuario específico.