USE vtaszfs1;

--1. Listar todos los pedidos y el cliente asociado

SELECT Pedidos.id, Clientes.nombre AS cliente, Pedidos.fecha, Pedidos.total
FROM Pedidos
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id;

--2. Mostrar la ubicación de cada cliente en sus pedidos

SELECT Pedidos.id, Clientes.nombre AS cliente, Direcciones.direccion, Direcciones.ciudad, Direcciones.estado, Direcciones.pais
FROM Pedidos
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id
INNER JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
INNER JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id;

--3. Listar productos junto con el proveedor y tipo de producto

SELECT Productos.nombre AS producto, Proveedores.nombre AS proveedor, TiposProductos.tipo_nombre AS tipo_producto
FROM Productos
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id;

--4. Consultar todos los empleados que gestionan pedidos de clientes en una ciudad específica

SELECT DISTINCT Empleados.id, Empleados.nombre, Empleados.puesto
FROM Empleados
INNER JOIN Pedidos ON Empleados.id = Pedidos.empleado_id
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id
INNER JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
INNER JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id
WHERE Direcciones.ciudad = 'Segovia';

--5. Consultar los 5 productos más vendidos

SELECT Productos.nombre, SUM(DetallesPedido.cantidad) AS total_vendido
FROM DetallesPedido
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
GROUP BY Productos.nombre
ORDER BY total_vendido DESC
LIMIT 5;

--6. Obtener la cantidad total de pedidos por cliente y ciudad

SELECT Clientes.nombre AS cliente, Direcciones.ciudad, COUNT(Pedidos.id) AS total_pedidos
FROM Pedidos
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id
INNER JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
INNER JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id
GROUP BY Clientes.nombre, Direcciones.ciudad;

--7. Listar clientes y proveedores en la misma ciudad

SELECT Clientes.nombre AS cliente, Proveedores.nombre AS proveedor, Direcciones.ciudad
FROM ClientesDireccion
INNER JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id
INNER JOIN Clientes ON ClientesDireccion.cliente_id = Clientes.id
INNER JOIN ProveedoresDireccion ON Direcciones.id = ProveedoresDireccion.direccion_id
INNER JOIN Proveedores ON ProveedoresDireccion.proveedor_id = Proveedores.id;

--8. Mostrar el total de ventas agrupado por tipo de producto

SELECT TiposProductos.tipo_nombre, SUM(DetallesPedido.cantidad * DetallesPedido.precio) AS total_ventas
FROM DetallesPedido
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id
GROUP BY TiposProductos.tipo_nombre;

--9. Listar empleados que gestionan pedidos de productos de un proveedor específico

SELECT DISTINCT Empleados.id, Empleados.nombre, Proveedores.nombre AS proveedor
FROM Empleados
INNER JOIN Pedidos ON Empleados.id = Pedidos.empleado_id
INNER JOIN DetallesPedido ON Pedidos.id = DetallesPedido.pedido_id
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id
WHERE Proveedores.nombre = 'Benavent, Amor and Casanova';

--10. Obtener el ingreso total de cada proveedor a partir de los productos vendidos

SELECT Proveedores.nombre AS proveedor, SUM(DetallesPedido.cantidad * DetallesPedido.precio) AS ingreso_total
FROM Productos
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id
INNER JOIN DetallesPedido ON Productos.id = DetallesPedido.producto_id
GROUP BY Proveedores.nombre;
