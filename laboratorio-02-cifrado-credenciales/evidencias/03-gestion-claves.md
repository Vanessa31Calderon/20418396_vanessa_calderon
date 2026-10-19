# 9. Actividad 3 — El problema de la gestión de claves

**Objetivo**  
Comprender el riesgo crítico que representa incluir claves criptográficas directamente en el código fuente o scripts SQL (**hardcoded secrets**) y por qué los repositorios de control de versiones no son seguros para almacenar secretos.

**Comando o procedimiento**  
1. Creación de un archivo temporal de demostración (**sql/ejemplo-mala-practica.sql**).
2. Inserción de una consulta SQL que incluye la función **pgp_sym_decrypt()** con la clave secreta escrita directamente en el código.
3. Análisis del impacto de seguridad que tendría subir este archivo a un sistema de control de versiones como **Git** o **GitLab**.

--- 

## 9.1 Identificar una mala práctica
**¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?**   Cualquiera con acceso al repositorio Git (o al historial de commits) podría ver la clave secreta en texto plano. Con esa clave, un atacante o tercero podría descifrar y robar toda la información confidencial de la base de datos, dejando inservible el cifrado. Además, como en Git se guarda el historial, la clave seguiría expuesta aunque se borre o se edites el archivo después.   

---

**Resultado obtenido**  
Se evidenció que la clave simétrica utilizada para el descifrado queda plasmada directamente en el contenido del archivo. Si este archivo se comparte o se guarda en la nube, cualquier persona o sistema que lo lea obtendrá la llave criptográfica sin ninguna restricción.

**Análisis**  
- **Exposición en el repositorio:** Si esta clave fuera utilizada realmente por una organización y el archivo se publicara, cualquiera con acceso al repositorio **Git** (o al historial de **commits**) podría ver la clave secreta en texto plano.
- **Compromiso total del cifrado:** Con esa clave expuesta, un atacante o tercero podría descifrar y robar toda la información confidencial de la base de datos, dejando inservible cualquier mecanismo de cifrado previo.
- **Persistencia del riesgo:** Como **Git** guarda el historial completo de cambios del proyecto, la clave seguiría expuesta de forma permanente en las versiones anteriores, incluso si el administrador se da cuenta del error y borra o edita el archivo en un **commit** futuro.

**Conclusión**  
Las claves criptográficas, contraseñas y tokens nunca deben escribirse dentro del código fuente ni enviarse a repositorios de versiones (ni siquiera si son repositorios privados). Para proteger la información, es obligatorio inyectar las claves mediante variables de entorno o administrarlas mediante plataformas externas especializadas en la gestión de secretos.