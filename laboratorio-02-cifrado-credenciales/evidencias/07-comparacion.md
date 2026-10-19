# 14. Actividad 7 — Comparar protección en reposo y protección en tránsito

**Objetivo:** Diferenciar los mecanismos de protección criptográfica adecuados dependiendo del estado de la información (en reposo, en tránsito o credenciales) y aplicarlos correctamente al escenario correspondiente.
---

<table>
  <thead>
    <tr>
      <th>Situación</th>
      <th>Mecanismo apropiado</th>
      <th>¿Qué protege?</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Contraseña de usuario</td>
      <td>Derivación de claves / Hashing (crypt() con gen_salt('bf'))</td>
      <td>Protege la credencial almacenada en la base de datos evitando que pueda ser revertida o leída en texto claro si la tabla llega a ser expuesta.</td>
    </tr>
    <tr>
      <td>RFC almacenado en una tabla</td>
      <td>Cifrado en reposo simétrico (pgp_sym_encrypt())</td>
      <td>Protege el dato confidencial en el almacenamiento, permitiendo recuperarlo únicamente con la clave correcta cuando existe una autorización válida.</td>
    </tr>
    <tr>
      <td>Consulta enviada desde un cliente al servidor</td>
      <td>Cifrado en tránsito mediante TLS/SSL (sslmode=require / verify-full)</td>
      <td>Protege la confidencialidad e integridad del canal de comunicación, evitando que interceptores en la red puedan leer consultas, datos o credenciales.</td>
    </tr>
    <tr>
      <td>Respaldo de una base de datos</td>
      <td>Cifrado de archivos/volúmenes o cifrado nativo de backups</td>
      <td>Protege la base de datos completa guardada en disco contra extracciones no autorizadas o la pérdida del medio físico de almacenamiento.</td>
    </tr>
    <tr>
      <td>Clave criptográfica</td>
      <td>Almacenamiento fuera de la BD en un Gestor de Secretos (Vault o variables de entorno)</td>
      <td>Protege la llave de cifrado contra su divulgación en código fuente, repositorios Git, archivos de registro (logs) o scripts SQL.</td>
    </tr>
  </tbody>
</table>

---
**Análisis:** 
Al comparar las distintas situaciones, se observa que no existe una solución única para proteger toda la información. Las contraseñas requieren un mecanismo irreversible (hash), los datos sensibles necesitan cifrado reversible con gestión de claves, y las consultas requieren seguridad en el canal de red (TLS).

**Conclusión:** 
La seguridad de una base de datos debe diseñarse en capas (defensa en profundidad). Implementar un mecanismo correcto para los datos en reposo no servirá de nada si las conexiones viajan en texto plano o si las llaves de cifrado se exponen accidentalmente en un repositorio.