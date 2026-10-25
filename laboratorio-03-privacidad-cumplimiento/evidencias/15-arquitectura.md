# Actividad 15 — Propuesta de arquitectura de datos protegidos

## Esquema Conceptual de Separación por Finalidad

```Plaintext

                                 BASE DE DATOS POSTGRESQL 16
                                              │
               ┌──────────────────────────────┼──────────────────────────────┐
               ▼                              ▼                              ▼
     [ CAPA OPERATIVA ]             [ CAPA ANALÍTICA ]             [ CAPA DE AUDITORÍA ]
     (Esquema: public)              (Esquema: analytics)           (Esquema: audit)
               │                              │                              │
               ▼                              ▼                              ▼
    Datos necesarios para          Datos agregados y             Registros de trazabilidad
    operación diaria (PII)         anonimizados                  y eventos DDL/DML
```
## Detalle de Controles Técnicos y de Gobierno

### 1. Control de Acceso
- **Segregación por Esquemas:** Creación de tres esquemas independientes en PostgreSQL 16.
- **Modelo RBAC (Role-Based Access Control):** 
  - El rol **app_operacion** únicamente posee permisos **SELECT**, **INSERT**, **UPDATE** sobre tablas del esquema **public**.
  - El rol **analista** únicamente posee permisos **SELECT** sobre vistas del esquema **analytics**, teniendo un **REVOKE ALL** explícito sobre la capa operativa.
  - El rol **auditor** únicamente posee permisos de lectura sobre las tablas de trazabilidad en el esquema **audit**.
- **Control Perimetral:** Reglas estrictas en **pg_hba.conf** filtrando conexiones por IP de origen según la función del servidor.

### 2. Minimización de Datos
- **Vistas Agregadas en Analítica:** La capa analítica no almacena tablas independientes con datos duplicados; utiliza vistas que agrupan métricas mediante **COUNT**, **AVG** y rangos.
- **Exclusión de PII Directa:** Vistas que omiten completamente identificadores como **nombre**, **correo**, **telefono** y **rfc**, exponiendo únicamente atributos demográficos o regionales.

### 3. Protección de Información Sensible
- **Cifrado en Reposo (Columna):** Aplicación de la extensión **pgcrypto** mediante la función **pgp_sym_encrypt** para proteger atributos críticos de alto riesgo.
- **Cifrado en Tránsito:** Configuración obligatoria de TLS 1.3 para encriptar todas las sesiones entre los clientes, las aplicaciones y el servidor de base de datos.

### 4. Retención de Datos
- **Aislamiento por Ciclo de Vida:** Tablas operativas configuradas con campos de control de fecha.
- **Apurado Automatizado:** Funciones programadas que ejecutan rutinas de depuración o transferencia a esquemas de archivo al cumplir los plazos legales (por ejemplo, 5 años para datos de facturación conforme al Código Fiscal de la Federación).

### 5. Trazabilidad
- **Auditoría Técnica:** Habilitación de la extensión **pgAudit** para registrar en el esquema **audit** cualquier acceso, consulta o modificación realizada sobre tablas que contengan datos personales identificables.
- **Inmutabilidad:** Las tablas de auditoría se configuran con permisos de solo inserción, impidiendo que incluso los usuarios operativos puedan modificar o eliminar los registros de eventos.

### 6. Eliminación y Disposición Final
- **Supresión Segura:** Procedimientos almacenados para la ejecución de borrado lógico y posterior borrado físico irrecuperable de la tabla principal.
- **Cascada en Entornos Derivados:** Protocolos documentados para replicar la orden de eliminación en las réplicas de lectura, sistemas de almacenamiento analítico y políticas de rotación de respaldos físicos.

### 7. Atención de Solicitudes ARCO
- **Mecanismos de Oposición:** Inclusión de banderas de control en la capa operativa que excluyen automáticamente al titular de los envíos de campañas o procesos analíticos secundarios.
- **Acceso y Rectificación:** Vistas parametrizadas por identificador único del cliente para extraer en un solo reporte toda su información personal registrada o aplicar actualizaciones auditadas.