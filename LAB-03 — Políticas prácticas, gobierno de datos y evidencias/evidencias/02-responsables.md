# Actividad 2 — Propietarios, custodios y usuarios

## Matriz ampliada de gobierno de datos

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quién aprueba accesos | Quién aprueba correcciones |
|---|---|---|---|---|---|
| comercial.public.clientes (PostgreSQL) | Gerencia Comercial | DBA | Aplicación comercial (lectura/escritura controlada), Soporte a clientes (lectura limitada), Analistas (solo vistas autorizadas) | Gerencia Comercial (Propietario) | Gerencia Comercial (Propietario) |
| auditoria.cambios_clientes (PostgreSQL) | Área de Auditoría Interna / Cumplimiento | DBA | Auditor (solo lectura), disparador del sistema (inserción automática) | Área de Auditoría Interna / Cumplimiento | No admite correcciones ni borrados (registro inmutable); cualquier aclaración se documenta como nota o evento adicional |
| Bitácora de PostgreSQL (archivos log y vista dba.bitacora) | Seguridad de la Información / Auditoría | DBA | DBA (operación y soporte), Seguridad / Auditoría (revisión de incidentes y cumplimiento) | Seguridad de la Información / Auditoría | No se corrige ni altera (evidencia de solo lectura); su retención o depuración sigue la política aprobada |
| comercial.clientes (MongoDB) | Gerencia Comercial | DBA / Administrador de MongoDB | Aplicación comercial / servicios autorizados, Soporte (lectura limitada) | Gerencia Comercial (Propietario) | Gerencia Comercial (Propietario) |
| comercial.system.profile (MongoDB) | Seguridad de la Información / Auditoría (en coordinación con TI) | DBA / Administrador de MongoDB | DBA (diagnóstico de rendimiento), Auditor / Seguridad (revisión de consultas) | Seguridad de la Información / Responsable de TI | No se corrige (colección de perfilado del motor); solo se gestiona su tamaño y retención según política |

## Preguntas

1. **¿Por qué el propietario de auditoria.cambios_clientes no debería ser el mismo que opera clientes?**  
   Por el principio de **segregación de funciones**. Si la misma persona o área que opera y modifica los datos de clientes también es propietaria y responsable de la tabla de auditoría, tendría conflicto de interés y capacidad para ocultar errores, cambios no autorizados o manipulaciones. Que Auditoría o Cumplimiento sea el propietario garantiza independencia e integridad en la evidencia.

2. **¿Quién debería poder leer las bitácoras y la vista dba.bitacora? Relaciónalo con lo observado en el LAB-01 (secretos en la bitacora).**  
   Únicamente personal estrictamente autorizado con necesidad operativa o de control: el **DBA** (para diagnóstico y operación) y el **Auditor / Seguridad de la Información** (para investigar incidentes y verificar cumplimiento). En el LAB-01 se observó que, al registrar sentencias SQL, en la bitácora pueden quedar expuestos datos sensibles o secretos (como contraseñas en texto claro, valores literales de RFC, correos o parámetros de consultas). Si cualquier usuario pudiera leer los archivos de log o la vista dba.bitacora, podría obtener credenciales o datos confidenciales saltándose los permisos de las tablas.

3. **¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.**  
   Cuando un dato no tiene propietario asignado, se diluye la rendición de cuentas: nadie valida su calidad, nadie decide quién puede acceder, nadie autoriza correcciones y los errores se acumulan sin que nadie los atienda (o bien, el área técnica termina tomando decisiones de negocio que no le corresponden). Esto se relaciona directamente con el problema inicial de la unidad: sin gobierno de datos ni responsables claros, aparecen registros duplicados, incompletos o inconsistentes, accesos sin control y falta de evidencia confiable cuando ocurre un incidente o una auditoría.