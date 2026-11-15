use comercial;

// Actividad 1
db.getProfilingStatus();
db.getUsers();
db.runCommand({ connectionStatus: 1 });

// Actividad 2
db.clientes.updateOne({ _id: 1 }, { $set: { rfc: "GAGM850101ABC" } });
db.system.profile.countDocuments();

// Actividad 3
db.setProfilingLevel(2);
db.getProfilingStatus();
db.clientes.find({ _id: 1 });
db.clientes.updateOne({ _id: 1 }, { $set: { rfc: "GAGM850101XYZ" } });
db.system.profile.find(
  {},
  { op: 1, ns: 1, user: 1, client: 1, appName: 1, ts: 1, command: 1 }
).sort({ ts: -1 });

// Actividad 4
db.setProfilingLevel(0);
db.system.profile.drop();
db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
});
db.getProfilingStatus();
db.clientes.find({});
db.clientes.updateOne({ _id: 1 }, { $set: { telefono: "6670000000" } });
db.system.profile.find(
  {},
  { op: 1, ns: 1, user: 1, client: 1, appName: 1, ts: 1, "command.q": 1, "command.u": 1 }
);

// Actividad 5
const bitacora = () => db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l));

bitacora()
  .filter(e => e.msg === "Failed to authenticate")
  .map(e => ({ t: e.t, ctx: e.ctx, attr: e.attr }));

bitacora()
  .filter(e => e.msg === "Successfully authenticated")
  .map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.user, db: e.attr.db, client: e.attr.client }));

// Actividad 6
bitacora()
  .filter(e => e.msg === "Profiler settings changed")
  .map(e => ({ t: e.t, ctx: e.ctx, attr: e.attr }));

bitacora()
  .filter(e => e.ctx === "conn45" && e.msg === "Successfully authenticated")
  .map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.user, db: e.attr.db, client: e.attr.client }));

// Actividad 7
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
});

db.setProfilingLevel(2);
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);

db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } });
bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length;

db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
});

db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 });

db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } });

// Actividad 8
const fs = require("fs");

fs.writeFileSync(
  "C:/Users/vanes/Documents/20418396_vanessa_calderon/unidad-03/LAB-02 — Trazabilidad en MongoDB Community/evidencias/system-profile.json",
  EJSON.stringify(
    db.system.profile.find(
      {},
      { op: 1, ns: 1, user: 1, client: 1, appName: 1, ts: 1, "command.q": 1, "command.u": 1 }
    ).toArray(),
    null,
    2
  )
);

fs.writeFileSync(
  "C:/Users/vanes/Documents/20418396_vanessa_calderon/unidad-03/LAB-02 — Trazabilidad en MongoDB Community/evidencias/bitacora-mongod.log",
  db.adminCommand({ getLog: "global" }).log.join("\n")
);

db.getProfilingStatus();
db.system.profile.countDocuments();