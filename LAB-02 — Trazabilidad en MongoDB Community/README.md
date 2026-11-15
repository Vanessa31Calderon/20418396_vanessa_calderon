# LAB-02 — Trazabilidad en MongoDB Community

## Despliegue y versión del servidor

* **Edición:** MongoDB Community Edition
* **Versión instalada:** 8.0.x — reemplaza con el resultado de db.version en tu consola
* **Sistema operativo y modalidad:** Despliegue local como servicio nativo en Windows ejecutándose en el puerto 27017 con control de acceso y autenticación habilitados.
* **Herramientas utilizadas:** MongoDB Compass con su consola mongosh integrada para la administración de usuarios, perfilador y consultas, junto con PowerShell para la gestión del servicio y cálculo de firmas SHA-256.

## Limitación principal verificada

MongoDB Community Edition no incluye auditoría nativa de seguridad. Durante la práctica se comprobó que los comandos administrativos de asignación y revocación de roles no quedan registrados ni en la colección system.profile ni en la bitácora del servidor, por lo que fue necesario implementar una colección dedicada para almacenar instantáneas periódicas de privilegios como control compensatorio.