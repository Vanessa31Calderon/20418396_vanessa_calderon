**1. El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?**
Queda registrada de forma permanente e inmutable en los eventos 2 (INSERT) y 3 (DELETE) de la tabla auditoria.cambios_clientes. El objeto completo de Pedro Ruiz (nombre, correo, RFC, edad, ciudad, código postal) se conserva dentro de la estructura JSONB del campo valores_despues del evento 2 y en el campo valores_antes del evento 3.

**2. ¿Por qué ip_cliente está vacía en los eventos 2 y 3?**
Porque las sentencias de inserción y borrado del administrador (postgres) se ejecutaron localmente mediante un socket de dominio Unix (Unix domain socket), omitiendo la pila de red TCP/IP. Al no existir una interfaz de red involucrada, la función inet_client_addr() devuelve NULL.

**3. La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?**

* Conflicto identificado: Se presenta una tensión estructural entre el Derecho al Olvido / Retención de Datos, que exige purgar la información personal cuando deja de ser necesaria, y la Trazabilidad y No Repudio de Auditoría, que exige conservar un registro inalterable de los cambios realizados. Si los datos personales son eliminados de la tabla operacional pero permanecen retenidos indefinidamente en los logs JSONB de auditoría, se incurre en un incumplimiento normativo.

* Resolución del Conflicto: Debe ser resuelto conjuntamente por el Oficial de Privacidad / Departamento de Gobierno de Datos y Legal, en coordinación con el Oficial de Seguridad de la Información y DBA. La solución radica en definir una política formal de retención que aplique ciclos de vida independientes: purgado o anonimización criptográfica de la auditoría (por ejemplo, hash del RFC) tras cumplir el plazo legal obligatorio de retención de logs.