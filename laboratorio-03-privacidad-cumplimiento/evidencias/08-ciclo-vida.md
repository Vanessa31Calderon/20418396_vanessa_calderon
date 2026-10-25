# 12. Actividad 6 — Derechos ARCO y la base de datos
## 12.1 Derecho de acceso
**¿Qué información adicional debería proporcionar la organización además del resultado de esta consulta?**
- Copias y respaldos: Indicar si la información reside en bases de datos secundarias, data warehouses, réplicas de lectura o archivos de backup a largo plazo.
- Trazabilidad y accesos: Especificar qué roles internos o aplicaciones tienen privilegios técnicos para leer, consultar o modificar este registro.
- Integraciones externas: Detallar si los datos han sido transmitidos o sincronizados mediante APIs, webhooks o procesos ETL hacia sistemas de terceros, como CRMs, pasarelas de pago o plataformas de correo.
- Procesamiento automatizado: Aclarar si los atributos del usuario, como la edad o ciudad, alimentan vistas agregadas, algoritmos de segmentación o modelos de perfilado comercial.

# 13. Actividad 7 — Derecho de rectificación
**1. ¿Cómo podría comprobarse que el cambio fue autorizado?**
Mediante la asociación de la actualización con un folio de atención, ticket de soporte o registro de autenticación del titular, respaldado técnicamente por una tabla de auditoría que documente el origen exacto de la solicitud.

**2. ¿Debería registrarse quién realizó el cambio?**
Sí. Identificar al operador, sistema o rol de base de datos que ejecutó la sentencia UPDATE es un requisito indispensable de seguridad, auditoría y gobierno de datos.

**3. ¿Por qué la trazabilidad será importante?**
Para garantizar la rendición de cuentas (accountability), detectar modificaciones maliciosas o accidentales, y demostrar ante autoridades regulatorias el cumplimiento normativo en la atención de los Derechos ARCO.

# 14. Actividad 8 — Derecho de cancelación y ciclo de vida
**¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?**
Ejecutar un comando DELETE en la tabla principal únicamente elimina el registro del entorno operativo actual. La información de la persona persiste en la infraestructura debido a la dispersión lógica y física de los datos:
    - Respaldos (Backups): Las copias de seguridad históricas conservan la información intacta hasta que la cinta o archivo caduca y es sobrescrito por la rotación del respaldo.
    - Réplicas y Data Warehouses: Los entornos de análisis, desarrollo o pruebas alimentados previamente por procesos ETL retienen el registro si no implementan un mecanismo de sincronización de eliminaciones.
    - Archivos y Reportes: Las extracciones previas exportadas en formatos estáticos (Excel, CSV, PDF) y distribuidas en equipos locales o servidores de archivos no se actualizan automáticamente.
    - Sistemas Externos: Las plataformas de terceros (CRMs, procesadores de pago, herramientas de mailing) que recibieron el dato mediante APIs mantienen su propia copia aislada, la cual requiere una solicitud de borrado independiente.



