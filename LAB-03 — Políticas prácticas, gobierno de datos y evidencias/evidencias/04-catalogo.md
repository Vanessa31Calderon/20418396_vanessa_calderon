# Actividad 4 - Catálogo mínimo de datos

## Catálogo de conjuntos de datos (PostgreSQL y MongoDB)

| ID | Conjunto de datos | Motor | Ubicación | Propietario | Custodio | Clasificación | Contiene datos personales | Finalidad | Conservación | Diccionario |
|---|---|---|---|---|---|---|---|---|---|---|
| CAT-01 | Clientes | PostgreSQL 18 | localhost / comercial / public.clientes | Gerencia Comercial | DBA | Confidencial | Sí | Operación diaria, contacto y facturación | Mientras siga activo el cliente + plazo fiscal (a confirmar con el área jurídica) | diccionario-clientes.csv |
| CAT-02 | Auditoría de clientes | PostgreSQL 18 | localhost / comercial / auditoria.cambios_clientes | Auditoría Interna | DBA | Restringida | Sí | Llevar el historial de cambios en la tabla clientes | 1 a 2 años (a confirmar con el área jurídica) | Estructura de auditoría (LAB-01) |
| CAT-03 | Registro de cambios | PostgreSQL 18 | localhost / comercial / gobierno.solicitudes_cambio | TI / Comité de Cambios | DBA | Interna | No | Registrar quién pide y quién aprueba cambios en la BD | 2 años | Se completa en Actividad 7 |
| CAT-04 | Clientes (tienda) | MongoDB 7 | localhost / comercial / clientes | Gerencia Comercial | DBA / Admin Mongo | Confidencial | Sí | Datos de clientes en la tienda en línea | Mientras siga activo el cliente + plazo fiscal (a confirmar con el área jurídica) | Esquema de documentos de la tienda |
| CAT-05 | Perfilado | MongoDB 7 | localhost / comercial / system.profile | Seguridad / TI | DBA / Admin Mongo | Restringida | Sí | Revisar consultas lentas y monitorear actividad | Se sobrescribe sola al llegar a 1 MB; respaldos por 30 a 90 días | Estructura por defecto de MongoDB |

## Preguntas

1. **¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?**  
   Porque aunque sirvan para auditar o revisar rendimiento, guardan los datos reales que pasaron por la base. En CAT-02 se guardan los valores anteriores y nuevos del cliente en JSON (nombre, correo, RFC, etc.), y en CAT-05 (system.profile) se quedan guardadas las consultas completas de MongoDB con los filtros que se usaron, donde también pueden venir correos o RFC.

2. **¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre ambos motores?**  
   Se hace un problema de inconsistencia porque no se sabe cuál de los dos RFC es el correcto. Al tener dueños distintos, cada área puede corregir solo su base sin avisarle a la otra, lo que termina provocando errores en facturas o en la tienda. Por eso ambos deben tener el mismo propietario y definir cuál base manda sobre la otra.

3. **¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?**  
   Lo técnico, como el tamaño de las tablas, la cantidad de filas o cuando se crean tablas nuevas; eso le toca actualizarlo al **DBA (custodio)**. Lo de negocio, como el propietario o para qué se usan los datos, cambia menos seguido y le toca avisarlo al **propietario del dato**.