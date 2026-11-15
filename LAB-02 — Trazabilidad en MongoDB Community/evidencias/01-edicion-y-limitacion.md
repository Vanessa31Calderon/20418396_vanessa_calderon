# 7. Actividad 1 — Lo que no existe en esta edición

**1. ¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?**
Estoy usando la edición gratuita, MongoDB Community Edition, en su versión 9.0.8. Me doy cuenta porque al revisar los módulos cargados en el servidor, la lista aparece completamente vacía. Si tuviera instalada la edición de paga, ahí aparecería el nombre de Enterprise.   
image_a35f45.png

---

**2. ¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?**
El servidor va guardando todos sus registros en un archivo dentro de mi computadora, ubicado exactamente en C:\Program Files\MongoDB\Server\9.0\log\mongod.log. Lo comprobé revisando la configuración con la que arrancó el servicio, donde se indica que la bitácora se envía a un archivo y muestra esa ruta específica.   

----

**3. Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?**

Si contara con la auditoría nativa de las ediciones de paga, podría registrar cuatro tipos de eventos:

* Cambios en la estructura de la base de datos, como crear, modificar o eliminar colecciones e índices.

* Eventos internos de servidores que trabajan en conjunto, como conjuntos de réplicas y clústeres fragmentados.

* Inicios de sesión, validaciones de identidad y cambios en los permisos de los usuarios.

* Movimientos directos sobre los datos, como leer, agregar, editar o borrar registros, siempre y cuando se active la opción para guardar también las operaciones exitosas.

---
**4. ¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?**
Antes de hacer esa inversión, la empresa tiene que evaluar si el costo de las licencias o del servicio en la nube realmente se justifica frente al riesgo que corren sus datos. También debe analizar si alguna ley o auditoría externa le exige tener esa función obligatoriamente, si su equipo técnico puede cubrir esa necesidad usando controles alternativos en la versión gratuita, y si sus políticas de privacidad permiten alojar la información de sus clientes en servidores externos en la nube.