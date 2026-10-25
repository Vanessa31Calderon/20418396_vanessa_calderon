# Actividad 1 — Inventario y finalidad de los datos

<table>
  <thead>
    <tr>
      <th>Campo</th>
      <th>¿Es dato personal?</th>
      <th>Finalidad principal</th>
      <th>¿Es necesario?</th>
      <th>Nivel de acceso</th>
      <th>Retención</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>id</td>
      <td>No</td>
      <td>Clave primaria de control interno</td>
      <td>Sí</td>
      <td>DBA, operaciones, analítica</td>
      <td>Indefinido (mientras exista el registro)</td>
    </tr>
    <tr>
      <td>nombre</td>
      <td>Sí</td>
      <td>Identificación del cliente para atención y facturación</td>
      <td>Sí</td>
      <td>Atención al cliente, facturación</td>
      <td>Duración de la relación comercial + 5 años</td>
    </tr>
    <tr>
      <td>correo</td>
      <td>Sí</td>
      <td>Canal de comunicación principal y envío de comprobantes</td>
      <td>Sí</td>
      <td>Atención al cliente, facturación</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td>telefono</td>
      <td>Sí</td>
      <td>Canal alternativo de soporte y confirmación</td>
      <td>Sí</td>
      <td>Atención al cliente</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td>rfc</td>
      <td>Sí</td>
      <td>Emisión de comprobantes fiscales (CFDI)</td>
      <td>Sí</td>
      <td>Facturación</td>
      <td>5 años (obligación CFF)</td>
    </tr>
    <tr>
      <td>edad</td>
      <td>Sí</td>
      <td>Análisis estadístico y segmentación comercial</td>
      <td>No para soporte; sí para analítica</td>
      <td>Analítica</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td>ciudad</td>
      <td>Sí</td>
      <td>Logística de entrega y estadísticas de mercado</td>
      <td>Sí</td>
      <td>Atención al cliente, analítica</td>
      <td>Duración de la relación comercial</td>
    </tr>
    <tr>
      <td>codigo_postal</td>
      <td>Sí</td>
      <td>Validación de domicilio fiscal y entrega</td>
      <td>Sí</td>
      <td>Facturación, logística, analítica</td>
      <td>Duración de la relación comercial + 5 años</td>
    </tr>
    <tr>
      <td>fecha_alta</td>
      <td>No</td>
      <td>Auditoría interna y antigüedad del cliente</td>
      <td>Sí</td>
      <td>DBA, facturación, analítica</td>
      <td>Indefinido (mientras exista el registro)</td>
    </tr>
  </tbody>
</table>

