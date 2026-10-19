

## 7. Actividad 1 — Clasificación de los datos
<table>
  <thead>
    <tr>
      <th>Campo</th>
      <th>¿Identifica directamente?</th>
      <th>¿Puede contribuir a identificar?</th>
      <th>¿Requiere protección?</th>
      <th>Justificación</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Id</td>
      <td>No</td>
      <td>Si</td>
      <td>Si</td>
      <td>Porque teniendo el id de la persona puede acceder a sus datos, teniendo en cuenta que el id es la clave directa de cada persona, al asociarse a la base de datos revela la identidad completa.</td>
    </tr>
    <tr>
      <td>Nombre</td>
      <td>Si</td>
      <td>Si</td>
      <td>Si</td>
      <td>Es un dato que identifica directamente a la persona por su nombre propio y apellidos.</td>
    </tr>
    <tr>
      <td>Correo</td>
      <td>Si</td>
      <td>Si</td>
      <td>Si</td>
      <td>Es una dirección de contacto única. Permite identificar y contactar directamente a la persona.</td>
    </tr>
    <tr>
      <td>Telefono</td>
      <td>Si</td>
      <td>Si</td>
      <td>Si</td>
      <td>Es una línea de contacto personal e individual que permite la localización e identificación directa.</td>
    </tr>
    <tr>
      <td>Rfc</td>
      <td>Si</td>
      <td>Si</td>
      <td>Si</td>
      <td>El RFC es un identificador único directo de una persona física por lo que la identifica directamente y por ende requiere protección.</td>
    </tr>
    <tr>
      <td>Edad</td>
      <td>No</td>
      <td>Si</td>
      <td>No / Depende el contexto</td>
      <td>No identifica por sí sola a un individuo, pero combinada con otros campos (ej. ubicación o nombre) ayuda a perfilarlo.</td>
    </tr>
    <tr>
      <td>Ciudad</td>
      <td>No</td>
      <td>Si</td>
      <td>No</td>
      <td>Es un dato geográfico general con miles de habitantes pero puede contribuir a identificar si se junta con otros datos.</td>
    </tr>
    <tr>
      <td>Codigo_postal</td>
      <td>No</td>
      <td>Si</td>
      <td>No</td>
      <td>No identifica a la persona porque abarca a toda una colonia o zona, pero puede servir para delimitar la ubicación del usuario.</td>
    </tr>
    <tr>
      <td>Fecha_alta</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
      <td>Es solo un registro interno del sistema sobre cuándo se creó el usuario y no da información personal.</td>
    </tr>
  </tbody>
</table>

#### Preguntas
**¿Qué campos identifican directamente a una persona?** 
Nombre, correo, telefono y rfc.

**¿Qué campos no identifican por sí solos pero podrían contribuir a hacerlo?**
Id, edad, ciudad, codigo_postal.

**¿Qué combinación de campos podría incrementar el riesgo de reidentificación?**
Edad, ciudad, codigo_postal, fecha_alta

**¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?**
No, porque existen los datos personales y los datos personales sensibles que la ley distingue. Por ejemplo, los datos personales son aquellos que identifican a una persona (como tu nombre, teléfono, correo o RFC) y que se deben proteger para cuidar tu privacidad, pero no son delicados. Y los datos personales sensibles son en los que la ley te obliga a tener una protección mucho más estricta porque afectan la esfera más íntima de la persona o pueden causar discriminación (como tu historial médico, religión o preferencias sexuales).

## 8. Actividad 2 — Enmascaramiento (masking)
**¿Qué información continúa existiendo en la tabla original?**
Id, nombre, correo, telefono, rfc, edad, ciudad,codigo_postal, fecha_alta

**¿Qué información puede visualizar el usuario soporte?**
Id y nombre

**¿Por qué no es suficiente ocultar los datos únicamente en la aplicación?**
Porque la aplicacion tiene los datos en crudo, pero al momento de mostrarlos los muestra enmascarados, si alguna persona maliciosa tiene acceso a la base de datos puede obtener dicha información que es sensible.

**¿Qué ocurriría si soporte tuviera acceso directo a clientes?**
Puede haber algún riesgo de filtración de datos y se estaria incumpliendo la LFPDPPP , ya que no se estaría limitando el acceso a la información confidencial según la función de cada usuario. 

## 9. Actividad 3 — Seudonimización (pseudonymization)

**¿Qué ocurriría si analista pudiera consultar también pii.mapa_cliente?**
Podría reidentificar a los clientes uniendo el token o ID con sus datos personales reales, perdiendo por completo la protección de la información confidencial y el propósito de haber separado la base de datos analítica.

**¿Qué principio de seguridad se está aplicando al separar ambos accesos?**
El principio de menor privilegio (o separación de funciones), ya que a cada rol se le otorga únicamente el acceso a la información estrictamente necesaria para realizar sus labores diarios sin exponer datos de más.

**¿Por qué la seudonimización no equivale a anonimización?**
Porque en la seudonimización la información real sigue existiendo y se puede recuperar si tienes la llave o tabla de correspondencia (como el mapa de clientes), mientras que en la anonimización el proceso es irreversible y es imposible volver a identificar a la persona de cualquier forma.

**¿Qué información permite volver a relacionar el token con una persona?**
La tabla o mapa de correspondencia (pii.mapa_cliente), que es la que guarda la relación exacta entre el token (o código) y el ID real de la persona.

### 13. Actividad 6 — Análisis del riesgo de reidentificación
**¿Qué identificadores directos fueron eliminados?**
Se eliminaron por completo el id original, el nombre, el correo, el telefono y el rfc al momento de crear la tabla analitica.clientes.

**¿Qué cuasi-identificadores permanecen?**
En la tabla analítica siguen existiendo los datos exactos de edad, ciudad, codigo_postal y fecha_alta.

**¿Qué combinaciones de atributos podrían reducir el anonimato?**
Juntar la edad exacta con el codigo_postal y la fecha_alta. Es muy poco probable que muchas personas compartan la misma edad exacta, vivan en la misma colonia y se hayan registrado en el sistema exactamente el mismo día, lo que aísla los perfiles. 

**¿Qué sucede cuando un grupo contiene pocos registros?**
El riesgo de reidentificación es mucho más alta. Si dentro de los datos solo hay una o dos personas con ciertas características (por ejemplo 54 años en el código postal 80000), basta con cruzar ese dato con una red social o directorio público para saber exactamente quién es la persona detrás del token.   

**¿Qué atributos deberían generalizarse?**
La edad debe pasarse a rangos (por ejemplo: con la edad, en lugar de poner "Edad: 23 años", es mejor agruparlo en rangos como "Edad: 18 a 30 años".). El codigo_postal también podría generalizarse agrupando zonas más amplias o dejando solo la ciudad.   

**¿Qué información debería suprimirse?**
Los valores atípicos que hacen único a un registro (por ejemplo, si solo hay un cliente de 85 años) o la precisión innecesaria de la fecha_alta (se podría suprimir el día y mes, dejando únicamente el año de registro para fines estadísticos).

**¿Es correcto afirmar que el conjunto de datos es “100 % anónimo”? ¿Por qué?**
No, porque las combinaciones de pistas (edad, ciudad, código postal) aún permiten deducir personas. Y porque se creó un mapa de correspondencia (tokens), lo que significa que los datos están seudonimizados (tienen un disfraz con llave), no verdaderamente anonimizados (donde la información real se destruye para siempre).

### Reto 
**Cambio realizado:**
Se sustituyó el número de teléfono completo por solo sus últimos 2 dígitos utilizando la función RIGHT(telefono, 2), se agrupó la edad en rangos (rango_edad), se tomaron únicamente los primeros 2 dígitos del codigo_postal (region) y se ajustó la agrupación con GROUP BY 1, 2, 3.   

**Motivo:**
El número telefónico completo y el código postal exacto son identificadores muy precisos que permiten ubicar o contactar directamente a un cliente. Al recortarlos y mostrar solo la terminación del teléfono y la región general del código postal, se enmascara la información manteniendo cierto valor para conteos o validaciones simples.   

**Resultado obtenido:** 
Una tabla agrupada que muestra únicamente el rango de edad de los clientes, la región general de su código postal, la terminación de dos dígitos de su teléfono y la cantidad total de personas que coinciden con ese grupo (total).

**Riesgo que se pretende reducir:**
El riesgo de reidentificación y contacto no deseado. Se evita que alguien pueda identificar a un cliente específico cruzando su número telefónico completo con su ubicación exacta, reduciendo así la probabilidad de rastreo directo.   

## 14. Actividad 7 — Retención de datos.
**Registros que serían afectados:**
Todos los registros de la tabla clientes cuya fecha de registro (fecha_alta) tenga una antigüedad mayor a 5 años con respecto a la fecha actual.   

**¿Cuál sería la justificación del periodo?**
El periodo de 5 años responde al cumplimiento de los plazos legales de prescripción en materia fiscal y comercial (según normativas de protección de datos como la LFPDPPP y disposiciones fiscales), evitando conservar datos personales inactivos por más tiempo del estrictamente necesario.

**¿Qué aprobación debería existir antes de eliminar información?** Una autorización formal del Oficial de Protección de Datos, el área Legal y el Dueño del Sistema/Negocio, validando que los clientes a eliminar no tengan procesos legales, contractuales o contables pendientes.

**¿Qué respaldo debería existir?**Un respaldo completo previo almacenado en un repositorio seguro y cifrado, separado de la base de datos de producción.

**¿Qué evidencia debería conservarse?** Un registro de auditoría (log) que documente la ejecución de la depuración, incluyendo el total de filas borradas, el usuario que ejecutó la sentencia, la fecha y hora exacta, y la copia del ticket/acta de aprobación.

**¿Qué procedimiento permitiría recuperar información eliminada accidentalmente?** Un procedimiento de restauración desde respaldo (Plan de Recuperación ante Desastres), donde se restaura la copia previa en un servidor secundario, se extraen los registros borrados por error y se reinsertan mediante scripts de migración.

# 19. Informe del Laboratorio

## 19.1 Clasificación
En este laboratorio se analizó la estructura de la tabla **clientes** para determinar qué datos corresponden a identificadores directos, cuasi-identificadores y atributos no identificables. 

Se determinó que datos como el **nombre**, **correo**, **teléfono** y **RFC** requieren una protección estricta debido a que son identificadores directos que vinculan inmediatamente un registro con una persona física en cambio, la **edad**, **ciudad** y **código postal** se clasificaron como cuasi-identificadores: aunque por sí solos no revelan una identidad, su combinación en conjuntos de datos pequeños incrementa significativamente el riesgo de reidentificación.

## 19.2 Enmascaramiento
**¿Qué se ocultó?**: Se aplicó una máscara parcial sobre las columnas de **correo** (mostrando solo los dos primeros caracteres y el dominio), **telefono** (ocultando los primeros 6 dígitos y dejando visibles los últimos 4) y **rfc** (dejando visibles solo los últimos 4 caracteres).

**¿Para quién?**: Para el rol **soporte**.

**¿Por qué?**: El área de soporte únicamente requiere identificar parcialmente al cliente para confirmar su identidad durante llamadas o tickets de servicio, sin necesidad de visualizar la totalidad de la información sensible.

**Mecanismo utilizado**: Se creó la vista **v_clientes_soporte** utilizando funciones de cadena de PostgreSQL. Posteriormente, se otorgaron permisos **SELECT** sobre dicha vista al rol **soporte** y se le revocó todo acceso a la tabla base **public.clientes**.


## 19.3 Seudonimización
**Generación de tokens**: Se utilizó la extensión **pgcrypto** mediante la función **gen_random_uuid()** para asignar un identificador único universal (UUID) a cada cliente.

**Ubicación del mapa de correspondencia**: La relación entre el **token y el cliente_id** original se almacenó en la tabla **pii.mapa_cliente**, ubicada dentro de un esquema protegido denominado **pii**.

**Acceso y permisos**: Únicamente el administrador de la base de datos (DBA) o roles de alta confianza deben tener acceso al esquema **pii**.

**Separación de permisos**: Se implementó una separación estricta de funciones. Al rol **analista** se le concedió acceso de lectura exclusivo a la tabla **analitica.clientes**, denegando explícitamente el acceso a **pii.mapa_cliente y a public.clientes** para evitar que pueda revertirse la identidad de los usuarios.

## 19.4 Anonimización
**Identificadores eliminados**: Se removieron de forma absoluta los campos id, nombre, correo, telefono y rfc.

**Generalización de atributos**: Se aplicó generalización por rangos sobre la edad (agrupando en rangos como '18-30', '31-45', '46+') y sobre la ubicación geográfica reduciendo el codigo_postal a sus primeros 2 dígitos (region).

**Supresión de grupos**: Se utilizó la cláusula HAVING COUNT(*) >= 5 para aplicar un criterio didáctico de k-anonimato, eliminando de los reportes estadísticos aquellos grupos pequeños con menos de 5 miembros.

**Riesgo de reidentificación remanente**: A pesar de la generalización y agregación, persiste el riesgo si los datos filtrados se cruzan con fuentes de datos externas o bases públicas. Además, contar con muestras reducidas o combinaciones atípicas de atributos dentro de una misma región geográfica puede permitir la triangulación indirecta de un individuo.


## 19.5 Retención
**Criterio utilizado**: Se estableció una regla de conservación máxima de 5 años contados a partir de la fecha de registro del usuario (fecha_alta).

**Información a conservar**: Se conserva la información de clientes activos, así como aquellos registros que requieran ser mantenidos por obligaciones contables, fiscales o de auditoría vigentes.

**Información a eliminar (registros afectados)**: Todos los registros de la tabla clientes cuya fecha de registro (fecha_alta) tenga una antigüedad mayor a 5 años con respecto a la fecha actual.

**Justificación del periodo**: El periodo de 5 años responde al cumplimiento de los plazos legales de prescripción en materia fiscal y comercial (según normativas de protección de datos como la LFPDPPP y disposiciones fiscales), evitando conservar datos personales inactivos por más tiempo del estrictamente necesario.

**Controles antes de la eliminación**:
1. **Aprobaciones necesarias**: Autorización formal del Oficial de Protección de Datos (DPO), el área Legal y el Dueño del Sistema/Negocio, validando que los clientes a eliminar no tengan procesos legales, contractuales o contables pendientes.
2. **Respaldo previo**: Un respaldo completo almacenado en un repositorio seguro y cifrado, separado de la base de datos de producción.
3. **Evidencia y auditoría**: Un registro de auditoría (log) que documente la ejecución de la depuración, incluyendo el total de filas borradas, el usuario que ejecutó la sentencia, la fecha y hora exacta, y la copia del ticket/acta de aprobación.
4. **Procedimiento de recuperación**: Un Plan de Recuperación ante Desastres donde se pueda restaurar la copia previa en un servidor secundario para extraer y reinsertar registros borrados por error.

## 19.6 Conclusiones

**¿Qué técnica utilizarías para un área de soporte?**
Enmascaramiento de datos porque permite que el personal de soporte vea solo los datos indispensables (como ID y nombre) y mantenga ocultos o censurados los datos de contacto y claves personales (como correo, teléfono y RFC) mediante asteriscos o vistas específicas.   

**¿Qué técnica utilizarías para un área de analítica?**
Seudonimización porque consiste en reemplazar los identificadores directos por tokens únicos. Esto permite a los analistas trabajar con la estructura completa de los datos y cruzarlos de forma técnica sin conocer la identidad real del cliente.   

**¿Qué técnica utilizarías para publicar estadísticas?**
Anonimización y agregación de datos porque ayuda a agrupar la información en rangos o métricas globales, rangos de edad o agrupaciones por ciudad y eliminar o suprimir casos aislados. De esta forma, los resultados son puramente numéricos y es imposible revertirlos para identificar a una persona individual.

**¿Por qué ninguna de estas técnicas sustituye al control de acceso?**
Porque estas técnicas protegen o transforman la forma en que se ven los datos, pero no controlan quién puede entrar a la base de datos. Si no existe un control de acceso (roles, usuarios y permisos), cualquier usuario podría brincarse las vistas, acceder directamente a las tablas base o al mapa de correspondencia y ver toda la información confidencial sin restricciones. 

## 20. Preguntas de reflexión
**1. ¿Cuál es la diferencia entre enmascaramiento y seudonimización?** El enmascaramiento solo oculta o tapa visualmente partes de un dato (por ejemplo, reemplazar caracteres por asteriscos como an*****@example.com), mientras que la seudonimización reemplaza el dato real por un código o clave artificial (token) que no revela la identidad del usuario a menos que se cruce con una tabla de correspondencia.   

**2. ¿Por qué la seudonimización no significa anonimización?** Porque la seudonimización es reversible. Si se tiene acceso al mapa de correspondencia o a la llave, se pueden volver a unir los tokens con las personas reales. La anonimización, en cambio, es un proceso definitivo e irreversible. 

**3. ¿Por qué eliminar nombre y RFC no garantiza que un conjunto de datos sea anónimo?** Porque los datos que quedan (como edad, código postal, ciudad y fecha de alta) actúan como cuasi-identificadores. Al combinar o cruzar varias de estas pistas entre sí o con fuentes externas, se puede triangular la identidad de un usuario específico.   

**4. ¿Qué función tienen los cuasi-identificadores?** Son atributos que, de forma aislada, no identifican a una persona, pero al combinarse entre sí reducen drásticamente la cantidad de individuos posibles, permitiendo aislar y reidentificar a un cliente.   

**5. ¿Por qué es importante separar el mapa de seudonimización?** Para evitar que quien analice o consulte el conjunto de datos pueda "desenmascarar" la información. Si el mapa de correspondencia estuviera en el mismo esquema o con acceso público, la seudonimización no serviría de nada.   

**6. ¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?** El Principio de Menor Privilegio (o Separación de Funciones), el cual establece que cada rol solo debe tener acceso a la información estrictamente necesaria para realizar sus labores.   

**7. ¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?** Porque la vista actúa como un filtro intermedio: que permite mostrar únicamente los campos y registros permitidos (o enmascarados) sin darle al usuario permisos de lectura directa sobre la tabla base original.   

**8. ¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?** 
* Proteger para visualización: Solo maquilla o tapa el dato en la pantalla, pero la información en bruto sigue viajando por la red y existe en la base de datos. 
* Proteger contra acceso no autorizado: Aplica reglas de permisos y seguridad directamente en el motor de la base de datos, impidiendo que el usuario pueda consultar o extraer la información por cualquier medio (SQL, API o interfaz).   

**9. ¿Por qué la retención forma parte de la protección de datos?** Porque el principio de limitación del plazo de conservación exige que los datos personales se guarden solo durante el tiempo necesario para la finalidad con la que se recabaron. Una vez cumplida esa función o vencido el plazo legal, la información debe eliminarse para proteger la privacidad del titular.   

**10. ¿Qué riesgo existe si una organización conserva información indefinidamente?** Aumenta drásticamente la superficie de ataque y el impacto de una filtración. Si la organización sufre un ciberataque o robo de datos, los atacantes obtendrán historiales completos e información de clientes antiguos que ya ni siquiera tienen relación comercial con la empresa, lo que genera severas sanciones legales e incumplimientos normativos (LFPDPPP/GDPR).