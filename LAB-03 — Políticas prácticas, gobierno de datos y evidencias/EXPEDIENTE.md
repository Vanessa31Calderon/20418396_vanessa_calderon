# Expediente de auditoria interna — Base comercial

## 1. Alcance

Este expediente cubre la revision de gobierno de datos, configuracion de auditoria, politicas y control de cambios sobre la base comercial en PostgreSQL 18 (instalacion local en Windows, administrada mediante pgAdmin 4 y psql, con esquemas public, auditoria, gobierno, analitica, pii y dba) y MongoDB 7 (colecciones comerciales y de perfilado/auditoria). 

El periodo revisado abarca las actividades de la unidad (con eventos registrados en noviembre de 2026, como el 2026-11-06 y el 2026-11-24) y la responsable de integrar el expediente es u_20418396_vanessa_calderon.

## 2. Configuracion de auditoria (A3)

En PostgreSQL 18 se verifico en E1-configuracion-registro.txt que logging_collector, log_connections y log_disconnections estan en on, log_statement esta en mod, log_line_prefix usa %m [%p] user=%u db=%d app=%a client=%h y log_min_error_statement esta en error. En E3-disparadores.txt se confirma que trg_auditoria_clientes esta habilitado (estado O) sobre clientes, y en E4-muestra-auditoria.txt se ven los eventos del 1 al 9 en auditoria.cambios_clientes. La bitacora del colector y su hash corresponden a E5-bitacora-postgresql.log y E5-bitacora-postgresql.sha256, mientras que MongoDB 7 se documenta en las evidencias E6.

## 3. Bitacora interpretada (A3, A5)

Evento 1 — Operaciones de alta, actualizacion y eliminacion en clientes:
- Quien: u_20418396_vanessa_calderon.
- Cuando: 2026-11-06 (id_evento 1 a 7) y 2026-11-24 22:11:18.123305-06 (id_evento 8 y 9).
- Desde donde: pgAdmin 4 en PostgreSQL 18.
- Que ocurrio: se ejecutaron operaciones INSERT, UPDATE y DELETE sobre clientes (incluyendo el alta de Ana Lopez y Jorge Diaz el 2026-11-24), quedando registradas en auditoria.cambios_clientes.
- Que tipo de evento es: modificacion de datos de negocio auditada por disparador.
- Que prueba: E4-muestra-auditoria.txt, E3-disparadores.txt y E5-bitacora-postgresql.log.

Evento 2 — Cambio de estructura y preparacion de objetos de gobierno:
- Quien: u_20418396_vanessa_calderon.
- Cuando: 2026-11-24 entre 23:04:33.6 y 23:05:16.8.
- Desde donde: pgAdmin 4 en PostgreSQL 18.
- Que ocurrio: se creo el esquema gobierno, se revoco acceso en PUBLIC, se creo gobierno.solicitudes_cambio y se ejecuto ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20) junto con sus comentarios.
- Que tipo de evento es: cambios DDL de preparacion sin folio previo y cambio de estructura asociado al folio CAM-2026-014.
- Que prueba: E5-bitacora-postgresql.log y evidencias/06-conciliacion.md.

Evento 3 — Calidad de datos en clientes (incluyendo caso RFC de Maria Garcia / registros de prueba con errores):
- Quien: usuarios y procesos que insertan o actualizan registros en clientes.
- Cuando: durante las pruebas de calidad de datos de la Actividad 1 y cargas de prueba en clientes (como el registro de Jorge Diaz con correo sin-correo, RFC NULL, edad -3 y codigo postal 8000 en la bitacora del 2026-11-24).
- Desde donde: sesiones conectadas a PostgreSQL 18.
- Que ocurrio: se registraron o detectaron datos inconsistentes (RFC faltante o con formato incompleto/erroneo, correos invalidos o duplicados, edades fuera de rango), mostrando el riesgo de ingresar valores incorrectos sin validaciones estrictas ni aprobacion del propietario del dato (como en el caso del RFC de Maria Garcia y registros de prueba) y la necesidad de rastrear correcciones en auditoria.cambios_clientes.
- Que tipo de evento es: hallazgo de calidad de datos y trazabilidad.
- Que prueba: evidencias/01-calidad.md, E4-muestra-auditoria.txt y E5-bitacora-postgresql.log.

## 4. Elementos de gobierno

Los roles y responsabilidades estan en evidencias/02-responsables.md (Gerencia Comercial como propietaria de datos de clientes, Auditoria Interna en auditoria.cambios_clientes y el DBA como custodio). El diccionario de datos de public.clientes esta en evidencias/diccionario-clientes.csv y evidencias/03-diccionario.md, y el catalogo integrado de PostgreSQL 18 y MongoDB 7 (CAT-01 a CAT-05) esta en evidencias/04-catalogo.md.

## 5. Conservacion (A3)

Los criterios de conservacion y borrado/anonimizacion estan en evidencias/05-conservacion.md, contemplando 24 meses para cambios de privilegios y estructura (sujeto a confirmacion juridica), 12 meses en linea para auditoria.cambios_clientes, 90 dias para accesos, modificaciones y bitacora de mongod, 30 dias para exportaciones de system.profile y datos de clientes ligados a la relacion comercial mas plazo fiscal a confirmar con el area juridica, usando hash SHA-256 y borrado seguro o anonimizacion.

## 6. Politicas (A4)

Las seis politicas estan guardadas en:
- politicas/POL-01-acceso.md (evidencia: lineas GRANT/REVOKE, auditoria.instantaneas_privilegios en MongoDB y registro de solicitudes pendiente).
- politicas/POL-02-respaldo.md (evidencia: bitacora de respaldos y actas mensuales de restauracion a implementar en la Unidad V).
- politicas/POL-03-retencion.md (evidencia: evidencias/05-conservacion.md, hashes SHA-256 y actas de borrado/anonimizacion pendientes).
- politicas/POL-04-restauracion.md (evidencia: registros de incidentes y actas de restauracion de la Unidad V y bitacora del servidor).
- politicas/POL-05-datos-sensibles.md (evidencia: vistas enmascaradas como v_clientes_soporte, auditoria.cambios_clientes, evidencias/diccionario-clientes.csv y evidencias/04-catalogo.md).
- politicas/POL-06-cambios-produccion.md (evidencia: tabla gobierno.solicitudes_cambio, dba.bitacora y evidencias/06-conciliacion.md).

## 7. Conciliacion de cambios (A5)

En evidencias/06-conciliacion.md se concilio la bitacora contra gobierno.solicitudes_cambio. El cambio ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20) quedo autorizado bajo el folio CAM-2026-014, mientras que los objetos iniciales de gobierno se crearon como preparacion sin folio previo y se declaro el hueco de evidencia cuando log_statement estaba en none.

## 8. Hallazgos

| ID | Hallazgo | Fuente | Severidad | Impacto | Recomendacion | Decisión requerida de |
|---|---|---|---|---|---|---|
| H-01 | Datos de clientes con RFC faltante o invalido, correos duplicados o mal formados y edades fuera de rango | evidencias/01-calidad.md y E5-bitacora-postgresql.log | Media | Registros incompletos o inconsistentes que afectan facturacion, contacto y reportes | Depurar con respaldo del negocio y evaluar restricciones CHECK e indices unicos aprobados | Gerencia Comercial y Comite de Cambios |
| H-02 | Cambios de preparacion sin folio previo y antecedentes de desactivacion de disparador o intentos de conexion fallidos en bitacora | evidencias/06-conciliacion.md y E5-bitacora-postgresql.log | Alta | Posible alteracion de datos sin rastro en auditoria o accesos no autorizados| Exigir folio previo en gobierno.solicitudes_cambio, revisar logs antes de compartirlos y separar quien concilia | Comite de Cambios, Auditoria Interna y Seguridad de la Informacion |
| H-03 | Huecos de evidencia por log_statement en none al inicio, conexiones hacia base comercial inexistente y actas/registros aun pendientes | evidencias/06-conciliacion.md, E5-bitacora-postgresql.log y POL-01 a POL-06 | Media | Falta de trazabilidad completa en periodos previos o procesos aun no implementados | Declarar los huecos en cada revision y formalizar registros en las siguientes etapas| Auditoria Interna y Gerencia de TI |
| H-04 | Permisos directos en tablas base para soporte_ana, app_ventas, app_comercializadora y usr_consulta, ademas de posibles diferencias entre motores | E2-privilegios.txt y evidencias/04-catalogo.md | Media | Riesgo de acceso mas amplio que el minimo necesario o inconsistencia entre PostgreSQL y MongoDB | Ajustar privilegios al minimo necesario y unificar criterios de propiedad y sincronizacion| Propietario del dato y DBA / Admin de sistemas |

## 9. Limitaciones conocidas y riesgos aceptados (A6)

- Lecturas no auditadas sin pgaudit (verificado en laboratorio al retirar pgaudit de la configuracion): PostgreSQL registra conexiones y cambios segun E1-configuracion-registro.txt, pero no audita lecturas SELECT detalladas sin pgaudit]. Riesgo a aceptar formalmente por: Seguridad de la Informacion y Auditoria Interna.
- Posibilidad de que el administrador desactive la auditoria (verificado en laboratorio al desactivar o reactivar disparadores o modificar configuracion como superusuario): un usuario con privilegios altos puede apagar controles o alterar logs locales. Riesgo a aceptar formalmente por: Gerencia de TI y Auditoria Interna.
- MongoDB Community sin auditoria nativa (verificado en el laboratorio con MongoDB Community, a diferencia de la auditoria nativa de MongoDB Enterprise que solo esta documentada pero no practicada): se depende de bitacoras, system.profile y controles a nivel de aplicacion/red. Riesgo a aceptar formalmente por: Seguridad de la Informacion y Gerencia de TI.
- Huecos temporales de bitacora y procesos aun no practicados (como respaldos, restauraciones y actas de borrado de la Unidad V): deben considerarse al interpretar la evidencia actual. Riesgo a aceptar formalmente por: Gerencia de TI y Propietario del dato.

## 10. Indice de evidencias

- evidencias/01-calidad.md
- evidencias/02-responsables.md
- evidencias/diccionario-clientes.csv
- evidencias/03-diccionario.md
- evidencias/04-catalogo.md
- evidencias/05-conservacion.md
- politicas/POL-01-acceso.md
- politicas/POL-02-respaldo.md
- politicas/POL-03-retencion.md
- politicas/POL-04-restauracion.md
- politicas/POL-05-datos-sensibles.md
- politicas/POL-06-cambios-produccion.md
- evidencias/06-conciliacion.md
- evidencias/07-evidencias.md
- evidencias/E1-configuracion-registro.txt
- evidencias/E2-privilegios.txt
- evidencias/E3-disparadores.txt
- evidencias/E4-muestra-auditoria.txt
- evidencias/E5-bitacora-postgresql.log
- evidencias/E5-bitacora-postgresql.sha256 (hash SHA-256 calculado sobre evidencias/E5-bitacora-postgresql.log)
- evidencias/E6 (system-profile.json, bitacora-mongod.log, sus hashes SHA-256 y comparacion de la Actividad 9 del LAB-02)
