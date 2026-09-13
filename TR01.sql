
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
INSERT INTO auditoria (tabla_afectada, operacion, registro_id, valor_anterior, valor_nuevo, descripcion)
VALUES ('equipo', 'UPDATE', NEW.equipo_id, JSON_OBJECT('equipo_id', OLD.equipo_id, 'numero_serie', OLD.numero_serie, 'activo', OLD.activo), JSON_OBJECT('equipo_id', NEW.equipo_id, 'numero_serie', NEW.numero_serie, 'activo', NEW.activo), 'se a actualizado un equipo');
END $$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER TR01_DELETE
AFTER DELETE ON equipo
FOR EACH ROW
BEGIN
INSERT INTO auditoria (tabla_afectada, operacion, registro_id, valor_anterior, valor_nuevo, descripcion)
VALUES ('equipo', 'DELETE', OLD.equipo_id, JSON_OBJECT('equipo_id', OLD.equipo_id, 'numero_serie', OLD.numero_serie, 'activo',OLD.activo), NULL, 'se a eliminado un equipo');
END $$
DELIMITER ;
