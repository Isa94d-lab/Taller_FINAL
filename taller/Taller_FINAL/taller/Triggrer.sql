USE vtaszfs1;

--1. Registrar cambios de salario en HistorialSalarios

CREATE TRIGGER Trg_HistorialSalarios
BEFORE UPDATE ON Empleados
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO HistorialSalarios (empleado_id, salario_anterior, salario_nuevo, fecha_cambio)
        VALUES (OLD.id, OLD.salario, NEW.salario, NOW());
    END IF;
END;

--2. Evitar borrar productos con pedidos activos

CREATE TRIGGER Trg_EvitarBorrarProductos
BEFORE DELETE ON Productos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM DetallesPedido WHERE producto_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un producto con pedidos activos';
    END IF;
END;


--3. Registrar cambios en Pedidos en HistorialPedidos

CREATE TRIGGER Trg_HistorialPedidos
AFTER UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos (pedido_id, total_anterior, total_nuevo, fecha_cambio)
    VALUES (OLD.id, OLD.total, NEW.total, NOW());
END;


--4. Actualizar inventario al registrar un pedido

CREATE TRIGGER Trg_ActualizarInventario
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Productos 
    SET stock = stock - NEW.cantidad 
    WHERE id = NEW.producto_id;
END;


--5. Evitar actualizaciones de precio menores a $1

CREATE TRIGGER Trg_EvitarPrecioMenor
BEFORE UPDATE ON Productos
FOR EACH ROW
BEGIN
    IF NEW.precio < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio no puede ser menor a $1';
    END IF;
END;

--6. Registrar fecha de creación de un pedido en HistorialPedidos

CREATE TRIGGER Trg_RegistroFechaPedido
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos (pedido_id, fecha_creacion)
    VALUES (NEW.id, NOW());
END;

--7. Mantener el precio total de un pedido en Pedidos

CREATE TRIGGER Trg_ActualizarTotalPedido
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos 
    SET total = (SELECT SUM(cantidad * precio_unitario) 
                 FROM DetallesPedido 
                 WHERE pedido_id = NEW.pedido_id)
    WHERE id = NEW.pedido_id;
END;


--8. Validar que UbicacionCliente no esté vacío al crear un cliente

DELIMITER //
CREATE TRIGGER Trg_ValidarUbicacionCliente
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN
    DECLARE dir_existe INT;

    -- Verificar si el cliente tiene al menos una dirección registrada en ClientesDireccion
    SELECT COUNT(*) INTO dir_existe
    FROM ClientesDireccion
    WHERE cliente_id = NEW.id;

    -- Si no tiene dirección, lanzar un error
    IF dir_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente debe tener al menos una dirección registrada';
    END IF;
END;

DELIMITER ;


INSERT INTO ClientesDireccion (cliente_id, direccion_id)
VALUES (
    (INSERT INTO Clientes (nombre, email) 
     VALUES ('Nuevo Cliente2', 'cliente2@email.com') RETURNING id),
    
    (INSERT INTO Direcciones (direccion, ciudad, estado, codigo_postal, pais) 
     VALUES ('Calle Falsa 123', 'Ciudad X', 'Estado Y', '12345', 'País Z') RETURNING id)
);


--Prueba
INSERT INTO Clientes (nombre, email) VALUES ('Juan Pérez', 'juan@example.com');
SET @cliente_id = LAST_INSERT_ID();
INSERT INTO Direcciones (direccion, ciudad, estado, codigo_postal, pais) 
VALUES ('Calle 123', 'Ciudad X', 'Estado Y', '12345', 'País Z');
SET @direccion_id = LAST_INSERT_ID();
INSERT INTO ClientesDireccion (cliente_id, direccion_id) VALUES (@cliente_id, @direccion_id);



--9. Registrar cambios en Proveedores en LogActividades

CREATE TRIGGER Trg_LogModificacionProveedores
AFTER UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO LogActividades (tabla, operacion, usuario, fecha)
    VALUES ('Proveedores', 'UPDATE', CURRENT_USER(), NOW());
END;


--10. Registrar cambios en contratos de empleados en HistorialContratos
DELIMITER //
CREATE TRIGGER Trg_HistorialContratos
BEFORE UPDATE ON Empleados
FOR EACH ROW
BEGIN
    -- Insertar el historial solo si el puesto cambió
    IF OLD.puesto <> NEW.puesto THEN
        INSERT INTO HistorialContratos (empleado_id, puesto_anterior, puesto_nuevo, fecha_cambio)
        VALUES (
            OLD.id, 
            OLD.puesto, 
            NEW.puesto, 
            NOW()
        );
    END IF;
END;
//
DELIMITER ;
