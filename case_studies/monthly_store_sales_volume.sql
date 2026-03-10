-- Case study: Monthly store sales volume
-- Objective:
-- Find total quantity sold per store per month and identify high-volume stores.

-- Tables used:
-- - tempdb.dbo.Sales

-- Skills demonstrated:
-- - Aggregations
-- - GROUP BY with derived month and year
-- - ORDER BY for ranking

SELECT
    YEAR([Order Date]) AS OrderYear,
    MONTH([Order Date]) AS OrderMonth,
    [StoreKey],
    SUM([Quantity]) AS TotalQuantity
FROM tempdb.dbo.Sales
GROUP BY
    YEAR([Order Date]),
    MONTH([Order Date]),
    [StoreKey]
ORDER BY
    OrderYear,
    OrderMonth,
    TotalQuantity DESC;
