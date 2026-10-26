# Informe

### 1. ¿Cuál era la principal superficie de ataque?
La principal superficie de ataque la constituía la combinación de interfaces de red abiertas escuchando en todas las direcciones IP con el puerto por defecto 5432, junto con reglas de autenticación permisivas en el archivo de control de acceso que autorizaban conexiones desde cualquier red externa sin exigencia de cifrado en tránsito.

### 2. ¿Qué configuración representaba el mayor riesgo?
La existencia de reglas en el archivo pg_hba.conf que autorizaban el rango universal 0.0.0.0/0 combinadas con métodos de autenticación débiles como md5 o trust, permitiendo intentos de conexión no autorizada desde cualquier ubicación.

### 3. ¿Qué cambio produjo la mayor reducción de exposición?
La reconfiguración estricta del archivo pg_hba.conf para eliminar el acceso global universal, acotando el tráfico únicamente a la subred interna autorizada 10.10.10.0/24 y a la interfaz local, en combinación con la restricción del parámetro listen_addresses.

### 4. ¿Qué diferencia existe entre firewall y pg_hba.conf?
El firewall opera en las capas 3 y 4 del modelo OSI evaluando direcciones IP y puertos de origen o destino antes de que los paquetes lleguen al servicio. El archivo pg_hba.conf actúa en la capa 7 como control de acceso interno del motor PostgreSQL, evaluando la base de datos solicitada, el usuario y el método de autenticación una vez que la conexión de red fue aceptada por el servidor.

### 5. ¿Qué diferencia existe entre autenticación y autorización?
La autenticación es el proceso de verificar la identidad declarada por un usuario mediante credenciales y algoritmos de validación como SCRAM-SHA-256. La autorización es el proceso posterior que determina qué permisos y acciones específicas tiene permitido ejecutar ese usuario ya verificado sobre las tablas y objetos del sistema.

### 6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?
Una cuenta de aplicación no debe poseer privilegios de superusuario porque viola el principio de mínimo privilegio. Si la aplicación sufre una vulnerabilidad como inyección SQL, un atacante obtendría control absoluto sobre la base de datos, pudiendo modificar o destruir información de cualquier esquema, acceder a datos de otros usuarios o ejecutar comandos en el sistema operativo subyacente.

### 7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?
Cambiar el puerto por defecto 5432 únicamente brinda seguridad por oscuridad. Un escaneo de puertos automatizado descubre el nuevo puerto en pocos segundos, dejando el servidor exactamente igual de expuesto si no se configuran reglas de autenticación estrictas, cifrado en tránsito y control de accesos.

### 8. ¿Por qué listen_addresses con valor asterisco puede ser innecesario?
Configurar listen_addresses en valor asterisco es innecesario cuando los servidores de aplicaciones y administradores residen en segmentos de red conocidos. Escuchar en todas las interfaces expone innecesariamente el motor a redes públicas o zonas no confiables sin justificación operativa.

### 9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?
El sistema operativo constituye la base de la seguridad del motor al proporcionar el aislamiento de procesos, el control de acceso al sistema de archivos donde se almacenan las tablas y certificados, la gestión de reglas del firewall local, los parches de seguridad del kernel y la administración del usuario ejecutor del servicio.

### 10. ¿Qué controles deberían revisarse periódicamente?
Se deben revisar periódicamente las reglas de autenticación en pg_hba.conf, la matriz de roles y privilegios otorgados a los usuarios, la validez de los certificados TLS, los registros de eventos de conexiones y errores, así como la depuración de cuentas de usuario inactivas.

# Reflexión

### Cambio Prioritario
Si asumiera la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción, el primer cambio que realizaría sería la auditoría y ajuste inmediato de las reglas de acceso en el archivo pg_hba.conf para eliminar reglas permisivas universales como 0.0.0.0/0 y reemplazar métodos de autenticación débiles por scram-sha-256.

### Justificación Técnica
* **Riesgo y Exposición:** Un perímetro con reglas abiertas o métodos de autenticación inseguros expone la base de datos a accesos no autorizados y extracción masiva de datos de forma inmediata. Corregir el archivo pg_hba.conf elimina el vector de ataque externo más crítico.
* **Impacto y Disponibilidad:** Este ajuste se aplica ejecutando una recarga de configuración en caliente mediante la función pg_reload_conf. No requiere reiniciar el servicio de base de datos, garantizando una disponibilidad del cien por cien y cero tiempo de inactividad para las aplicaciones.
* **Continuidad del Servicio:** Al mantener explícitamente autorizadas las direcciones IP de los servidores de aplicación legítimos, la operación del negocio continúa sin interrupciones mientras se bloquean de inmediato los accesos no autorizados.
* **Red y Autenticación:** Garantiza que solo los clientes provenientes de segmentos de red autorizados y autenticados con algoritmos seguros puedan interactuar con la base de datos.
* **Privilegios:** Bloquear los accesos externos no autorizados es el paso lógico indispensable antes de modificar la estructura de roles o permisos RBAC internos, asegurando que ningún atacante pueda aprovechar credenciales expuestas durante la fase de transición.