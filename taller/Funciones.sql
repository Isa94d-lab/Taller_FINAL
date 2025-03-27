USE vtaszfs1;

--1. Días transcurridos desde una fecha

DELIMITER $$
CREATE FUNCTION DiasTranscurridos(fecha DATE) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), fecha);
END $$
DELIMITER ;

--Prueba
SELECT DiasTranscurridos('2024-01-01');


--2. Calcular total con impuesto

DELIMITER $$
CREATE FUNCTION CalcularTotalConImpuesto(monto DECIMAL(10,2), impuesto DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN monto * (1 + impuesto / 100);
END $$
DELIMITER ;

--Prueba
SELECT CalcularTotalConImpuesto(100, 19);


--3. Total de pedidos de un cliente

DELIMITER $$
CREATE FUNCTION TotalPedidosCliente(clienteID INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Pedidos WHERE cliente_id = clienteID;
    RETURN total;
END $$
DELIMITER ;

--Prueba
SELECT TotalPedidosCliente(1);


--4. Aplicar descuento a un producto

DELIMITER $$
CREATE FUNCTION AplicarDescuento(productoID INT, porcentaje DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE nuevoPrecio DECIMAL(10,2);
    SELECT precio * (1 - porcentaje / 100) INTO nuevoPrecio FROM Productos WHERE id = productoID;
    RETURN nuevoPrecio;
END $$
DELIMITER ;

--Prueba
SELECT AplicarDescuento(3, 10);


--5. Verificar si un cliente tiene dirección registrada

DELIMITER $$
CREATE FUNCTION ClienteTieneDireccion(clienteID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE tieneDireccion BOOLEAN;
    SELECT COUNT(*) > 0 INTO tieneDireccion FROM ClientesDireccion WHERE cliente_id = clienteID;
    RETURN tieneDireccion;
END $$
DELIMITER ;

--Prueba
SELECT ClienteTieneDireccion(2);


--6. Calcular salario anual de un empleado

DELIMITER $$
CREATE FUNCTION SalarioAnual(empleadoID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE salario DECIMAL(10,2);
    SELECT salario * 12 INTO salario FROM Empleados WHERE id = empleadoID;
    RETURN salario;
END $$
DELIMITER ;

--Prueba
SELECT SalarioAnual(5);


--7. Total de ventas de un tipo de producto

DELIMITER $$
CREATE FUNCTION TotalVentasTipoProducto(tipoID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(dp.cantidad * dp.precio) INTO total
    FROM DetallesPedido dp
    INNER JOIN Productos p ON dp.producto_id = p.id
    WHERE p.tipo_id = tipoID;
    RETURN total;
END $$
DELIMITER ;

--Prueba
SELECT TotalVentasTipoProducto(2);


--8. Obtener nombre de un cliente por ID

DELIMITER $$
CREATE FUNCTION NombreCliente(clienteID INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nombre VARCHAR(100);
    SELECT nombre INTO nombre FROM Clientes WHERE id = clienteID;
    RETURN nombre;
END $$
DELIMITER ;

--Prueba
SELECT NombreCliente(1);


--9. Total de un pedido por ID

DELIMITER $$
CREATE FUNCTION TotalPedido(pedidoID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(cantidad * precio) INTO total FROM DetallesPedido WHERE pedido_id = pedidoID;
    RETURN total;
END $$
DELIMITER ;

--Prueba
SELECT TotalPedido(10);


--10. Verificar si un producto está en inventario

DELIMITER $$
CREATE FUNCTION ProductoEnInventario(productoID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE enInventario BOOLEAN;
    SELECT COUNT(*) > 0 INTO enInventario FROM DetallesPedido WHERE producto_id = productoID;
    RETURN enInventario;
END $$
DELIMITER ;

--Prueba
SELECT ProductoEnInventario(4);

