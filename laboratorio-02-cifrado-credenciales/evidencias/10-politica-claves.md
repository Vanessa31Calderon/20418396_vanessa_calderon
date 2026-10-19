# 17. Actividad 10 — Crear una política mínima de protección de claves

**Objetivo**  
Establecer un conjunto de reglas y lineamientos formales (política mínima) para administrar el ciclo de vida de las claves criptográficas de la organización, además de validar los conceptos teóricos finales sobre credenciales, datos sensibles, comunicaciones y repositorios.

**Comando o procedimiento**  
1. Definición de una política de gestión de claves compuesta por 8 reglas fundamentales (generación, almacenamiento, acceso, rotación, respaldo, revocación, exposición y eliminación).
2. Resolución del cuestionario de **Verificación final** para confirmar la comprensión de los mecanismos criptográficos aplicados en el laboratorio.

---
# Actividad 10 — Crear una política mínima de protección de claves (y Verificación Final)
* **Generación:** Las claves deben generarse utilizando generadores de números pseudoaleatorios criptográficamente seguros, con una longitud mínima conforme a los estándares actuales (ej. AES-256 o RSA de 3072+ bits).

* **Almacenamiento:** Ninguna clave criptográfica debe guardarse en código fuente, scripts SQL ni repositorios Git. Deben almacenarse en un gestor de secretos dedicado (como HashiCorp Vault) o cargarse mediante variables de entorno en tiempo de ejecución.

* **Acceso:** El acceso a las claves estará restringido bajo el principio de mínimo privilegio y separación de funciones, permitiendo únicamente el acceso a las aplicaciones o servicios autorizados.

* **Rotación:** Las claves maestras y de cifrado deben rotarse periódicamente (mínimo una vez al año) o inmediatamente tras la sospecha de cualquier fuga o vulneración de seguridad.

* **Respaldo:** Los respaldos de las claves deben almacenarse en una ubicación secundaria totalmente independiente, cifrados y protegidos físicamente o mediante custodia segura.

* **Revocación:** Ante un incidente de seguridad, compromiso de credenciales o salida de personal clave, se debe ejecutar un procedimiento de revocación inmediata para deshabilitar las claves afectadas.

* **Exposición accidental:** Si una clave es expuesta por error en un repositorio o registro (log), debe considerarse comprometida de inmediato; se debe proceder a su revocación, rotación y re-cifrado del contenido afectado, no bastando con solo borrar el archivo expuesto.

* **Eliminación:** Cuando una clave cumpla su ciclo de vida y no sea requerida para descifrar datos históricos, debe destruirse de forma segura mediante métodos de borrado criptográfico irrecuperable.

# 18. Verificación final

## Credenciales
**¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves?**
Debe protegerse mediante un mecanismo de derivación de claves. El cifrado bidireccional no es apropiado porque permite recuperar la contraseña original si se obtiene la clave.
## Datos sensibles
**¿Qué diferencia existe entre enmascaramiento, seudónimización y cifrado?**
* Enmascaramiento: Oculta parcialmente los datos visualmente (ej. **** 1234) para evitar su lectura, sin posibilidad de revertirlo mediante algoritmos.

* Seudónimización: Reemplaza identificadores por tokens o alias manteniéndolos separados de la identidad real (requiere una tabla/mapeo auxiliar para reidentificar).

* Cifrado: Transforma los datos mediante un algoritmo y una clave matemática (pgp_sym_encrypt()), permitiendo recuperar el dato original exacto mediante su clave de descifrado.
# Comunicaciones
**¿Qué problema resuelve TLS?**
Protege la información en tránsito entre el cliente y el servidor, cifrando el canal para evitar que terceros intercepten, lean o modifiquen consultas, credenciales y datos sensibles en la red.
# Claves
**¿Dónde debería almacenarse una clave criptográfica en un entorno real?**
En un gestor de secretos (Vault, AWS Secrets Manager, Key Vault) o inyectada dinámicamente como variable de entorno protegida en el servidor de aplicaciones, nunca en archivos de código SQL ni en la base de datos.
# Repositorio
**¿Es correcto subir una contraseña o clave real a GitLab aunque el repositorio sea privado?**
No porque un repositorio privado reduce la exposición pública, pero no convierte a un sistema de control de versiones en un almacenamiento seguro para secretos. La clave o contraseña permanece en el historial de Git, accesible para desarrolladores, colaboradores o cualquier usuario con permisos sobre el repositorio.

---

**Resultado obtenido**  

**Política Mínima de Protección de Claves:**
- **Generación:** Las claves deben generarse utilizando generadores de números pseudoaleatorios criptográficamente seguros, con una longitud mínima conforme a los estándares actuales (ej. **AES-256** o **RSA** de 3072+ bits).
- **Almacenamiento:** Ninguna clave criptográfica debe guardarse en código fuente, scripts **SQL** ni repositorios **Git**. Deben almacenarse en un gestor de secretos dedicado (como **HashiCorp Vault**) o cargarse mediante variables de entorno en tiempo de ejecución.
- **Acceso:** El acceso a las claves estará restringido bajo el principio de mínimo privilegio y separación de funciones, permitiendo únicamente el acceso a las aplicaciones o servicios autorizados.
- **Rotación:** Las claves maestras y de cifrado deben rotarse periódicamente (mínimo una vez al año) o inmediatamente tras la sospecha de cualquier fuga o vulneración de seguridad.
- **Respaldo:** Los respaldos de las claves deben almacenarse en una ubicación secundaria totalmente independiente, cifrados y protegidos físicamente o mediante custodia segura.
- **Revocación:** Ante un incidente de seguridad, compromiso de credenciales o salida de personal clave, se debe ejecutar un procedimiento de revocación inmediata para deshabilitar las claves afectadas.
- **Exposición accidental:** Si una clave es expuesta por error en un repositorio o registro (**log**), debe considerarse comprometida de inmediato; se debe proceder a su revocación, rotación y re-cifrado del contenido afectado, no bastando con solo borrar el archivo expuesto.
- **Eliminación:** Cuando una clave cumpla su ciclo de vida y no sea requerida para descifrar datos históricos, debe destruirse de forma segura mediante métodos de borrado criptográfico irrecuperable.

**Verificación Final:**
- **Credenciales:** ¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves? Debe protegerse mediante un mecanismo de derivación de claves. El cifrado bidireccional no es apropiado porque permite recuperar la contraseña original si se obtiene la clave.
- **Datos sensibles:** ¿Qué diferencia existe entre enmascaramiento, seudonimización y cifrado? 
  - **Enmascaramiento:** Oculta parcialmente los datos visualmente (ej. **** 1234) para evitar su lectura, sin revertirlo.
  - **Seudonimización:** Reemplaza identificadores por tokens manteniéndolos separados de la identidad real (requiere mapeo).
  - **Cifrado:** Transforma los datos mediante un algoritmo y llave matemática (**pgp_sym_encrypt()**), permitiendo recuperar el dato original.
- **Comunicaciones:** ¿Qué problema resuelve **TLS**? Protege la información en tránsito entre el cliente y el servidor, cifrando el canal para evitar intercepciones (**Man-in-the-Middle**).
- **Claves:** ¿Dónde debería almacenarse una clave criptográfica? En un gestor de secretos o inyectada dinámicamente como variable de entorno, nunca en **SQL** ni en la base de datos.
- **Repositorio:** ¿Es correcto subir una clave a **GitLab** si el repositorio es privado? No, un repositorio privado reduce exposición pero no es un almacén de secretos; el historial de **Git** sigue manteniendo la clave expuesta para cualquier colaborador.

**Análisis**  
El ciclo de vida de una clave (desde su creación hasta su destrucción) es tan crítico como el algoritmo matemático que utiliza. Las respuestas de la verificación final y las reglas de la política convergen en un mismo principio: la criptografía pierde todo su valor si los secretos que la sostienen (**keys**, **salts**, **passwords**) quedan al alcance de usuarios no autorizados, repositorios de código o configuraciones inseguras de red.

**Conclusión**  
La seguridad criptográfica es un proceso integral. Establecer una política estricta de gestión de claves y comprender la diferencia teórica entre protección en reposo, protección en tránsito y derivación de credenciales, garantiza que la organización no solo cumpla con aplicar funciones técnicas (como **pgcrypto**), sino que las implemente bajo una arquitectura verdaderamente segura y resiliente.
