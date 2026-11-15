# 8. Actividad 2 — El incidente sin perfilado
**1. ¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?** 
No se puede demostrar qué dato cambió ni qué modificación exacta se realizó, porque el perfilador estaba apagado y la bitácora general del servidor no guarda el detalle de los movimientos sobre los registros. Lo único que sí es posible comprobar es quién se conectó a esa hora, ya que en la bitácora quedó registrado que la aplicación app-ventas-web inició sesión y se autenticó correctamente en ese momento.

---

**2. ¿Por qué mongosh abre varias conexiones (conn8, conn9, …) para una sola instrucción? ¿Cuál es la que se autentica?**
Esto ocurre porque la consola abre primero una conexión rápida de reconocimiento para revisar el estado y los datos básicos del servidor sin iniciar sesión. Inmediatamente después, abre una segunda conexión aparte, que en este caso es conn9, la cual sí envía las credenciales para autenticarse y ejecutar la instrucción.