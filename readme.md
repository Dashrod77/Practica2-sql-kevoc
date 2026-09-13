TR01 — Auditoría de equipos

Qué debes hacer y entregar: Tres triggers sobre equipo (AFTER INSERT, AFTER UPDATE, AFTER DELETE) que registren en auditoria: tabla_afectada='equipo', la operación, registro_id con NEW.equipo_id (u OLD en DELETE), valor_anterior/valor_nuevo como JSON (JSON_OBJECT) y descripcion. Documenta cuándo usas NEW y cuándo OLD.
Probar:
INSERT INTO equipo (categoria_id, ubicacion_id, codigo_inventario, numero_serie, nombre, fecha_adquisicion, costo_adquisicion, estado, condicion) VALUES (1,1,'INV-TEST-9999','SN-TEST-9999','Equipo Test Trigger','2026-03-01',1000,'DISPONIBLE','BUENA'); SELECT * FROM auditoria WHERE tabla_afectada='equipo' ORDER BY auditoria_id DESC LIMIT 3; UPDATE equipo SET estado='MANTENIMIENTO' WHERE codigo_inventario='INV-TEST-9999'; SELECT * FROM auditoria WHERE registro_id=(SELECT equipo_id FROM equipo WHERE codigo_inventario='INV-TEST-9999') ORDER BY auditoria_id DESC LIMIT 2; DELETE FROM equipo WHERE codigo_inventario='INV-TEST-9999'; SELECT * FROM auditoria WHERE tabla_afectada='equipo' ORDER BY auditoria_id DESC LIMIT 1; -- Limpiar test

TR02 — Actualización de estado del equipo por préstamo

Qué debes hacer y entregar: Un trigger que al crear un detalle_prestamo marque ese equipo PRESTADO; y otro que al pasar un prestamo a DEVUELTO regrese a DISPONIBLE todos los equipos de ese préstamo (vía detalle_prestamo). Evita el re-disparo si el préstamo ya estaba DEVUELTO (compara OLD vs NEW). Documenta si disparas sobre detalle_prestamo o sobre prestamo — ambas son válidas si demuestras el cambio.
Casos de prueba (usa datos semilla):
-- Equipo 1 está DISPONIBLE (INV-COM-0001) SELECT estado FROM equipo WHERE equipo_id=1; -- DISPONIBLE -- Simular préstamo: crear prestamo ACTIVO + detalle (debe disparar PRESTADO) INSERT INTO prestamo (usuario_id, fecha_prestamo, fecha_devolucion_programada, estado) VALUES (1, NOW(), NOW()+INTERVAL 3 DAY, 'ACTIVO'); SET @pid = LAST_INSERT_ID(); INSERT INTO detalle_prestamo (prestamo_id, equipo_id) VALUES (@pid, 1); SELECT estado FROM equipo WHERE equipo_id=1; -- debe ser PRESTADO -- Devolver UPDATE prestamo SET estado='DEVUELTO', fecha_devolucion_real=NOW() WHERE prestamo_id=@pid; SELECT estado FROM equipo WHERE equipo_id=1; -- debe volver a DISPONIBLE

Error esperado: si el trigger no filtra OLD.estado, una segunda actualización a DEVUELTO volvería a disparar. Validar.

TR03 — Actualización de multa tras pago

Qué debes hacer y entregar: Un trigger AFTER INSERT ON pago que valide que el monto no excede el saldo (aborta con SIGNAL si sí), reste del saldo y actualice el estado a PAGADA si llega a 0 o PARCIAL si queda saldo. Debe respetar CHECK (saldo <= monto) y CHECK (saldo >= 0).
Probar con casos semilla:
-- Multa 2: PENDIENTE 100/100 SELECT multa_id, monto, saldo, estado FROM multa WHERE multa_id=2; INSERT INTO pago (multa_id, usuario_id, monto, metodo_pago) VALUES (2, 2, 40, 'EFECTIVO'); SELECT multa_id, monto, saldo, estado FROM multa WHERE multa_id=2; -- saldo 60 PARCIAL INSERT INTO pago (multa_id, usuario_id, monto, metodo_pago) VALUES (2, 2, 60, 'EFECTIVO'); SELECT multa_id, monto, saldo, estado FROM multa WHERE multa_id=2; -- saldo 0 PAGADA -- Pago que excede debe fallar INSERT INTO pago (multa_id, usuario_id, monto, metodo_pago) VALUES (2, 2, 10, 'EFECTIVO'); -- debe dar error 45000

TR04 — Auditoría de pagos

Qué debes hacer y entregar: Un trigger AFTER INSERT ON pago que registre en auditoria (tabla_afectada='pago', JSON del monto y la multa). Puede fusionarse con TR03 si lo documentas; si lo dejas separado, explica el orden de ejecución.
Si ya existe TR03 AFTER INSERT ON pago, MySQL permite múltiples triggers en mismo evento (orden FOLLOWS/PRECEDES). El alumno debe mostrar SHOW TRIGGERS y explicar orden, o fusionar lógica.
Probar:
SELECT COUNT(*) FROM auditoria WHERE tabla_afectada='pago'; INSERT INTO pago (multa_id, usuario_id, monto, metodo_pago) VALUES (5, 24, 10, 'EFECTIVO'); SELECT * FROM auditoria WHERE tabla_afectada='pago' ORDER BY auditoria_id DESC LIMIT 2;
