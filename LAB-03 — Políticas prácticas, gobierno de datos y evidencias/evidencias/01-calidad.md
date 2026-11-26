# 7. Actividad 1 — Calidad de datos desde la operación

## Tabla de hallazgos

| # | Hallazgo | Registros | Regla de calidad | ¿Quién decide la corrección? | Acción propuesta |
|---|---|---|---|---|---|
| C1 | Posible cliente duplicado (ana.lopez@example.test) | 1, 7 | Unicidad del correo (insensible a mayúsculas) | Gerencia Comercial (Propietario del dato) | Validar con el cliente cuál registro conservar, depurar el duplicado y aprobar un índice único sobre lower(correo). |
| C2 | RFC incompleto (12 caracteres) y RFC ausente (NULL) | 7, 8 | Formato del RFC (12-13 caracteres válidos) y completitud | Gerencia Comercial (con respaldo documental del cliente) | Solicitar constancia fiscal para corregir el dato; evaluar restricción CHECK de formato. |
| C3 | Correo electrónico con formato no válido (sin-correo) | 8 | Formato válido de correo electrónico | Gerencia Comercial / Soporte a clientes | Contactar al cliente para capturar un correo real; aprobar restricción CHECK de formato. |
| C4 | Edad fuera de rango (-3) | 8 | Dominio de edad válida (18 a 120 años) | Gerencia Comercial | Confirmar edad real con el cliente y corregir; aprobar restricción CHECK (edad BETWEEN 18 AND 120). |


## Preguntas

1. **¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 7?**  
   Porque el DBA es **custodio** del dato, no **propietario**. Su responsabilidad es operar, proteger y reportar problemas de calidad, pero no tiene autoridad ni información de negocio para decidir cuál es el valor fiscal correcto de un cliente. Corregirlo por su cuenta alteraría un dato personal/fiscal sin respaldo y rompería la rendición de cuentas.

2. **¿Qué restricción (CHECK, UNIQUE) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?**  
   - **C1 (Duplicado por correo):** Un índice único funcional: CREATE UNIQUE INDEX uq_clientes_correo_lower ON clientes (lower(correo));.
   - **C2 (Formato de RFC):** CHECK (rfc ~ ^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$) (y NOT NULL si el negocio exige RFC obligatorio).
   - **C3 (Formato de correo):** CHECK (correo ~ ^[^@\s]+@[^@\s]+\.[^@\s]+$).
   - **C4 (Edad fuera de rango):** CHECK (edad BETWEEN 18 AND 120).
   - **¿Quién aprueba?** La regla de negocio la aprueba el **Propietario del dato (Gerencia Comercial)**, y su aplicación en producción la autoriza el **Comité de cambios** (ya que puede afectar registros históricos o a la aplicación).

3. **Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará evidencia del cambio?**  
   El disparador **trg_auditoria_clientes**, que inserta automáticamente en **auditoria.cambios_clientes** el momento, usuario de sesión, aplicación, operación (UPDATE), id_cliente y los valores antes/después (valores_antes y valores_despues). Además, con log_statement = mod, la sentencia UPDATE queda registrada en la bitácora del servidor (dba.bitacora).