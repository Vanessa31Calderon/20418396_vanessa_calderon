**1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?**
* REVOKE UPDATE ON clientes FROM soporte_ana; -> Privilegio (Control de Acceso / DCL).
* GRANT UPDATE ON clientes TO app_ventas; -> Privilegio (Control de Acceso / DCL).
* ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20); -> Estructura (Definición de Datos / DDL).

**2. ¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?** Porque PostgreSQL incluye en la categoría ddl todas las sentencias que modifican el Catálogo del Sistema (pg_catalog), lo que abarca tanto la creación/alteración de objetos de base de datos (CREATE, ALTER, DROP) como la modificación de la matriz de derechos sobre dichos objetos (GRANT, REVOKE, COMMENT). En la taxonomía de seguridad de PostgreSQL, los permisos alteran la definición del objeto en el catálogo relacional, por lo que se auditan bajo el nivel ddl.3. 

**Si la bitácora contiene contraseñas en texto claro, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.**


```Plaintext
  [ Comando SQL Directo ]                            [ Metacomando \password ]
   CREATE ROLE ... PASSWORD 'Secret'                  \password app_ventas
          │                                                   │
          ▼                                                   ▼
 ┌─────────────────┐                                 ┌─────────────────┐
 │ Texto Plano en  │                                 │ Hash SCRAM-SHA  │
 │ Bitácora (.log) │                                 │  en el Cliente  │
 └────────┬────────┘                                 └────────┬────────┘
          │                                                   │
          ▼                                                   ▼
 ┌─────────────────┐                                 ┌─────────────────┐
 │  Riesgo de Fuga │                                 │  Bitácora Segura│
 │   de Secretos   │                                 │ (Sólo Hash)     │
 └─────────────────┘                                 └─────────────────┘
``` 
* Restricción de Acceso: Los archivos de bitácora del servidor únicamente deben ser accesibles por el usuario de sistema del motor (postgres) a nivel de sistema operativo y por el equipo de Administradores de Bases de Datos (DBA) o auditores de seguridad autorizados a nivel de motor (vista dba.bitacora). Bajo ninguna circunstancia deben otorgarse permisos de lectura al público (PUBLIC) ni a usuarios operativos (app_ventas, soporte_ana).