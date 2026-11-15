# 9. Actividad 3 — Activar el perfilador y registrar operaciones
| # | op | Usuario | Cliente | Aplicación | Momento | Qué hizo | Documentos afectados |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | query | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-15T06:41:45.324Z | Buscó los clientes de Culiacán mostrando solo su nombre y ciudad | Revisó 5 y devolvió 3 |
| 2 | update | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-15T06:42:17.483Z | Cambió el RFC del cliente 3 a GAMA780912XYZ | Revisó 1 y modificó 1 |
| 3 | remove | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-15T06:42:25.404Z | Eliminó el registro del cliente 2 | Revisó 1 y eliminó 1 |

---

**1. ¿Puedes saber cuál era el RFC antes del cambio con la información de system.profile?** 
No, con esa información no es posible saber qué valor tenía antes. El perfilador únicamente guarda la instrucción que envió la aplicación junto con el dato nuevo, pero no conserva una copia de cómo estaba el registro antes de ser modificado.

---

**2. ¿Puedes saber qué datos tenía el documento eliminado?**
Tampoco es posible saberlo. En el registro de eliminación solo aparece el criterio que se usó para ubicar y borrar el documento, que en este caso fue su identificador número 2, pero no se guardan los demás datos que contenía ese cliente antes de desaparecer.

---

**3. A diferencia de log_statement = 'mod' en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**
La principal ventaja es que permite detectar fugas o robos de información, ya que queda evidencia cuando alguien consulta o extrae datos confidenciales aunque no modifique nada. El riesgo es que, al registrar absolutamente todas las lecturas del sistema, la base de datos se vuelve más lenta y los registros nuevos terminan borrando muy rápido a los antiguos debido a que el espacio de almacenamiento del perfilador es limitado.

---

**4. ¿Por qué el campo user incluye @comercial?**
Porque en MongoDB cada cuenta de usuario pertenece a la base de datos específica donde fue creada y donde se valida su contraseña. En este caso, el usuario app_ventas se dio de alta dentro de la base de datos comercial, y esa etiqueta sirve para identificar su origen y distinguirlo de usuarios creados en otras bases del servidor.