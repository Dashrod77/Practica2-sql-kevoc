DELIMITER $$
CREATE TRIGGER TR03
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
IF NEW.monto <= (SELECT saldo FROM multa WHERE multa_id = NEW.multa_id) THEN
UPDATE multa
SET saldo = saldo - NEW.monto, estado = IF(saldo - NEW.monto = 0, 'PAGADA', 'PARCIAL')
WHERE multa_id = NEW.multa_id;
INSERT INTO auditoria (tabla_afectada,valor_nuevo, operacion, descripcion,valor_anterior, registro_id) -- INSERT DE TR04 YA QUE DECIDI FUCIONARLO EN EL TR03
VALUES ('PAGO', JSON_OBJECT('monto', NEW.monto,'multa_id', NEW.multa_id), 'INSERT', 'Nuevo pago registrado', NULL, NEW.pago_id);
ELSE
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'SALDO INSUFICIENTE';
END IF;
END $$
