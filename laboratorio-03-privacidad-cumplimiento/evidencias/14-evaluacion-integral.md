# Actividad 14 — Evaluación integral de riesgos de privacidad

<table>
  <thead>
    <tr>
      <th>#</th>
      <th>Problema</th>
      <th>Principio afectado</th>
      <th>Riesgo</th>
      <th>Control propuesto</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>1</b></td>
      <td>Acceso directo del área de analítica a la tabla <b>clientes</b></td>
      <td>Minimización de datos / Privacidad por defecto</td>
      <td>Exposición masiva de datos personales identificables (<b>PII</b>) a personal que solo requiere métricas globales.</td>
      <td>Crear vistas agregadas o anonimizadas (<b>v_analitica_clientes</b>) y otorgar permisos exclusivamente sobre la vista.</td>
    </tr>
    <tr>
      <td><b>2</b></td>
      <td>Inclusión de datos sensibles (<b>RFC</b>, teléfono, dirección) en consultas de analítica</td>
      <td>Proporcionalidad / Limitación de finalidad</td>
      <td>Extracción o filtración de datos fiscales y de contacto directos sin justificación para reportes mensuales.</td>
      <td>Excluir columnas identificables del alcance de los roles de inteligencia de negocios.</td>
    </tr>
    <tr>
      <td><b>3</b></td>
      <td>Conservación de información de clientes durante 12 años</td>
      <td>Retención / Limitación del plazo de conservación</td>
      <td>Incumplimiento regulatorio y mayor volumen de datos expuestos ante una brecha de seguridad.</td>
      <td>Establecer un proceso de bloqueo y posterior eliminación o anonimización para registros obsoletos.</td>
    </tr>
    <tr>
      <td><b>4</b></td>
      <td>Ausencia de una política documentada de retención</td>
      <td>Gobierno de datos / Responsabilidad proactiva (Accountability)</td>
      <td>Imposibilidad de fundamentar legal o técnicamente el ciclo de vida del dato ante auditorías.</td>
      <td>Formalizar la directriz de retención considerando plazos legales (ej. 5 años para datos fiscales) y contractuales.</td>
    </tr>
    <tr>
      <td><b>5</b></td>
      <td>Entrega de copias completas de la base de datos a desarrolladores</td>
      <td>Confidencialidad / Minimización de datos</td>
      <td>Fuga de información real de 50,000 clientes desde entornos de pruebas o equipos locales no protegidos.</td>
      <td>Prohibir el uso de copias productivas en desarrollo; implementar un pipeline de enmascaramiento o datos sintéticos.</td>
    </tr>
    <tr>
      <td><b>6</b></td>
      <td>Uso de información real de producción en entornos de prueba</td>
      <td>Seguridad del tratamiento / Privacidad por diseño</td>
      <td>Exposición innecesaria de en ambientes con controles de acceso relajados y sin auditoría.</td>
      <td>Generar scripts de sembrado de datos falsos para pruebas de software.</td>
    </tr>
    <tr>
      <td><b>7</b></td>
      <td>Uso de correos electrónicos para marketing sin consentimiento informado</td>
      <td>Limitación de finalidad / Consentimiento</td>
      <td>Sanciones por envío de publicidad no solicitada y violación al Aviso de Privacidad.</td>
      <td>Añadir un campo de control y filtrar las listas de difusión para incluir solo a quienes autorizaron dicho uso.</td>
    </tr>
    <tr>
      <td><b>8</b></td>
      <td>Falta de documentación sobre la finalidad de cada dato</td>
      <td>Transparencia / Gobierno de datos</td>
      <td>Tratamiento arbitrario de columnas por distintos departamentos sin control ni sustento legal.</td>
      <td>Publicar e implementar un Catálogo de Datos y una Matriz de Gobierno de Datos.</td>
    </tr>
    <tr>
      <td><b>9</b></td>
      <td>Ausencia de control de acceso basado en roles (<b>RBAC</b>) acotado</td>
      <td>Mínimo privilegio / Control de acceso</td>
      <td>Empleados operando con permisos excesivos para leer o exportar la tabla completa de clientes.</td>
      <td>Revocar privilegios globales y estructurar permisos explícitos por función de puesto.</td>
    </tr>
    <tr>
      <td><b>10</b></td>
      <td>Falta de registros de auditoría sobre lecturas y exportaciones de datos</td>
      <td>Trazabilidad / Responsabilidad proactiva</td>
      <td>Incapacidad de detectar, investigar o deslindar responsabilidades ante exfiltraciones internas de información.</td>
      <td>Habilitar la extensión <b>pgAudit</b> para auditar consultas y accesos a tablas con datos personales.</td>
    </tr>
  </tbody>
</table>