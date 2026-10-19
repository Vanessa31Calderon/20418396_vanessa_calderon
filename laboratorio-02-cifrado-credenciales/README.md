# Laboratorio 02 — Cifrado y credencialess
## 1. Introducción
La protección de bases de datos requiere mecanismos de seguridad integral más allá del control de acceso tradicional. En este laboratorio se implementaron controles criptográficos en PostgreSQL 16 para proteger credenciales mediante algoritmos de derivación (hashing), asegurar datos sensibles en reposo mediante cifrado simétrico PGP, verificar la protección de datos en tránsito utilizando TLS y establecer buenas prácticas para la gestión segura de claves y secretos.

## 2. Protección de credenciales
Almacenar contraseñas en texto claro representa una vulnerabilidad crítica ante filtraciones. 
- **Texto claro:** Información legible directamente sin protección.
- **Cifrado:** Mecanismo bidireccional que permite revertir el dato usando una clave (no apropiado para contraseñas).
- **Hash / Derivación de claves:** Transformación unidireccional no reversible que utiliza sal (*salt*) aleatoria para evitar ataques de tablas precalculadas (Rainbow Tables) y proteger el secreto original.

## 3. Protección de datos sensibles
Se protegió el campo RFC de la tabla **clientes** mediante cifrado simétrico utilizando la extensión **pgcrypto** con las funciones **pgp_sym_encrypt() y pgp_sym_decrypt()**. Este mecanismo garantiza que solo los usuarios autorizados que posean la clave criptográfica puedan recuperar la información original en texto claro.

## 4. TLS (Transport Layer Security)
TLS resuelve el problema de la intercepción de datos en tránsito (ataques Man-in-the-Middle). Se verificó en PostgreSQL el estado de TLS mediante las vistas del sistema **SHOW ssl** y **pg_stat_ssl**, confirmando si las conexiones cifran la comunicación y qué algoritmos/versiones utilizan.

## 5. Gestión de claves
Las claves criptográficas nunca deben almacenarse en scripts SQL, archivos de configuración o repositorios de código como GitLab. Exponer una clave en el código anula de inmediato cualquier control criptográfico. En entornos productivos, las claves deben ser administradas externamente mediante gestores de secretos (ej. HashiCorp Vault) o inyectadas dinámicamente mediante variables de entorno.

## 6. Resultados
- Se implementaron tablas seguras de usuarios utilizando hashes con **crypt() y gen_salt('bf')**.
- Se cifraron y descifraron exitosamente campos sensibles en reposo con PGP.
- Se auditó el estado de TLS en PostgreSQL comprobando las variables del servidor y el estado de la sesión activa.
- Se estructuró una política de gestión de claves de 8 principios.

## 7. Problemas encontrados
Durante las pruebas de verificación de TLS se observó que la conexión por defecto en el entorno de pruebas local marcaba **ssl = false** debido a que el servidor no tenía habilitado el soporte SSL en **postgresql.conf**, lo que permitió analizar la diferencia entre una conexión cifrada y una en texto claro.

## 8. Conclusiones
El control de acceso por roles y permisos (RBAC) no sustituye al cifrado ni a la gestión de claves; son capas complementarias de seguridad. La seguridad de los datos depende directamente del eslabón más débil, por lo que almacenar claves en repositorios o contraseñas en texto claro invalida el resto de las defensas.


## 23. Preguntas de reflexión

### 1. ¿Por qué una contraseña no debe almacenarse como texto claro?
Porque cualquier persona con acceso de lectura a la base de datos, respaldos o registros podría ver las credenciales directamente, suplantar la identidad de los usuarios y comprometer otros servicios si las contraseñas son reutilizadas.

### 2. ¿Por qué un hash no es equivalente a un cifrado?
Porque el cifrado es un proceso bidireccional diseñado para recuperar el dato original mediante una clave, mientras que el hash es una función unidireccional e irreversible diseñada para validar información sin permitir recuperar la entrada original.

### 3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?
Porque el cifrado protege los datos en el almacenamiento (reposo), mientras que el control de acceso limita quién tiene permiso de ejecutar consultas u operaciones. Si un usuario sin permisos puede leer la llave o la tabla, el cifrado no impedirá el uso no autorizado.

### 4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?
Porque TLS solo asegura que el canal de comunicación entre cliente y servidor sea confidencial e íntegro, pero no valida qué tablas, vistas o comandos tiene permitido ejecutar el usuario dentro de la base de datos.

### 5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?
La información cifrada con esa clave se volverá permanentemente inaccesible e irrecuperable (pérdida definitiva de datos), ya que los algoritmos criptográficos robustos impiden el descifrado sin la llave matemática.

### 6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?
Cualquier persona con acceso al repositorio podrá descifrar la información confidencial de la base de datos. La clave debe considerarse comprometida de inmediato, revocarse, rotarse y re-cifrarse todo el contenido afectado.

### 7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?
Porque conserva el historial completo de commits, permite el acceso a múltiples desarrolladores/colaboradores y puede ser clonado o filtrado, exponiendo los secretos fuera de las fronteras de control de la infraestructura de producción.

### 8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?
- **Almacenada (reposo):** Protege los archivos en disco, tablas y respaldos contra lectura no autorizada si el servidor o medio de almacenamiento es extraído.
- **Transmisión (tránsito):** Protege los paquetes de red que viajan entre el cliente y el servidor contra intercepción o modificación en la red (TLS).

### 9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?
Porque por más fuerte y matemáticamente seguro que sea un algoritmo criptográfico, si la clave es almacenada de forma insegura, expuesta o mal administrada, los atacantes podrán evadir el algoritmo y acceder directamente a los datos.

### 10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?
Implementaría cifrado de archivos de respaldo antes de su transferencia, almacenamiento en repositorios secundarios fuera de línea o en la nube con políticas de inmutabilidad, control de acceso estricto y pruebas periódicas de restauración cifrada.