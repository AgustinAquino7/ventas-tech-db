-- Motor utilizado: SQL Server (SSMS)
-- Base de datos: Ventas_Tech_DB (tabla ventas)
USE Ventas_Tech_DB;

-- =====================================================
-- CONSULTA 1 — Resumen ejecutivo mensual
-- =====================================================
SELECT
    MONTH(fecha_venta)                                AS mes,
    SUM(cantidad * precio_unitario)                   AS total_facturado,
    COUNT(*)                                          AS cantidad_pedidos,
    CAST(AVG(cantidad * precio_unitario) AS DECIMAL(10,2)) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- =====================================================
-- CONSULTA 2 — Ranking de productos
-- =====================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad)                   AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- =====================================================
-- CONSULTA 3 — Clientes recurrentes
-- =====================================================
SELECT
    id_cliente,
    COUNT(*)                        AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- =====================================================
-- CONSULTA 4 — Meses por encima/por debajo del promedio
-- =====================================================
WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CAST((SELECT AVG(total_facturado) FROM facturacion_mensual) AS DECIMAL(10,2)) AS promedio_mensual,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por debajo'
        ELSE 'En el promedio'
    END AS posicion_vs_promedio
FROM facturacion_mensual
ORDER BY mes;

-- =====================================================
-- HALLAZGOS
-- =====================================================
-- 1. El producto 1 concentra el 55,9% de la facturación total (3.600 de 6.444) con solo 3 unidades vendidas.
-- 2. El producto 2 es el más vendido en unidades (13), pero queda 5.º en facturación con solo 364 (5,6% del total).
-- 3. Los 5 clientes compraron exactamente 2 veces, pero los clientes 1 y 5 concentran el 73,6% del total gastado (4.740 de 6.444).
