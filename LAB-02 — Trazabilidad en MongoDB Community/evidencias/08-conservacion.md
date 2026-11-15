# 14. Actividad 8 — Conservación: exportar antes de perder

**1. Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.**  
* **Reinicio del servicios:** Al reiniciar el servidor, el nivel del perfilador regresa por defecto a `0` (apagado) y el búfer en memoria de `getLog` se vacía por completo.
* **Sobrescritura circular en:** Al tratarse de una colección limitada (*capped collection*) de 1 MB por defecto, una vez que alcanza su capacidad máxima los registros nuevos sobrescriben automáticamente a los más antiguos.
* **Rotación en memoria de:** El comando `getLog` conserva únicamente los últimos 1,024 eventos en memoria RAM; si no se configura escritura en archivo, la actividad continua desplaza y descarta los eventos anteriores.

---

**2. ¿Por qué el tamaño de 1 MB de `system.profile` es un problema de conservación y no solo de espacio?**  
Porque al llenarse ese megabyte, MongoDB no detiene la operación ni genera alertas, sino que elimina silenciosamente las entradas más antiguas para dar cabida a las nuevas. En sistemas con alta carga de transacciones o bajo nivel 2 de perfilado, los registros de un incidente de seguridad pueden sobrescribirse en cuestión de minutos antes de ser recolectados o analizados.

---

**3. ¿Por qué `getLog` sirve para interpretar pero no para conservar?**  
Porque `getLog` consulta un búfer volátil en memoria RAM limitado a 1,024 líneas que desaparece por completo ante cualquier reinicio o caída del servicio. Resulta útil para inspeccionar y filtrar eventos recientes en tiempo real durante un diagnóstico, pero para conservar evidencia forense o cumplir políticas de retención es indispensable persistir la bitácora en disco mediante `systemLog.path` o exportarla periódicamente hacia un repositorio externo.