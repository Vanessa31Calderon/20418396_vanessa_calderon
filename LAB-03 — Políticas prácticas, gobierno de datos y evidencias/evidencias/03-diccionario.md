# Actividad 3 - Diccionario de datos

## Diccionario de la tabla public.clientes

| Columna | Clasificación (Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
|---|---|---|---|---|---|
| id | Dato interno | Identificar a cada cliente de forma única | Llave primaria automática (no acepta nulos) | Sí, LAB-01 Parte B | Único, no nulo, generado por secuencia |
| nombre | Dato personal | Identificar al cliente | Acceso limitado por rol | Sí, LAB-01 Parte B | No puede estar vacío |
| correo | Dato personal | Enviar notificaciones y contacto | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | Formato de correo válido y que no se repita |
| telefono | Dato personal | Contactar al cliente para soporte o avisos | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | 10 dígitos numéricos |
| rfc | Dato personal | Facturación | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | Formato de RFC válido (12 o 13 caracteres) |
| edad | Dato personal | Estadísticas y análisis general | Acceso solo para roles autorizados | Sí, LAB-01 Parte B | Número válido (mayor de edad) |
| ciudad | Dato interno | Envíos y ubicación general | Acceso por rol operativo | Sí, LAB-01 Parte B | Nombre de ciudad escrito de forma uniforme |
| codigo_postal | Dato interno | Envíos y validación de domicilio | Acceso por rol operativo | Sí, LAB-01 Parte B | 5 dígitos numéricos |
| fecha_alta | Dato interno | Saber cuándo se registró el cliente | Se llena sola por defecto | Sí, LAB-01 Parte B | Fecha válida, no puede ser futura |
| segmento | Dato interno | Clasificar al cliente para promociones o trato comercial | Acceso por rol comercial | Sí, LAB-01 Parte B | Solo valores permitidos (ej. minorista, mayorista, VIP) |

## Preguntas

1. **¿Qué ventaja tiene guardar el significado en COMMENT en lugar de solo en un documento aparte?**  
   Que la explicación queda pegada directamente a la tabla y a cada columna dentro de la base de datos. Así no se pierde en un archivo aparte que nadie actualiza, y cualquiera que revise la tabla desde pgAdmin o psql puede ver qué significa cada campo y quién es el dueño.

2. **¿Quedaron registrados los COMMENT en la bitácora? ¿Con qué nivel de log_statement?**  
   Sí quedaron registrados. Como COMMENT es una instrucción DDL y el servidor tiene log_statement en nivel mod, PostgreSQL guarda tanto los cambios de estructura (DDL) como las modificaciones de datos.

3. **¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?**  
   Los detalles de seguridad más delicados, los plazos legales de cuánto tiempo guardar los datos y los permisos o procesos internos de la empresa. Eso no conviene meterlo directo en el motor porque si alguien con acceso de lectura revisa la base de datos podría ver cómo están armados los controles, además de que las reglas legales las cambia el área jurídica, no el DBA.