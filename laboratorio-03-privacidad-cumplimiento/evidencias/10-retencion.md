# 15. Actividad 9 — Derecho de oposición

**¿Es necesario eliminar inmediatamente todos sus datos de la base?**  
No. El derecho de oposición detiene el tratamiento de datos para una finalidad específica, pero no implica borrar al cliente si sus datos aún son necesarios para cumplir con el servicio contratado o con obligaciones legales.

**1. Qué información podría necesitar mantenerse**  
Toda la información operativa esencial (nombre, correo para soporte, RFC, datos de facturación e historial de transacciones) debe mantenerse activa para garantizar la relación comercial y cumplir con las regulaciones aplicables.

**2. Qué información podría dejar de utilizarse para determinada finalidad**  
Los datos del cliente (como el correo electrónico, edad, ciudad o historial de compras) deben quedar bloqueados o excluidos exclusivamente de los procesos relacionados con la finalidad rechazada.

**3. Qué mecanismos técnicos podrían separar finalidades**  
*   **Listas de exclusión:** Añadir una columna de control en la tabla.
*   **Vistas filtradas:** Construir vistas específicas para las áreas secundarias que excluyan automáticamente a quienes ejercieron su derecho.
*   **Segregación de roles:** Configurar permisos para que el área de marketing solo pueda realizar consultas a través de las vistas filtradas, bloqueando su acceso directo a la tabla base.

**4. Por qué la decisión final no debe ser tomada únicamente por el DBA**  
El DBA administra la tecnología, pero no tiene la función de interpretar leyes, normativas ni contratos. Determinar si una solicitud de oposición procede jurídicamente (ya que el cliente no puede oponerse a finalidades obligatorias por ley, como el registro contable) es responsabilidad del área legal, de cumplimiento o del Data Owner. El DBA se encarga de implementar técnicamente la decisión que e stas áreas aprueben.

# 16. Actividad 10 — Política de retención

**Pregunta 1: ¿Es compatible con el principio de minimización?**  
No. El principio de minimización y la limitación del plazo de conservación establecen que los datos personales deben eliminarse o anonimizarse una vez que dejan de ser necesarios para la finalidad que justificó su recolección. Conservar datos "por si acaso" viola directamente esta premisa.

**Pregunta 2: ¿Qué riesgos genera conservar información innecesaria?**  
*   **Mayor impacto ante brechas de seguridad:** Un volumen mayor de datos históricos incrementa el daño y la responsabilidad técnica y legal si ocurre una extracción no autorizada.
*   **Incumplimiento normativo:** Expone a la organización a sanciones por parte de autoridades regulatorias al violar los tiempos legales de conservación.
*   **Sobrecarga operativa:** Aumenta los costos de almacenamiento, ralentiza respaldos, degrada el rendimiento de consultas y complica la atención de solicitudes de Derechos ARCO.

**Pregunta 3: ¿Qué debería determinar la organización antes de establecer un periodo de retención?**  
Debe identificar la duración del ciclo de vida de la relación comercial, las obligaciones legales aplicables por sector (como los 5 años requeridos por el Código Fiscal de la Federación en México para datos de facturación), y los plazos de prescripción para posibles defensas legales o auditorías.

**Pregunta 4: ¿Qué información debería documentarse para justificar el periodo seleccionado?**  
*   La base jurídica, obligación legal o necesidad de negocio que fundamenta la retención.
*   El evento que marca el inicio y fin del periodo (ej. "terminación del contrato + 5 años").
*   El mecanismo de disposición final aplicado al vencer el plazo (borrado criptográfico, eliminación física o anonimización irreversible).