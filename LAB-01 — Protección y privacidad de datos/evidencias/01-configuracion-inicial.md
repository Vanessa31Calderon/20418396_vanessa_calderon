# 7. Actividad 1 — Cuestionario de Configuración Inicial

**Con esta configuración, ¿se registra quién se conecta?** No. log_connections se encuentra en off. Los intentos de conexión (exitosos o fallidos) son ignorados por la bitácora del motor.

**¿Se registran las sentencias UPDATE?** No. log_statement está configurado en none, por lo cual ninguna consulta DML o DDL queda grabada.

**¿La línea de bitácora incluye el usuario o la dirección IP del cliente?** No. El parámetro log_line_prefix predeterminado es %m [%p], el cual únicamente imprime la fecha/hora con milisegundos (%m) y el PID del proceso del servidor (%p).

**¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?** Se registran en la zona configurada por log_timezone. Importancia: Si el servidor web/aplicación registra eventos en hora local y la base de datos en UTC, la correlación de eventos durante un incidente requerirá una conversión estricta para no desestimar la secuencia cronológica de los ataques.

**Con logging_collector = off, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?** El mecanismo de despliegue de la infraestructura (Linux journalctl/systemd, Docker logging driver, o servicios de Windows). PostgreSQL únicamente envía su salida a stderr.

