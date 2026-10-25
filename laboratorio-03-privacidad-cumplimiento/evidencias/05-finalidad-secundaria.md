# 8. Actividad 2 — Principio de minimización
**¿Todos los campos son necesarios para atención al cliente?** No. Campos como el RFC o la fecha de alta no intervienen en las consultas operativas de soporte.

**¿Por qué soporte necesitaría conocer el RFC?** No existe una razón funcional; el RFC es un dato netamente fiscal de incumbencia para facturación.

**¿Necesita conocer la edad?** No, la atención al cliente opera sobre la identidad y el canal de contacto, no sobre la edad del titular.

**¿Necesita conocer el código postal?** Únicamente si el soporte está ligado a logística física de entregas; para soporte general de cuenta es innecesario.

**¿Qué principio de privacidad está relacionado?** El Principio de Minimización de Datos.

--- 
# 9. Actividad 3 — Separación por finalidad
**¿Por qué esta información es más apropiada para analítica?** Porque entrega únicamente datos agregados y disociados sin exponer Direct Identifiers (como nombre o RFC), reduciendo a cero el riesgo de reidentificación y cumpliendo la finalidad estadística solicitada.

# 10. Actividad 4 — Control de acceso relacionado con la finalidad
**¿Qué información puede consultar el rol?** Solo la ciudad y el rango de edad agregados a través de la vista v_analitica_clientes.

**¿Puede consultar directamente la tabla clientes?** No, porque no se le otorgó el permiso SELECT sobre la tabla base clientes.

**¿Puede obtener nombre, correo y RFC?** No, estos campos de identificación directa fueron excluidos intencionalmente de la vista.

**¿Qué principio de privacidad estás aplicando?** El de Minimización de datos (al exponer solo lo necesario) y Limitación de la finalidad (al restringir el uso solo para análisis).

**¿Qué principio de seguridad estás aplicando?** El Principio de menor privilegio, otorgando únicamente los permisos indispensables para ejecutar su tarea.

# 11. Actividad 5 — Analizar una finalidad secundaria

**1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?**  
No. El principio de limitación de la finalidad prohíbe usar los datos para un propósito distinto al original sin informar al titular y obtener un nuevo consentimiento.

**2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?**  
- ¿Esta finalidad secundaria está declarada en el aviso de privacidad original?  
- ¿El cliente otorgó su consentimiento explícito para recibir publicidad?  
- ¿Existe un mecanismo técnico fácil para que el usuario pueda darse de baja?

**3. ¿Qué datos serían realmente necesarios?**  
Únicamente el correo electrónico, la ciudad, la edad y el historial de compras. Datos como el RFC, teléfono o código postal son innecesarios.

**4. ¿Necesitaría el área de marketing acceso directo a clientes?**  
No. Darles acceso directo a la tabla base clientes expondría información sensible y financiera que no requieren para su función.

**5. ¿Qué controles técnicos podrían limitar la información entregada?**  
- Creación de vistas específicas que muestren solo los campos de segmentación y contacto.  
- Controles de acceso basados en roles exclusivos para marketing.  
- Un filtro técnico en la base de datos que excluya automáticamente a los usuarios registrados en una lista de exclusión.