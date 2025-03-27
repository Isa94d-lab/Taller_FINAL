USE vtaszfs1;

-- 1. Consultar el producto más caro en cada categoría.
SELECT * FROM Productos p
WHERE precio = (SELECT MAX(precio) FROM Productos WHERE tipo_id = p.tipo_id);

-- 2. Encontrar el cliente con mayor total en pedidos.
SELECT cliente_id, SUM(total) AS total_pedidos
FROM Pedidos
GROUP BY cliente_id
HAVING total_pedidos = (SELECT MAX(total_pedidos) 
                        FROM (SELECT cliente_id, SUM(total) AS total_pedidos 
                              FROM Pedidos GROUP BY cliente_id) AS subquery);

-- 3. Listar empleados que ganan más que el salario promedio.
SELECT * FROM Empleados 
WHERE salario > (SELECT AVG(salario) FROM Empleados);

-- 4. Consultar productos que han sido pedidos más de 5 veces.
SELECT producto_id, COUNT(*) AS total_pedidos
FROM DetallesPedido
GROUP BY producto_id
HAVING total_pedidos > 5;

-- 5. Listar pedidos cuyo total es mayor al promedio de todos los pedidos.
SELECT * FROM Pedidos
WHERE total > (SELECT AVG(total) FROM Pedidos);

-- 6. Seleccionar los 3 proveedores con más productos.
SELECT proveedor_id, COUNT(*) AS total_productos
FROM Productos
GROUP BY proveedor_id
ORDER BY total_productos DESC
LIMIT 3;

-- 7. Consultar productos con precio superior al promedio en su tipo.
SELECT * FROM Productos p
WHERE precio > (SELECT AVG(precio) FROM Productos WHERE tipo_id = p.tipo_id);

-- 8. Mostrar clientes que han realizado más pedidos que la media.
SELECT Pedidos.cliente_id, Clientes.nombre,  COUNT(*) AS total_pedidos
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
GROUP BY cliente_id
HAVING total_pedidos > (SELECT AVG(total_pedidos) 
                        FROM (SELECT cliente_id, COUNT(*) AS total_pedidos 
                              FROM Pedidos GROUP BY cliente_id) AS promedio);

-- 9. Encontrar productos cuyo precio es mayor que el promedio de todos los productos.
SELECT * FROM Productos 
WHERE precio > (SELECT AVG(precio) FROM Productos);

-- 10. Mostrar empleados cuyo salario es menor al promedio del departamento.
SELECT * FROM Empleados e
WHERE salario < (SELECT AVG(salario) 
                 FROM Empleados e2 
                 WHERE e2.puesto = e.puesto);