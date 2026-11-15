# 10. Actividad 4 — Reducir el volumen con un filtro
**1. ¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?**  
Lo que se pierde es el rastro de las consultas de lectura y otros comandos administrativos, por lo que ya no es posible saber si alguien revisó o extrajo información confidencial sin modificarla. A cambio, se gana mucho espacio y rendimiento: al evitar que las lecturas diarias llenen el registro, la base de datos trabaja más rápido y la evidencia de los cambios reales en los datos se conserva por mucho más tiempo antes de borrarse.

---

**2. ¿Qué filtro usarías si solo interesaran operaciones sobre la colección clientes?**  
Usaría un filtro apuntando directamente al nombre completo de esa colección dentro de la base de datos. De esa manera, el perfilador ignoraría lo que ocurra en otras colecciones y guardaría únicamente los movimientos realizados sobre los clientes.