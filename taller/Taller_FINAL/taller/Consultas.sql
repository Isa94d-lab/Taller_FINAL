USE vtaszfs1;

--1. Seleccionar todos los productos con precio mayor a $50

SELECT * 
FROM Productos 
WHERE precio > 50;

--2. Consultar clientes registrados en una ciudad específica

SELECT Clientes.id, Clientes.nombre, Direcciones.ciudad
FROM Clientes
INNER JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
INNER JOIN Direcciones ON ClientesDireccion.direccion_id = Direcciones.id
WHERE Direcciones.ciudad = 'Vizcaya'; --(El 'NombreDeLaCiudad' se cambiara por el que se desea buscar)

--3. Mostrar empleados contratados en los últimos 2 años

SELECT * 
FROM Empleados 
WHERE fecha_contratacion >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

--4. Seleccionar proveedores que suministran más de 5 productos

SELECT Proveedores.id, Proveedores.nombre, COUNT(Productos.id) AS total_productos
FROM Proveedores
INNER JOIN Productos ON Proveedores.id = Productos.proveedor_id
GROUP BY Proveedores.id, Proveedores.nombre
HAVING total_productos > 5;

--5. Listar clientes que no tienen dirección registrada en ClientesDireccion

SELECT Clientes.id, Clientes.nombre 
FROM Clientes
LEFT JOIN ClientesDireccion ON Clientes.id = ClientesDireccion.cliente_id
WHERE ClientesDireccion.cliente_id IS NULL;
--(No se muestra nada por que todos los clientes ya tienen registrada una DIRECCION)

--6. Calcular el total de ventas por cada cliente

SELECT Clientes.id, Clientes.nombre, SUM(Pedidos.total) AS total_gastado
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
GROUP BY Clientes.id, Clientes.nombre;

--7. Mostrar el salario promedio de los empleados

SELECT AVG(salario) AS salario_promedio 
FROM Empleados;

--8. Consultar el tipo de productos disponibles en TiposProductos

SELECT id, tipo_nombre, descripcion 
FROM TiposProductos;

--9. Seleccionar los 3 productos más caros

SELECT * 
FROM Productos 
ORDER BY precio DESC 
LIMIT 3;

--10. Consultar el cliente con el mayor número de pedidos

SELECT Clientes.id, Clientes.nombre, COUNT(Pedidos.id) AS total_pedidos
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
GROUP BY Clientes.id, Clientes.nombre
ORDER BY total_pedidos DESC
LIMIT 1;



---------------------------

SELECT Pedidos.id, Clientes.nombre, Pedidos.fecha, Pedidos.total
FROM Clientes   
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id;
