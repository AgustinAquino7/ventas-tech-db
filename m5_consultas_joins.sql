-- Motor utilizado: SQL Server (SSMS)
-- Base de datos: Ventas_Tech_DB
USE Ventas_Tech_DB;

-- =====================================================
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- =====================================================
SELECT
    v.id_venta,
    v.fecha_venta,
    v.id_cliente,
    c.nombre                         AS nombre_cliente,
    c.ciudad                         AS ciudad_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario   AS total_venta
FROM ventas AS v
INNER JOIN clientes   AS c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  AS p   ON v.id_producto  = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
-- Hallazgo: las 10 ventas se cruzan con cliente, producto y categoría sin perder ninguna fila.
-- Hallazgo: Computación explica el 76,8% de la facturación (4.950 de 6.444) y Buenos Aires y Tucumán juntas el 73,6% según la ciudad del cliente.

-- =====================================================
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- =====================================================
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: Todos los clientes registrados realizaron
-- al menos una compra, ya que la consulta no devolvió filas.

-- =====================================================
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- =====================================================
SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas     AS v   ON p.id_producto  = v.id_producto
LEFT JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- Hallazgo: Todos los productos registrados aparecen
-- en al menos una venta, ya que la consulta no devolvió filas.

-- =====================================================
-- Consulta 4: Consolidado por canal (UNION ALL)
-- =====================================================
SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Primera etapa (hasta el 10/03)' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-11'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Segunda etapa (desde el 11/03)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;

-- Hallazgo: La facturación pasó de $3.620,00 en la primera
-- etapa a $2.824,00 en la segunda, una disminución aproximada
-- del 22%. La comparación corresponde a dos períodos de marzo
-- de 2024 y no representa una caída trimestral.

