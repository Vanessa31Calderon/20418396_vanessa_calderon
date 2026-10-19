# 8. Actividad 2 — Cifrado de información sensible

**Objetivo**  
Implementar el cifrado simétrico para proteger datos confidenciales almacenados en la base de datos (como el RFC), garantizando que la información solo pueda ser leída en su formato original mediante la autorización y la clave correctas.

**Comando o procedimiento**  
1. Creación de una tabla con una columna de tipo de dato binario para almacenar el texto cifrado.
2. Inserción de registros protegiendo el dato sensible mediante la función **pgp_sym_encrypt()** de la extensión **pgcrypto** junto con una clave secreta.
3. Consulta de los datos para recuperar el texto claro utilizando la función inversa **pgp_sym_decrypt()** y la misma clave.
4. Prueba de recuperación introduciendo una clave incorrecta para observar el comportamiento del sistema.

---

### Preguntas
**1. ¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()?**
crypt() es un hash unidireccional y no se puede revertir para ver el dato original, mientras que pgp_sym_encrypt() es cifrado simétrico y sí te permite recuperar el dato original usando una clave.   

**2. ¿Cuál de los dos mecanismos permite recuperar el dato original?**
pgp_sym_encrypt(), porque al usar su función inversa pgp_sym_decrypt() con la clave correcta puedes volver a ver el texto original.   

**3. ¿Qué ocurre si se utiliza una clave incorrecta?**
La base de datos marca un error de clave incorrecta y no te deja ver ni recuperar el dato.   

**4. ¿Qué problema de seguridad representa colocar la clave directamente en una consulta?** Que la clave queda expuesta en texto plano en el historial de consultas, en los scripts y en los registros del servidor, por lo que cualquiera con acceso al código o a las pantallas podría verla y descifrar la información sensible.

---

**Resultado obtenido**  
- Al consultar directamente la tabla sin funciones de descifrado, el RFC no se muestra, sino que aparece como una cadena binaria completamente ilegible.
- Al ejecutar la consulta utilizando **pgp_sym_decrypt()** junto con la clave correcta, el dato original se recuperó y se mostró en texto claro con éxito.
- Al intentar realizar la consulta con una clave incorrecta, la base de datos marcó un error de descifrado y no permitió visualizar el dato.

**Análisis**  
- **Diferencia entre algoritmos:** **crypt()** genera un hash unidireccional y no se puede revertir para ver el dato original, mientras que **pgp_sym_encrypt()** aplica un cifrado simétrico que sí te permite recuperar el dato original usando una clave.
- **Recuperación de información:** El mecanismo que permite recuperar el dato original es **pgp_sym_encrypt()**, porque al usar su función inversa **pgp_sym_decrypt()** con la clave correcta puedes volver a ver el texto original.
- **Impacto de una clave incorrecta:** La base de datos marca un error indicando que la clave es incorrecta (o que los datos están corruptos) y no te deja ver ni recuperar el RFC.
- **Riesgo de seguridad en las consultas:** Colocar la clave directamente en una consulta representa un riesgo crítico porque la clave queda expuesta en texto plano en el historial de consultas, en los scripts SQL y en los registros del servidor. Por lo tanto, cualquiera con acceso al código, repositorios o pantallas podría verla y descifrar la información sensible.

**Conclusión**  
El cifrado simétrico es la solución correcta para proteger datos en reposo que forzosamente deben ser recuperados después. Sin embargo, su seguridad depende por completo de cómo se guarde la llave; escribirla directamente en los scripts anula la protección, demostrando la importancia de usar administradores de secretos externos.