# 10. Actividad 4 — Protección de datos durante la comunicación

**Objetivo**  
Comprender los riesgos de transmitir información sin cifrar a través de la red y verificar mediante consultas al sistema el estado actual de las conexiones **TLS** en **PostgreSQL** para garantizar la protección de los datos en tránsito.

**Comando o procedimiento**  
1. Análisis del comportamiento del tráfico de red entre el cliente y el servidor de base de datos cuando no se aplican protocolos de cifrado.
2. Ejecución de consultas de configuración del servidor (**SHOW ssl;**, **SHOW ssl_min_protocol_version;**, **SHOW port;**).
3. Consulta a la vista del sistema **pg_stat_ssl** filtrando por el proceso actual (**pg_backend_pid()**) para extraer los campos **ssl**, **version** y **cipher**.

---

**¿Qué sucede con la información mientras viaja entre el cliente y PostgreSQL?**   Si la conexión no usa cifrado (como TLS), la información viaja en texto plano por la red. Esto significa que cualquier persona con acceso a la red o capacidad para interceptar el tráfico, podría leer la consulta, los datos de los clientes y las credenciales mientras se transmiten. 

# 11. Actividad 5 — Verificar el estado de TLS en PostgreSQL
## 11.1 Verificar la conexión actual
### Preguntas
**1. ¿La conexión actual utiliza TLS?**
No, el campo ssl devuelve false (f), lo que significa que la conexión actual no está cifrada con TLS.   

**2. ¿Qué versión de TLS se está utilizando?**
Ninguna, en la columna version aparece [null] porque la conexión es en texto plano sin SSL/TLS.  

**3. ¿Qué algoritmo de cifrado aparece?**
Ninguno, en la columna cipher aparece [null].   

**4. ¿Qué diferencia existe entre una conexión protegida con TLS y una conexión sin TLS?**
En una conexión protegida con TLS, todo el tráfico viaja cifrado a través de la red, impidiendo que terceros lean la información. En una conexión sin TLS, las consultas, contraseñas y datos viajan en texto plano, por lo que cualquiera que intercepte la red puede ver la información. 

---

**Resultado obtenido**  
- Al verificar la vista de estado de la conexión, el campo **ssl** devolvió un valor booleano **false** (f).
- En la columna **version**, el resultado obtenido fue **[null]**.
- En la columna **cipher** (algoritmo de cifrado), el resultado también fue **[null]**.

**Análisis**  
- **Riesgo en tránsito:** Si la conexión no usa cifrado (como **TLS**), la información viaja en texto plano por la red. Esto significa que cualquier persona con acceso a la red o capacidad para interceptar el tráfico (ataque Man-in-the-Middle) podría leer las consultas, los datos sensibles de los clientes y las credenciales.
- **Estado de la conexión actual:** Los resultados nulos y el valor **false** en el campo **ssl** comprueban que la sesión activa no está utilizando **TLS**, por lo tanto, la conexión es completamente en texto plano.
- **TLS vs Texto Plano:** La diferencia fundamental radica en que con **TLS** todo el tráfico viaja cifrado e incomprensible para terceros, mientras que sin **TLS**, la red expone toda la interacción con la base de datos de inicio a fin.

**Conclusión**  
Proteger la información en tránsito es una capa de seguridad obligatoria. De nada sirve implementar hashing para contraseñas o cifrado para datos en reposo si las consultas se envían sin cifrar por la red. Es necesario forzar conexiones seguras utilizando parámetros como **sslmode=require** o **verify-full** en entornos reales.

