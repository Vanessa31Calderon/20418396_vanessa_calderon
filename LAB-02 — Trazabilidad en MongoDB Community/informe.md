#   19. Informe

**1. Despliegue, edición y limitación**

Se desplegó MongoDB Community Edition en Windows y se trabajó desde MongoDB Compass con su consola mongosh y PowerShell. Esta edición no cuenta con auditoría nativa de seguridad ni registra comandos administrativos de asignación de roles. Esto se verificó activando el perfilador en nivel 2, ejecutando grantRolesToUser sobre el usuario app_ventas y buscando el evento tanto en system.profile como en getLog, obteniendo 0 coincidencias en ambas fuentes.

--- 

**2. Perfilador**

Se configuró mediante db.setProfilingLevel iniciando apagado en nivel 0, pasando a nivel 2 para capturar todas las operaciones y dejándolo en nivel 1 con filtro para registrar únicamente insert, update y remove. Permite interpretar qué usuario, aplicación, dirección IP y comando modificaron un documento, aunque no guarda el valor anterior. Su costo radica en que el nivel 2 afecta el rendimiento al registrar cada lectura, utiliza una colección circular de 1 MB que sobrescribe los registros más antiguos y vuelve a nivel 0 al reiniciar el servicio.

--- 

**3. Bitácora de mongod**

En el despliegue realizado se consultó directamente desde la memoria RAM mediante el comando getLog, aunque puede configurarse en disco con systemLog.path. Permite identificar autenticaciones exitosas y fallidas, además de detectar cambios en la configuración del perfilador mediante el mensaje Profiler settings changed, logrando vincular el cambio con el administrador que inició sesión gracias al identificador de conexión ctx.

---

**4. Privilegios**

Ni el perfilador ni la bitácora dejan evidencia de los comandos que otorgan o revocan roles. Como control compensatorio se creó la colección auditoria.instantaneas_privilegios para guardar capturas de los usuarios y sus roles antes y después de los cambios. El límite de este método es que confirma qué privilegio cambió entre dos instantáneas, pero no indica quién ejecutó la modificación ni el instante exacto en que ocurrió.

---

**5. Conservación**

Los riesgos observados son que reiniciar el servicio regresa el perfilador a nivel 0 y vacía la memoria de getLog, mientras que system.profile sobrescribe información al llenarse su límite de 1 MB y getLog solo conserva los últimos 1024 eventos. Para evitar perder evidencia antes de reiniciar el servicio en Windows, se exportaron system-profile.json y bitacora-mongod.log desde mongosh y se generaron sus firmas SHA-256 en PowerShell dentro de hashes.sha256. Tras el reinicio se comprobó que el estado volvió a was: 0 y que se conservaron 3 documentos en system.profile.   


---

**6. Comparación**

PostgreSQL combinado con bitácora y disparadores ofrece el control más completo porque registra accesos, cambios de permisos, consultas y el valor anterior de los datos. MongoDB Community aporta trazabilidad parcial sobre operaciones de datos y accesos, pero carece de registro nativo de privilegios y de valores previos. MongoDB Enterprise o Atlas cubren la auditoría nativa de accesos, estructura y privilegios, aunque tampoco almacenan el estado anterior de los documentos modificados.

---

**7. Recomendación**

Como hecho verificado en la práctica, MongoDB Community no registra los comandos de cambio de privilegios y las instantáneas solo detectan la diferencia entre dos momentos sin identificar al autor. Si la organización necesita auditar cambios de privilegios por cumplimiento o seguridad estricta, recomiendo migrar a MongoDB Enterprise o MongoDB Atlas para utilizar su auditoría nativa, bajo el supuesto de que cuentan con presupuesto para licenciamiento. Si deben continuar con la edición Community por costos, recomiendo automatizar la toma de instantáneas en intervalos cortos, limitar al mínimo los usuarios administradores y restringir los permisos sobre la colección de auditoría para evitar alteraciones.

---

# 20. Preguntas de reflexión
**1. ¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?**

Porque es una herramienta pensada para analizar rendimiento y no seguridad: no registra cambios de privilegios, no guarda el valor anterior de los registros, tiene un límite circular de 1 MB donde la evidencia antigua se sobrescribe sola y se apaga automáticamente cada vez que se reinicia el servidor.

**2. ¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?**

Porque cuando está encendido permite rastrear qué usuario, desde qué IP, con qué aplicación y en qué fecha y hora exactas se ejecutó una consulta o modificación sobre una colección determinada.

**3. ¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?**

Que cualquier usuario o administrador con permiso de lectura sobre system.profile podrá visualizar información confidencial en texto claro dentro de los filtros de búsqueda, como nombres, RFC, teléfonos o correos de clientes, exponiendo datos personales innecesariamente.

**4. ¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?**

Detectar un cambio significa comprobar que un dato o permiso es distinto respecto a un estado anterior, como sucede al comparar dos instantáneas de roles; atribuirlo a alguien significa contar con evidencia directa que demuestre qué cuenta de usuario y qué sesión ejecutaron esa acción.

**5. ¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?**

Porque permite diseñar controles compensatorios adecuados, informar con transparencia los riesgos reales a Dirección y evitar generar una falsa sensación de seguridad sobre herramientas que no cubren todos los requisitos de control.