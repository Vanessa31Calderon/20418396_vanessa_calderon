**1. La bitácora registra el usuario app_ventas en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?**
No prueba que la aplicación legítima haya intentado entrar.

Lo que prueba realmente es que un cliente desde la dirección IP 127.0.0.1 envió una solicitud de conexión declarando llamarse app_ventas. Un atacante o script malicioso puede colocar arbitrariamente cualquier nombre de usuario válido o adivinado en la cadena de conexión de psql. Dado que la autenticación falló, no se pudo validar la legitimidad ni el conocimiento de la clave real por parte de quien hizo la petición.

**2. ¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?**
Información adicional: En la línea con nivel DETAIL, el servidor escribe:

    Role "usuario_inexistente" does not exist.

**¿Por qué en el log y no hacia el cliente?**
Por Prevención de Enumeración de Usuarios (Seguridad por Diseño). Si el servidor le respondiera al cliente cliente remoto "El usuario no existe", un atacante sabría exactamente qué usuarios sí existen y cuáles no para afinar su ataque. Hacia la red, PostgreSQL siempre responde de manera genérica FATAL: password authentication failed for user "X", evitando revelar la existencia del rol. La información detallada se reserva únicamente para el administrador del motor dentro de la bitácora física.

**3. ¿Por qué app=[unknown] en el intento fallido, pero app=app-ventas-web en la desconexión?**
Porque la variable de aplicación (application_name) se transmite como parte de los parámetros de configuración de la sesión negociados durante y después del apretón de manos de autenticación.

En los intentos fallidos (líneas 15 y 18), la conexión fue interrumpida y destruida en la etapa inicial de verificación de contraseña, por lo que el proceso backend nunca llegó a procesar la inicialización de variables de entorno del cliente (app=[unknown]).

En la sesión exitosa (línea 22 y 23), tras autorizar la clave, el motor procesó la variable enviada por el cliente (application_name=app-ventas-web), asociándola al PID 105 para el resto de la vida de la sesión.

**4. ¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.**
Patrón de sospecha: Una ráfaga continua de líneas con severidad FATAL indicando password authentication failed, compartiendo el mismo PID o provenientes de la misma dirección IP (client=X), con marcas de tiempo concentradas en intervalos de pocos segundos o milisegundos, variando secuencialmente el usuario o repitiendo el mismo rol con claves distintas.
