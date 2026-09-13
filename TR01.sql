
DELIMITER $$
CREATE TRIGGER TR01_INSERT
AFTER INSERT ON equipo
FOR EACH ROW
BEGIN
INSERT INTO auditoria (tabla_afectada, operacion, registro_id, valor_anterior, valor_nuevo, descripcion)
VALUES ('equipo', 'INSERT', NEW.equipo_id, NULL, JSON_OBJECT('equipo_id',NEW.equipo_id, 'numero_serie', NEW.numero_serie, 'activo', NEW.activo), 'se a insertado un equipo');
END $$

DELIMITER ;



DELIMITER $$
CREATE TRIGGER TR01_UPDATE
AFTER UPDATE ON equipo
FOR EACH ROW
BEGIN
UPDATE equipo
END $$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER TR01_DELETE
AFTER DELETE ON equipo
FOR EACH ROW
BEGIN
END $$
DELIMITER ;
