# 8. Actividad 2 — Que el servidor administre su propia bitácora

**¿Por qué logging_collector requiere reinicio y log_statement solo recarga?**

* logging_collector es un proceso hijo de arquitectura que PostgreSQL debe instanciar al arrancar su proceso principal y redirigir los descriptores de archivo del sistema.

* log_statement es una variable interna de control de flujo en la memoria compartida que los procesos de backend consultan antes de parsear e interpretar una sentencia SQL, por lo que una recarga del archivo de configuración basta para cambiar su valor al vuelo.

**¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?**

* Ventaja: Permite realizar análisis forenses mediante consultas complejas directamente en una sesión cliente como psql, sin requerir credenciales de usuario root o acceso SSH al servidor físico.

* Riesgo: Introduce una superficie de ataque si la función pg_read_file o la vista dba.bitacora son expuestas a roles no administrativos, pues permitirían leer archivos arbitrarios del sistema donde el usuario de PostgreSQL tenga permisos de lectura.

**¿Quién debería poder consultar dba.bitacora?**

Únicamente roles con responsabilidad de Auditoría de Seguridad o el equipo DBA (Superusuarios). Los roles operativos o la cuenta utilizada por servicios web deben tener restringido de forma absoluta el acceso al esquema dba y a la función pg_read_file().