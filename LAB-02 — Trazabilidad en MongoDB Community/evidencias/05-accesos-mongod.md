# 11. Actividad 5 — Accesos en la bitácora de mongod
**1. ¿Qué campo distingue un acceso fallido de uno exitoso?**  
Hay tres campos principales que los diferencian en la bitácora: el mensaje del evento (msg), que muestra "Failed to authenticate" cuando falla y "Successfully authenticated" cuando tiene éxito; el código de resultado (result), que marca 0 si el acceso fue correcto y un número distinto de cero (18 o 11) cuando hay error; y el identificador interno del evento (id), que cambia según el resultado.

---

**2. ¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?** 
En el registro interno del servidor sí se detalla la diferencia: cuando la contraseña está mal, el error indica que las claves no coinciden; en cambio, cuando el usuario no existe, indica que no se encontró esa cuenta en la base de datos. Sin embargo, al usuario o programa que intenta conectarse siempre se le devuelve el mismo mensaje genérico (Authentication failed) por seguridad, para evitar que un atacante pueda descubrir qué nombres de usuario sí existen en el sistema y cuáles no.

---

**3. ¿Por qué el nombre de la aplicación del intento fallido es mongosh 2.10.0 y no app-ventas-web?**  
Porque en las cadenas de conexión utilizadas para las pruebas fallidas no se incluyó el parámetro appName con el nombre personalizado de la aplicación. Al no recibir esa etiqueta, el programa cliente con el que se intentó entrar reporta por defecto su propio nombre y versión.