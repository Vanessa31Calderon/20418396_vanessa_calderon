# Actividad 12 — Privacidad por diseño

**1. ¿Qué problemas identificas?**  
- **Recopilación masiva e injustificada:** Se intentan almacenar datos sin una finalidad clara ("por si acaso").  
- **Captura de datos financieros y sensibles:** Campos como salario, estado_civil u ocupacion representan un alto riesgo de privacidad innecesario para un registro estándar.  
- **Redundancia de información:** Guardar simultáneamente edad y fecha_nacimiento genera duplicidad de datos de un atributo derivado que cambia con el tiempo.  
- **Mayor superficie de exposición:** A mayor volumen de datos personales, mayor es el impacto y la responsabilidad legal ante una brecha de seguridad.  

**2. ¿Qué principio de privacidad se está ignorando?**  
Se ignoran principalmente los principios de **minimización de datos** y **proporcionalidad** (recolectar únicamente lo estrictamente necesario), además de la **limitación de finalidad** y la **privacidad por defecto**.  

**3. ¿Qué preguntas realizarías antes de aprobar el diseño?**  
- ¿Cuál es la finalidad primaria y específica del sistema?  
- ¿Para qué proceso de negocio indispensable se requiere capturar el salario, el estado_civil o la ocupacion?  
- ¿Existe base jurídica o consentimiento explícito en el **Aviso de Privacidad** para tratar datos patrimoniales?  
- ¿Por qué se requieren tanto la fecha_nacimiento como la edad al mismo tiempo?  
- ¿Todos los usuarios requerirán facturación obligatoria como para solicitar el rfc desde el registro inicial?  

**4. ¿Qué datos eliminarías?**  
- **salario:** Salvo que el sistema sea una plataforma crediticia o bancaria.  
- **estado_civil:** Carece de relevancia para operaciones comerciales estándar.  
- **ocupacion:** Innecesario para el registro operativo de clientes.  
- **edad:** Debe eliminarse como columna fija para evitar inconsistencias con la fecha de nacimiento.  

**5. ¿Qué datos requerirían una justificación adicional?**  
- **fecha_nacimiento:** Si solo se busca validar la mayoría de edad, debe reemplazarse por un campo booleano.  
- **rfc:** Solo debe solicitarse si el cliente requiere la emisión de un comprobante fiscal.  
- **direccion** y **codigo_postal:** Solo justificables si la aplicación realiza entregas físicas o logística de envíos.  

**6. ¿Cómo aplicarías privacidad por defecto?**  
- **Campos opcionales por defecto:** Hacer que la captura de datos no esenciales sea estrictamente opcional.  
- **Esquema acotado inicial:** Crear la tabla únicamente con los atributos mínimos indispensables.  
- **Vistas y permisos limitados:** Restringir el acceso directo a la tabla mediante vistas y roles RBAC acotados.  
- **Consentimiento explícito:** Desactivar por defecto cualquier casilla para el envío de promociones u otros usos secundarios.