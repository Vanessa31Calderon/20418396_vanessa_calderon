# 13. Actividad 7 — Cambios de privilegios: el límite más importante

**1. ¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**  
Porque la elevación de privilegios (como asignar un rol administrativo a una cuenta de aplicación) permite a un usuario leer, modificar o eliminar información crítica, además de desactivar los mecanismos de registro para borrar sus huellas. Auditar estas modificaciones es esencial para detectar escaladas de privilegios no autorizadas, errores operativos o compromiso de cuentas administrativas.

---

**2. ¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**  
En entornos de producción con datos sensibles programaría instantáneas automáticas cada 15 a 60 minutos (además de ejecutar una captura manual antes y después de cada ventana de mantenimiento); en sistemas de menor criticidad bastaría con una frecuencia diaria. Los factores principales que determinan esta periodicidad son:
* La sensibilidad y criticidad de la información almacenada.
* La cantidad de administradores con permisos para otorgar o revocar roles.
* El tiempo máximo aceptable para detectar una intrusión o cambio indebido (ventana de exposición).
* Los requisitos normativos o de cumplimiento aplicables a la organización.

---

**3. ¿Quién debería poder escribir en `auditoria.instantaneas_privilegios`?**  
Únicamente una cuenta de servicio automatizada y dedicada exclusivamente al proceso de auditoría, con permisos limitados solo a inserción (`insert`) sobre esa colección. Ningún otro usuario incluidos los DBA operativos debería tener permisos de actualización (`update`) o borrado (`remove`/`drop`) sobre ella para garantizar la integridad de la evidencia histórica.

---

**4. Redacta en tres líneas cómo comunicarías esta limitación a Dirección.**  
La edición comunitaria de MongoDB no registra de forma nativa quién modifica los permisos de los usuarios ni el momento exacto del cambio.  

Para mitigar este riesgo, implementamos un control compensatorio basado en instantáneas periódicas que detecta y alerta cualquier alteración de roles entre revisiones.
  
Dado que el control identifica el cambio pero no al autor, recomendamos restringir estrictamente las cuentas administrativas y exigir autorización formal previa para todo ajuste de privilegios.