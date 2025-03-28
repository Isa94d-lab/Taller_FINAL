USE vtaszfs1;

------------- Joins

-- 1. 





------------- Consultas






------------- Consultas Multitabla

--7. Mostrar el salario promedio de los empleados

SELECT AVG(salario)
FROM Empleados;





------------- Subconsultas

-- 3. Listar empleados que ganan más que el salario promedio.

SELECT id, nombre, puesto, salario 
FROM Empleados
WHERE salario > (
    SELECT AVG(salario)
    FROM Empleados
);

-- 5. Listar pedidos cuyo total es mayor al promedio de todos los pedidos.

SELECT id, total
FROM Pedidos
WHERE total > ( 
    SELECT AVG(total)
    FROM Pedidos
);

-- 8. Mostrar clientes que han realizado más pedidos que la media.

SELECT Clientes.id, Clientes.nombre, Pedidos.cliente_id, COUNT(*) AS Total_pedidos
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
GROUP BY cliente_id
HAVING Total_pedidos >= (
    SELECT AVG(Total_pedidos)
    FROM (SELECT cliente_id, COUNT(*) AS Total_pedidos
        FROM Pedidos 
        GROUP BY cliente_id
        ) AS promedio
);


-- 9. Encontrar productos cuyo precio es mayor que el promedio de todos los producto
SELECT id, nombre, precio 
FROM Productos
WHERE precio > (
    SELECT AVG(precio)
    FROM Productos
)




------------- Procedimientos Almacenados

--4. Un procedimiento para calcular el total de ventas de un cliente.

DELIMITER $$

CREATE PROCEDURE Calcular_totalVentas(IN CLIENTE_ID INT)
BEGIN
    SELECT 
        Clientes.id, 
        Clientes.nombre, 
        SUM(Pedidos.total) AS total_ventas
    FROM Clientes
    INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
    WHERE Clientes.id = CLIENTE_ID
    GROUP BY Clientes.id, Clientes.nombre;
END $$

DELIMITER ;

CALL Calcular_totalVentas(2);


------------- Funciones






------------- Triggers