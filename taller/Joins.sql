USE vtaszfs1;

-- 1. Obtener la lista de todos los pedidos con los nombres de clientes usando INNER JOIN

SELECT Pedidos.id AS pedido_id, Clientes.nombre AS cliente, Pedidos.fecha, Pedidos.total
FROM Pedidos
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id;

--2. Listar los productos y proveedores que los suministran con INNER JOIN

SELECT Productos.nombre AS producto, Proveedores.nombre AS proveedor, Productos.precio
FROM Productos
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id;

--3. Mostrar los pedidos y las ubicaciones de los clientes con LEFT JOIN

SELECT Pedidos.id AS pedido_id, Clientes.nombre AS cliente, Direcciones.direccion, Direcciones.ciudad, Direcciones.estado
FROM Pedidos
LEFT JOIN Clientes ON Pedidos.cliente_id = Clientes.id
LEFT JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
LEFT JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id;

--4. Consultar los empleados que han registrado pedidos, incluyendo empleados sin pedidos ( LEFT JOIN )

SELECT Empleados.nombre AS empleado, Empleados.puesto, Pedidos.id AS pedido_id, Pedidos.fecha
FROM Empleados
LEFT JOIN Pedidos ON Empleados.id = Pedidos.empleado_id;

--5. Obtener el tipo de producto y los productos asociados con INNER JOIN

SELECT TiposProductos.tipo_nombre AS tipo_producto, Productos.nombre AS producto
FROM Productos
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id;

--6. Listar todos los clientes y el número de pedidos realizados con COUNT y GROUP BY 

SELECT Clientes.nombre AS cliente, COUNT(Pedidos.id) AS numero_pedidos
FROM Clientes
LEFT JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
GROUP BY Clientes.id, Clientes.nombre;

--7. Combinar Pedidos y Empleados para mostrar qué empleados gestionaron pedidos específicos.

SELECT Pedidos.id AS pedido_id, Pedidos.fecha, Empleados.nombre AS empleado
FROM Pedidos
INNER JOIN Empleados ON Pedidos.empleado_id = Empleados.id;

--8. Mostrar productos que no han sido pedidos ( RIGHT JOIN )

SELECT Productos.nombre AS producto, Productos.precio
FROM Productos
LEFT JOIN DetallesPedido ON Productos.id = DetallesPedido.producto_id
WHERE DetallesPedido.id IS NULL;

--9. Mostrar el total de pedidos y ubicación de clientes usando múltiples JOIN

SELECT Clientes.nombre AS cliente, COUNT(Pedidos.id) AS total_pedidos, Direcciones.direccion, Direcciones.ciudad
FROM Clientes
LEFT JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
LEFT JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
LEFT JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id
GROUP BY Clientes.id, Clientes.nombre, Direcciones.direccion, Direcciones.ciudad;

--10. Unir Proveedores, Productos, y TiposProductos para un listado completo de inventario

SELECT Proveedores.nombre AS proveedor, Productos.nombre AS producto, Productos.precio, TiposProductos.tipo_nombre AS tipo_producto
FROM Productos
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id;
