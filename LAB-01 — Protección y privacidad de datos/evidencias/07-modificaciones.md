**1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?**
* Nivel Requerido: El nivel all (log_statement = 'all') es el único en la bitácora nativa que registra absolutamente todas las sentencias SQL ejecutadas en el motor, incluyendo consultas SELECT.
* Impacto y Costo Técnico de log_statement = 'all' en Producción:
    * Saturación de I/O y Almacenamiento: En una base de datos con alta carga operativa (miles de SELECT por segundo), la bitácora crecería a un ritmo de gigabytes por hora. Esto satura el ancho de banda del disco, agota rápidamente el espacio en disco y degrada la latencia global del servidor.
    * Sobrecarga de CPU: El motor gasta ciclos apreciables de procesador formateando cada consulta con su prefijo y escribiéndola síncronamente o en buffer a disco.
    * Riesgo Severo de Fuga de Información: Las consultas SELECT con frecuencia filtran por datos personales, tokens o contraseñas en sus cláusulas WHERE. Registrar all implica escribir todos esos datos sensibles en texto plano dentro del archivo .log.

**2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza?**
A la bitácora del servidor le falta el valor previo del dato que fue sobrescrito.

* La Limitación de la Bitácora de Sentencias: El log solo guarda la cadena de texto SQL de la sentencia enviada por el cliente. Si el comando UPDATE afectara 500 registros o utilizara valores calculados, la sentencia SQL no muestra cuáles eran los salarios o teléfonos anteriores de cada cliente individual.
* La Solución Requerida: Para poder revertir el cambio de forma exacta o realizar auditoría a nivel de registro, se requiere la Parte B: Auditoría a nivel de dato, la cual captura los objetos OLD y NEW de cada tupla afectada en formato JSONB.