# 15. Actividad 8 — Analizar un escenario de seguridad

**Objetivo**  
Analizar un escenario de seguridad hipotético para identificar vulnerabilidades críticas (datos en texto claro, malas prácticas de gestión de llaves, conexiones inseguras) y proponer los mecanismos de protección criptográfica adecuados para su mitigación.

**Comando o procedimiento**  
1. Evaluación teórica de la arquitectura, configuración de red y almacenamiento de la base de datos de la empresa ficticia.
2. Identificación de los principales riesgos derivados del mal manejo de contraseñas, datos sensibles, conexiones, llaves y respaldos.
3. Selección de mecanismos de mitigación y evaluación de la eficacia de los controles de acceso (roles y permisos) ante estos fallos.

### Pregunta 1: ¿Cuáles son los principales riesgos?
* Robo masivo de credenciales: Las contraseñas en texto claro permiten que un atacante las utilice directamente en otros servicios.

* Fuga de datos personales: El RFC en texto claro compromete la privacidad de los usuarios y expone a la organización a incumplimientos regulatorios.

* Compromiso total del cifrado: Publicar claves en archivos SQL anula cualquier mecanismo de seguridad cifrado.

* Pérdida/fuga en almacenamiento: Respaldos sin protección exponen toda la base de datos si el archivo de backup es extraído o extraviado.

### Pregunta 2: ¿Qué mecanismo utilizarías para cada elemento?
* Contraseña: Hash unidireccional con sal (crypt() con gen_salt()).

* RFC / Información financiera: Cifrado simétrico (pgp_sym_encrypt() / pgp_sym_decrypt()).

* Conexiones: TLS/SSL con verificación estricta del certificado.

* Claves criptográficas: Variables de entorno o un gestor de secretos (Vault).

* Respaldos: Cifrado de archivos/volúmenes en el almacenamiento.

### Pregunta 3: ¿Cuál de los problemas consideras más crítico y por qué?
La exposición de las claves criptográficas en archivos SQL y las contraseñas en texto claro.
Si las claves están expuestas, cualquier otro mecanismo de cifrado queda inutilizado de inmediato (un atacante podrá descifrar todo sin esfuerzo). Además, las contraseñas en texto claro representan un riesgo severo de compromiso directo para los usuarios.

### Pregunta 4: ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos? Justifica tu respuesta.
No. El control de acceso (usuarios y permisos) sigue el principio de mínimo privilegio, pero no reemplaza la seguridad de los datos en reposo ni en tránsito.

Si un atacante logra comprometer una cuenta con permisos, interceptar el tráfico de red, acceder a un respaldo o leer el repositorio de código, los permisos del motor de base de datos no evitarán que lea la información si esta se encuentra en texto claro o con las llaves expuestas. Los controles de acceso y el cifrado son capas complementarias de seguridad.

--- 

**Resultado obtenido**  
Se completó el análisis determinando que la infraestructura cuenta con deficiencias severas tanto en la protección de **datos en reposo** como de **datos en tránsito**, y se definieron las herramientas criptográficas y arquitectónicas específicas para solucionarlas.

**Análisis**  
- **Principales riesgos:**
  - **Robo masivo de credenciales:** Las contraseñas en **texto claro** permiten que un atacante las utilice directamente en otros servicios.
  - **Fuga de datos personales:** El RFC en texto claro compromete la privacidad de los usuarios y expone a la organización a incumplimientos regulatorios.
  - **Compromiso total del cifrado:** Publicar claves en archivos **SQL** anula cualquier mecanismo de seguridad cifrado.
  - **Pérdida/fuga en almacenamiento:** Respaldos sin protección exponen toda la base de datos si el archivo de **backup** es extraído o extraviado.
- **Mecanismos sugeridos por elemento:**
  - **Contraseña:** Hash unidireccional con sal (**crypt()** con **gen_salt()**).
  - **RFC / Información financiera:** Cifrado simétrico (**pgp_sym_encrypt()** / **pgp_sym_decrypt()**).
  - **Conexiones:** **TLS/SSL** con verificación estricta del certificado.
  - **Claves criptográficas:** Variables de entorno o un gestor de secretos (ej. **Vault**).
  - **Respaldos:** Cifrado de archivos/volúmenes en el almacenamiento.
- **Problema más crítico:** La exposición de las claves criptográficas en archivos **SQL** y las contraseñas en **texto claro**. Si las llaves están expuestas, cualquier otro mecanismo de cifrado queda inutilizado de inmediato (un atacante podrá descifrar todo sin esfuerzo). Además, las contraseñas legibles representan un riesgo severo de compromiso directo para los usuarios.
- **Límites del control de acceso:** Tener correctamente configurados los usuarios y permisos no elimina estos riesgos. El control de acceso (**RBAC**) sigue el principio de mínimo privilegio, pero no reemplaza la seguridad de los datos en reposo ni en tránsito. Si un atacante logra comprometer una cuenta con permisos, interceptar el tráfico de red, acceder a un respaldo o leer el repositorio de código, los permisos del motor de base de datos no evitarán que lea la información si no hay cifrado. 

**Conclusión**  
Los controles de acceso (usuarios y permisos) y el cifrado son capas complementarias de seguridad (**defensa en profundidad**). Configurar correctamente los privilegios dentro del motor de la base de datos es inútil si la información confidencial, las llaves maestras o los canales de comunicación de red quedan expuestos a lectura externa o intercepción.