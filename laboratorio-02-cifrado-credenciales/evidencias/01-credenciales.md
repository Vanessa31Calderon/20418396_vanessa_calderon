# 7. Actividad 1 — Protección de credenciales

**Objetivo**  
Demostrar los riesgos de almacenar contraseñas en texto claro e implementar un mecanismo seguro de protección de credenciales utilizando funciones de derivación (hashing) no reversibles.

**Comando o procedimiento**  
1. Identificación de riesgos en tablas sin protección.
2. Uso de la extensión **pgcrypto** con las funciones **gen_salt()** y **crypt()** para generar representaciones no reversibles de contraseñas.
3. Ejecución de pruebas de verificación insertando contraseñas correctas e incorrectas para comparar los resultados booleanos.

---

### Pregunta
**¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?**
Podría ver las contraseñas reales de todos los usuarios en texto plano permitiendo que cualquier persona con acceso a la tabla suplante la identidad de los usuarios en el sistema, además de exponer sus credenciales en otras plataformas si el usuario reutiliza esa misma contraseña.

## 7.3 Generar una representación no reversible
### Preguntas 
**1. ¿Son iguales?** No, los dos resultados generados son completamente diferentes.

**2. Si no son iguales, ¿por qué?** Porque cada vez que ejecuta la función se genera un valor aleatorio nuevo llamado salt (sal). Aunque la contraseña de origen sea exactamente la misma ('Password123'), la sal cambia el texto cifrado resultante.   

**3. ¿Qué función cumple gen_salt()?** Genera una cadena aleatoria única (sal) que se mezcla con la contraseña antes de aplicar el algoritmo. Sirve para evitar que dos usuarios con la misma contraseña tengan el mismo hash y para proteger el sistema contra ataques de diccionarios.   

**4. ¿Qué función cumple crypt?** Aplica un algoritmo de hashing seguro a la contraseña combinada con la sal, transformándola en una cadena fija e ilegible no reversible.   

**5. ¿Esto es cifrado reversible?** No, es un hash no reversible (unidireccional). No existe una función para "desencriptar" el resultado y recuperar la contraseña original a partir del hash generado.

## 7.5 Verificar una contraseña
**1. ¿Qué resultado obtuviste con la contraseña correcta?** Se obtiene un valor booleano true (t), lo que confirma que la contraseña ingresada coincide con el hash guardado en la base de datos.   

**2. ¿Qué resultado obtuviste con la contraseña incorrecta?** Se obtiene un valor booleano false (f), lo que indica que la contraseña ingresada no corresponde con el hash guardado.   

**3. ¿Por qué no es necesario recuperar la contraseña original?** Porque para autenticar a un usuario solo se necesita comparar el hash de la contraseña que intenta ingresar contra el hash que está guardado. Si ambos hashes son iguales, se confirma la identidad sin necesidad de conocer o almacenar la contraseña en texto plano.   

**4. ¿Por qué un hash no debe confundirse con cifrado?** Porque el cifrado es bidireccional (se puede desencriptar para obtener el dato original usando una clave), mientras que el hash es unidireccional y no reversible (no existe una clave para regresar del hash a la contraseña original).   

---

**Resultado obtenido**  
- Al analizar una tabla sin protección, se observó que las contraseñas reales son totalmente visibles.
- Al generar el hash de una misma contraseña ('Password123') en múltiples ocasiones, los resultados obtenidos fueron completamente diferentes.
- Durante la verificación, ingresar la contraseña correcta arrojó un valor booleano **true** (t), y al ingresar una contraseña incorrecta se obtuvo **false** (f).

**Análisis**  
- **Riesgo del texto plano:** Obtener acceso de lectura a una tabla en texto claro permite suplantar la identidad de los usuarios y expone las credenciales para ataques en otras plataformas por reutilización.
- **Función de gen_salt():** Genera una cadena aleatoria única (sal) que se mezcla con la contraseña. Su propósito es evitar que dos usuarios con la misma contraseña tengan el mismo hash y proteger contra ataques de diccionario. Por esta razón, cifrar la misma contraseña varias veces produce resultados distintos.
- **Función de crypt():** Aplica un algoritmo de hashing seguro a la contraseña combinada con la sal, transformándola en una cadena fija, ilegible y unidireccional.
- **Hash vs Cifrado:** El resultado de **crypt()** no es un cifrado reversible (que se puede desencriptar con una clave), sino un hash unidireccional. 
- **Lógica de verificación:** No es necesario recuperar la contraseña original. Para autenticar a un usuario, basta con generar el hash de la contraseña ingresada en el inicio de sesión y compararlo con el hash guardado; si coinciden, se confirma la identidad.

**Conclusión**  
Las contraseñas nunca deben almacenarse en texto claro ni utilizar algoritmos de cifrado reversibles. La única estrategia segura para la autenticación en bases de datos es el uso de hashes salados (hashing + salt), lo que garantiza la integridad del sistema incluso si la tabla llega a ser expuesta.