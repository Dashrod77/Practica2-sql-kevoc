DELIMITER $$
CREATE TRIGGER TR02_INSERT
AFTER INSERT ON detalle_prestamo
FOR EACH ROW
BEGIN
UPDATE equipo
SET estado = 'PRESTADO'
WHERE equipo_id = NEW.equipo_id AND estado = 'DISPONIBLE';
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER TR02_UPDATE
AFTER UPDATE ON prestamo
FOR EACH ROW
BEGIN
  IF NEW.estado = 'DEVUELTO' THEN
UPDATE equipo
SET estado = 'DISPONIBLE'
  WHERE equipo_id IN (SELECT equipo_id FROM detalle_prestamo WHERE prestamo_id = NEW.prestamo_id);
  END IF ;
END $$
DELIMITER ;
