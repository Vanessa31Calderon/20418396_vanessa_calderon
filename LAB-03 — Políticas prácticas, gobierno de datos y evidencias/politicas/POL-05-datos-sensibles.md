# POL-05 — Uso de datos sensibles

**Objetivo:** Reducir el riesgo de fuga, consulta indebida o exposición de datos personales de los clientes (nombre, correo, teléfono, RFC y edad).
Alcance: Aplica a la tabla public.clientes, auditoria.cambios_clientes, colección clientes y system.profile en PostgreSQL 18 y MongoDB 7, así como a cualquier exportación o consulta sobre ellos.
---
**Regla:** Solo los roles con una necesidad operativa aprobada pueden consultar datos personales completos; el personal de soporte debe usar únicamente vistas enmascaradas. Todo cambio sobre datos de clientes debe quedar registrado en auditoria.cambios_clientes y las bitácoras deben revisarse antes de compartirse para evitar filtrar contraseñas o datos personales, conservándose al menos el tiempo que fija POL-03 para poder investigar incidentes.
---
**Responsable:** Decide el propietario del dato (Gerencia Comercial) / ejecuta el DBA y supervisa Auditoría Interna.
Excepciones: No se permiten excepciones para compartir datos personales sin máscara fuera de los roles autorizados; para análisis estadístico se deben usar datos anonimizados con visto bueno de Gerencia Comercial.
---
**Evidencia:** Vistas enmascaradas de soporte (Unidad II), registros de auditoria.cambios_clientes (LAB-01, Parte B), diccionario de datos en diccionario-clientes.csv (LAB-03, Actividad 3) y catálogo de datos (LAB-03, Actividad 4).
---
**Revisión:** Semestral, o cada vez que se agreguen columnas con datos personales.
---