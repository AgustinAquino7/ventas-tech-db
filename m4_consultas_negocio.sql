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

-- Hallazgo: En marzo de 2024 se registró una facturación
-- de $6.444,00, con 10 ventas y un ticket promedio de $644,40.
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
-- Hallazgo: El producto 1 generó la mayor facturación,
-- con $3.600,00 (aproximadamente el 55,9% del total).
-- El producto 2 fue el más vendido en unidades, con 13,
-- pero generó solamente $364,00.
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
-- Hallazgo: Los cinco clientes realizaron dos compras cada uno.
-- Los clientes 1 y 5 sumaron $4.740,00, aproximadamente
-- el 73,6% de la facturación total.
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

-- Hallazgo: Marzo registró $6.444,00 y coincide con el
-- promedio calculado. Como solo hay datos de un mes,
-- no es posible identificar una tendencia mensual.
