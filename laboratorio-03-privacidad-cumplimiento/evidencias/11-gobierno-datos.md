# Actividad 11 — Diseñar una matriz de gobierno de datos


<table>
  <thead>
    <tr>
      <th>Dato</th>
      <th>Finalidad</th>
      <th>Responsable (Data Owner)</th>
      <th>Usuarios autorizados</th>
      <th>Protección</th>
      <th>Retención</th>
      <th>Acción al finalizar</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>nombre</b></td>
      <td>Identificación del cliente para soporte y facturación</td>
      <td>Gerente de Operaciones</td>
      <td>Atención al cliente, Facturación</td>
      <td>Control de acceso <b>RBAC</b></td>
      <td>Duración de la relación comercial + 5 años</td>
      <td>Eliminación / Anonimización</td>
    </tr>
    <tr>
      <td><b>correo</b></td>
      <td>Canal principal de comunicación y comprobantes</td>
      <td>Gerente de Operaciones / Marketing</td>
      <td>Atención al cliente, Facturación</td>
      <td>Control de acceso <b>RBAC</b> y cifrado en tránsito (<b>TLS</b>)</td>
      <td>Duración de la relación comercial</td>
      <td>Supresión inmediata tras solicitud de cancelación</td>
    </tr>
    <tr>
      <td><b>telefono</b></td>
      <td>Contacto alternativo y soporte postventa</td>
      <td>Gerente de Operaciones</td>
      <td>Atención al cliente</td>
      <td>Control de acceso <b>RBAC</b></td>
      <td>Duración de la relación comercial</td>
      <td>Supresión inmediata</td>
    </tr>
    <tr>
      <td><b>rfc</b></td>
      <td>Emisión de comprobantes fiscales (CFDI)</td>
      <td>Gerente de Finanzas</td>
      <td>Facturación</td>
      <td>Cifrado simétrico en reposo (<b>pgp_sym_encrypt</b>)</td>
      <td>5 años (Código Fiscal de la Federación)</td>
      <td>Bloqueo y posterior destrucción irrecuperable</td>
    </tr>
    <tr>
      <td><b>edad</b></td>
      <td>Segmentación demográfica y análisis de mercado</td>
      <td>Gerente de Inteligencia de Negocios</td>
      <td>Analítica</td>
      <td>Anonimización vía vista agregada (<b>k-anonimato</b>)</td>
      <td>Conservación en formato agregado</td>
      <td>Conservar únicamente métricas agregadas</td>
    </tr>
    <tr>
      <td><b>ciudad</b></td>
      <td>Logística de entrega y estadísticas de zona</td>
      <td>Gerente de Logística</td>
      <td>Atención al cliente, Analítica</td>
      <td>Control de acceso <b>RBAC</b> y vistas agrupadas</td>
      <td>Duración de la relación comercial + 3 años</td>
      <td>Anonimización de zona geográfica</td>
    </tr>
    <tr>
      <td><b>codigo_postal</b></td>
      <td>Validación de domicilio fiscal y logística</td>
      <td>Gerente de Logística / Finanzas</td>
      <td>Facturación, Atención al cliente</td>
      <td>Control de acceso <b>RBAC</b></td>
      <td>Duración de la relación comercial + 5 años</td>
      <td>Eliminación segura</td>
    </tr>
  </tbody>
</table>

