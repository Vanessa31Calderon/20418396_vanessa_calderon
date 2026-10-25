# Laboratorio 03 — Privacidad y cumplimiento

## 1. Introducción

Una base de datos puede contar con los esquemas de cifrado más avanzados, políticas de contraseñas estrictas y reglas de firewall impenetrables, pero seguir siendo **vulnerable desde la perspectiva de la privacidad y el cumplimiento regulatorio**. La seguridad técnica garantiza la confidencialidad, integridad y disponibilidad contra accesos no autorizados; sin embargo, no valida si la organización tiene el derecho legal o la necesidad operativa de recolectar, procesar o conservar un dato personal.

El presente laboratorio aborda la gestión de privacidad en **PostgreSQL 16** para la empresa **Comercializadora Norte S.A. de C.V.**, alineando las decisiones de diseño e infraestructura con el marco jurídico mexicano de la **Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP)**. Se analiza cómo principios fundamentales como **minimización de datos**, **limitación de finalidad**, **privacidad por diseño** y **control de acceso basado en roles (RBAC)** se traducen en objetos técnicos concretos (tablas acotadas, vistas agregadas, roles sin acceso directo y trazabilidad de auditoría).

## 2. Inventario de Datos

Para evaluar el impacto de la información almacenada en la tabla **clientes**, se realizó un mapeo exhaustivo de cada atributo frente a la naturaleza del dato, su finalidad de uso, el nivel de acceso requerido y su periodo de conservación.

<table>
  <thead>
    <tr>
      <th>Campo</th>
      <th>¿Es dato personal?</th>
      <th>Finalidad principal</th>
      <th>¿Es necesario?</th>
      <th>Nivel de acceso</th>
      <th>Retención</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>id</b></td>
      <td>No</td>
      <td>Clave primaria de control interno</td>
      <td>Sí</td>
      <td>DBA, operaciones, analítica</td>
      <td>Indefinido (mientras exista el registro)</td>
    </tr>
    <tr>
      <td><b>nombre</b></td>
      <td>Sí</td>
      <td>Identificación del cliente para atención y facturación</td>
      <td>Sí</td>
      <td>Atención al cliente y facturación</td>
      <td>Duración de la relación comercial + 5 años</td>
    </tr>
    <tr>
      <td><b>correo</b></td>
      <td>Sí</td>
      <td>Canal de comunicación principal y envío de comprobantes</td>
      <td>Sí</td>
      <td>Atención al cliente y facturación</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td><b>telefono</b></td>
      <td>Sí</td>
      <td>Canal alternativo de soporte y confirmación de servicio</td>
      <td>Sí</td>
      <td>Atención al cliente</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td><b>rfc</b></td>
      <td>Sí (Sensible / Fiscal)</td>
      <td>Emisión de comprobantes fiscales (CFDI)</td>
      <td>Sí (solo para facturación)</td>
      <td>Facturación</td>
      <td>5 años (Código Fiscal de la Federación)</td>
    </tr>
    <tr>
      <td><b>edad</b></td>
      <td>Sí</td>
      <td>Análisis estadístico y segmentación demográfica</td>
      <td>No para soporte; Sí para analítica</td>
      <td>Analítica (solo formato agregado/anonimizado)</td>
      <td>Conservación mientras sea relevante para estudios de mercado</td>
    </tr>
    <tr>
      <td><b>ciudad</b></td>
      <td>Sí</td>
      <td>Logística de entrega y estadísticas de mercado regional</td>
      <td>Sí</td>
      <td>Atención al cliente y analítica</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td><b>codigo_postal</b></td>
      <td>Sí</td>
      <td>Validación de domicilio fiscal y logística de envíos</td>
      <td>Sí</td>
      <td>Facturación, logística y analítica</td>
      <td>Duración de la relación comercial + 5 años</td>
    </tr>
    <tr>
      <td><b>fecha_alta</b></td>
      <td>No (Metadato)</td>
      <td>Auditoría interna, trazabilidad y cálculo de antigüedad</td>
      <td>Sí</td>
      <td>DBA, facturación, analítica</td>
      <td>Indefinido (mientras exista el registro)</td>
    </tr>
  </tbody>
</table>

## 3. Finalidades

El tratamiento de datos dentro de **PostgreSQL 16** responde a dos categorías operativas:

1. **Finalidades Primarias (Indispensables):**
   - **Atención al Cliente / Soporte:** Requiere únicamente identificadores de contacto directos (**nombre**, **correo**, **telefono**) para resolver dudas o dar seguimiento a servicios.
   - **Facturación:** Requiere datos de identificación fiscal (**nombre**, **rfc**, **codigo_postal**) para cumplir con la emisión de comprobantes fiscales digitales (CFDI).

2. **Finalidades Secundarias (Opcionales / Agregadas):**
   - **Analítica de Negocios:** Requiere únicamente patrones de comportamiento, distribución geográfica y rangos demográficos (**ciudad**, **edad** agrupada). No requiere bajo ninguna circunstancia identificadores directos como **nombre**, **correo** o **rfc**.
   - **Marketing / Promociones:** Requiere el consentimiento previo del titular (**opt-in**) para utilizar el **correo** en campañas publicitarias.

---

## 4. Minimización de Datos

El principio de **minimización de datos** dicta que la organización debe limitar la recolección de información a lo estrictamente adecuado, pertinente y necesario para la finalidad informada.

* **Estructura acotada para soporte:** Se rechazó la creación de tablas duplicadas con todos los campos del cliente para el área de soporte. En su lugar, se creó la tabla **clientes_soporte** conteniendo exclusivamente **id**, **nombre**, **correo** y **telefono**.
* **Eliminación de redundancias:** En modelos de desarrollo propuestos, se identificó la coexistencia innecesaria de **edad** y **fecha_nacimiento**. Guardar la edad almacenada genera inconsistencia temporal; se determinó calcularla al vuelo o reemplazar la fecha por un indicador booleano si solo se requiere validar la mayoría de edad.
* **Depuración de datos innecesarios:** Campos como **salario**, **estado_civil** u **ocupacion** fueron eliminados del diseño conceptual al no existir una justificación operativa o legal para su recolección.


## 5. Control de Acceso

Para garantizar la segregación de funciones en **PostgreSQL 16**, se implementó el modelo de **Control de Acceso Basado en Roles (RBAC)** y el principio de **mínimo privilegio**:

1. **Creación de Rol Sin Acceso Directo:**
   Se definió el rol **analista** sin permisos directos de lectura sobre la tabla base **clientes**.
2. **Construcción de Vista Agregada:**
Se encapsularon los datos demográficos transformando la edad en rangos discretos mediante la expresión CASE.
3. **Asignación Mínima de Privilegios:**
Con esta configuración, el rol analista puede consultar estadísticas globales sin posibilidad de acceder a la información de identificación personal.

## 6. Derechos ARCO
Las solicitudes de los titulares bajo la norma **LFPDPPP** generan implicaciones técnicas directas que el **DBA** debe ejecutar y soportar:

- **Acceso:** Búsqueda puntual mediante índices sobre identificadores únicos (**correo** o **id**). Requiere extraer no solo el registro principal, sino informar sobre qué vistas o procesos analíticos consumen sus datos.
- **Rectificación:** Modificación controlada del dato mediante sentencias **UPDATE**. Exige el registro de trazabilidad en tablas de auditoría (**pgAudit**) para respaldar la autorización del cambio.
- **Cancelación:** Inicio del periodo de bloqueo del registro. La eliminación técnica no se limita a un **DELETE** en la tabla **clientes**; requiere la depuración coordinada en respaldos, réplicas de lectura, data warehouses analíticos, exportaciones en archivos y sistemas externos.
- **Oposición:** Desactivación de finalidades secundarias mediante banderas de control o exclusión del cliente en las vistas utilizadas por el área de marketing.


## 7. Política de Retención y Ciclo de Vida

La conservación indefinida de datos bajo el argumento de que "podrían ser útiles en el futuro" representa una infracción directa al principio de minimización y expone a la organización a severos riesgos:

- **Riesgo por brecha de seguridad:** Conservar datos históricos de 12 años incrementa innecesariamente el volumen de **PII** expuesta en caso de exfiltración.
- **Obligación Fiscal:** Datos de facturación (**rfc**, **codigo_postal**) se conservan durante **5 años** conforme al **Código Fiscal de la Federación (CFF)**.
- **Mecanismos de disposición final:** Al vencer el plazo contractual o legal, los datos deben ser objeto de **bloqueo**, seguido de su **eliminación física segura** o su **anonimización irreversible** para fines estadísticos.


## 8. Matriz de Gobierno de Datos

Se definió la distribución de responsabilidades sobre los atributos de la base de datos para separar la custodia técnica de la propiedad del dato:

<table>
  <thead>
    <tr>
      <th>Dato</th>
      <th>Finalidad</th>
      <th>Responsable (Data Owner)</th>
      <th>Usuarios autorizados</th>
      <th>Protección</th>
      <th>Retención</th>
      <th>Acción al finalizar</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>nombre</b></td>
      <td>Identificación del cliente para soporte y facturación</td>
      <td>Gerente de Operaciones</td>
      <td>Atención al cliente, Facturación</td>
      <td>Control de acceso <b>RBAC</b></td>
      <td>Duración de la relación comercial + 5 años</td>
      <td>Eliminación / Anonimización</td>
    </tr>
    <tr>
      <td><b>correo</b></td>
      <td>Canal principal de comunicación y comprobantes</td>
      <td>Gerente de Operaciones / Marketing</td>
      <td>Atención al cliente, Facturación</td>
      <td>Control de acceso <b>RBAC</b> y cifrado en tránsito (<b>TLS</b>)</td>
      <td>Duración de la relación comercial</td>
      <td>Supresión inmediata tras solicitud de cancelación</td>
    </tr>
    <tr>
      <td><b>telefono</b></td>
      <td>Contacto alternativo y soporte postventa</td>
      <td>Gerente de Operaciones</td>
      <td>Atención al cliente</td>
      <td>Control de acceso <b>RBAC</b></td>
      <td>Duración de la relación comercial</td>
      <td>Supresión inmediata</td>
    </tr>
    <tr>
      <td><b>rfc</b></td>
      <td>Emisión de comprobantes fiscales (CFDI)</td>
      <td>Gerente de Finanzas</td>
      <td>Facturación</td>
      <td>Cifrado simétrico en reposo (<b>pgp_sym_encrypt</b>)</td>
      <td>5 años (Código Fiscal de la Federación)</td>
      <td>Bloqueo y posterior destrucción irrecuperable</td>
    </tr>
    <tr>
      <td><b>edad</b></td>
      <td>Segmentación demográfica y análisis de mercado</td>
      <td>Gerente de Inteligencia de Negocios</td>
      <td>Analítica</td>
      <td>Anonimización vía vista agregada (<b>k-anonimato</b>)</td>
      <td>Conservación en formato agregado</td>
      <td>Conservar únicamente métricas agregadas</td>
    </tr>
    <tr>
      <td><b>ciudad</b></td>
      <td>Logística de entrega y estadísticas de zona</td>
      <td>Gerente de Logística</td>
      <td>Atención al cliente, Analítica</td>
      <td>Control de acceso <b>RBAC</b> y vistas agrupadas</td>
      <td>Duración de la relación comercial + 3 años</td>
      <td>Anonimización de zona geográfica</td>
    </tr>
    <tr>
      <td><b>codigo_postal</b></td>
      <td>Validación de domicilio fiscal y logística</td>
      <td>Gerente de Logística / Finanzas</td>
      <td>Facturación, Atención al cliente</td>
      <td>Control de acceso <b>RBAC</b></td>
      <td>Duración de la relación comercial + 5 años</td>
      <td>Eliminación segura</td>
    </tr>
  </tbody>
</table>

---

## 9. Evaluación Integral de Riesgos

A partir del análisis del escenario hipotético de 50,000 clientes, se consolidaron los 10 principales problemas y sus controles técnicos/administrativos propuestos:

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
      <td>Excluir columnas identificables (<b>rfc</b>, <b>telefono</b>, <b>nombre</b>) del alcance de los roles de inteligencia de negocios.</td>
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
      <td>Exposición innecesaria de <b>PII</b> en ambientes con controles de acceso relajados y sin auditoría.</td>
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
      <td>Ausencia de control de acceso basado en roles acotado</td>
      <td>Mínimo privilegio / Control de acceso</td>
      <td>Empleados operando con permisos excesivos para leer o exportar la tabla completa de clientes.</td>
      <td>Revocar privilegios globales y estructurar permisos explícitos por función de puesto.</td>
    </tr>
    <tr>
      <td><b>10</b></td>
      <td>Falta de registros de auditoría sobre lecturas y exportaciones de datos</td>
      <td>Trazabilidad / Responsabilidad proactiva</td>
      <td>Incapacidad de detectar, investigar o deslindar responsabilidades ante exfiltraciones internas de información.</td>
      <td>Habilitar la extensión para auditar consultas y accesos a tablas con datos personales.</td>
    </tr>
  </tbody>
</table>


## 10. Conclusiones

1. **La seguridad técnica no garantiza la privacidad:** Una base de datos con cifrado perfecto y contraseñas robustas puede violar la ley si almacena datos innecesarios o los utiliza para finalidades no autorizadas.
2. **El DBA como Data Custodian:** El Administrador de Base de Datos no debe actuar como dueño del dato ni determinar unilateralmente las finalidades de tratamiento. Su rol es implementar técnicamente las directrices dictadas por el **Data Owner** y el área legal.
3. **Privacidad por Diseño en la Arquitectura:** La protección de datos debe integrarse desde el modelado conceptual mediante la separación de esquemas, el uso de vistas anonimizadas, el enmascaramiento dinámico y políticas de purga automatizada.

# 11. Preguntas de Reflexión

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?
No. La seguridad técnica garantiza la confidencialidad, integridad y disponibilidad mediante controles como cifrado, contraseñas y firewalls. Sin embargo, la privacidad evalúa la legitimidad del tratamiento: si los datos almacenados son excesivos, carecen de consentimiento, se usan para finalidades distintas a las informadas o se conservan tras vencer su plazo legal, la base de datos estará en incumplimiento normativo independientemente de qué tan segura sea técnicamente.

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?
Porque limita el acceso a la información de identificación personal estrictamente a los usuarios y procesos que la necesitan para cumplir una función operativa autorizada. Reducir los permisos de consulta directos sobre tablas sensibles minimiza la superficie de exposición ante exfiltraciones internas o credenciales comprometidas.

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?
Porque el **DBA** es el **custodio técnico** y no el **propietario del dato** ni el responsable legal de cumplimiento. Definir la finalidad de un dato requiere interpretar leyes, contratos, avisos de privacidad y riesgos del negocio, funciones que corresponden a las áreas legal, de gobernanza y a las direcciones operativas.

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?
Porque las bases de datos de producción contienen datos personales reales no enmascarados. Los entornos de desarrollo y pruebas suelen tener políticas de seguridad relajadas, accesos compartidos, carencia de auditoría y almacenamiento en laptops corporativas, lo que representa un elevado riesgo de fuga de información.

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?
Porque mantiene la **PII** de clientes reales expuesta fuera del perímetro seguro de producción. Si una copia de desarrollo es sustraída, extraviada o expuesta en un repositorio sin protección, la organización enfrenta las mismas consecuencias legales, financieras y reputacionales que si la filtración hubiera ocurrido en el servidor de producción.

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?
Porque mantener datos indefinidamente viola el principio de minimización y la limitación del plazo de conservación. Establecer un periodo de retención claro permite programar la depuración, bloqueo o anonimización de la información al término de su necesidad legal o comercial, reduciendo los costos de almacenamiento y el impacto de posibles incidentes de seguridad.

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?
La relación radica en que los requisitos de privacidad deben modelarse directamente en la estructura de la base de datos desde su concepción. Esto implica crear tablas acotadas, aplicar restricciones de integridad, definir esquemas separados por finalidad, incorporar campos de auditoría y retención, y restringir el acceso directo mediante vistas y roles **RBAC** antes de que el sistema entre a producción.

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?
- **Control de acceso:** Implementación de roles **RBAC** y revocación de permisos globales.
- **Abstracción de datos:** Uso de vistas agregadas y anonimizadas para perfiles analíticos.
- **Cifrado:** Cifrado simétrico en reposo a nivel de columna para atributos sensibles y obligatorio en tránsito.
- **Trazabilidad:** Habilitación de auditoría detallada (**pgAudit**) para registrar el acceso a tablas con **PII**.
- **Anonimización:** Sustitución de datos reales en ambientes de prueba por datos sintéticos.

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?
- **Para Acceso:** El identificador único del titular y las tablas, vistas y respaldos donde se encuentra su información.
- **Para Rectificación:** El dato exacto a actualizar y la existencia de triggers o procesos de auditoría para registrar el evento.
- **Para Cancelación:** La estructura de relaciones y claves foráneas para ejecutar el bloqueo o borrado en cascada, así como la ubicación de sus datos en respaldos y réplicas.
- **Para Oposición:** Las columnas de control o banderas de consentimiento utilizadas por las aplicaciones para excluir al titular de tratamientos específicos.

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?
- **Área Jurídica / Privacidad:** Determinar la base legal del tratamiento, redactar el Aviso de Privacidad, definir los plazos de retención legal y evaluar la procedencia de las solicitudes **ARCO**.
- **Propietario de Datos:** Definir la finalidad operativa del dato, autorizar quiénes requieren acceso por función de puesto y aprobar las matrices de permisos.
- **DBA (Data Custodian):** Implementar los controles técnicos en la base de datos, configurar el modelo **RBAC**, construir vistas de minimización, gestionar respaldos, habilitar auditorías y ejecutar la depuración técnica autorizada.