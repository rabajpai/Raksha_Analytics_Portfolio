/*
============================================================
-- OPTIMIZED QUERY (BigQuery Standard SQL)
-- File: 02_optimized_query_bigquery.sql
--
-- PURPOSE:
-- This is the BigQuery-optimized version of the legacy query. It produces
-- the exact same result but is designed for performance and cost-efficiency
-- on GCP.
--
-- KEY OPTIMIZATIONS IMPLEMENTED:
-- 1.  **Sargable Filters:** The `WHERE` clause now uses a direct date comparison
--     (`BETWEEN`), allowing BigQuery to use partitioning and clustering on the
--     `OrderDate` column, drastically reducing data scanned.
-- 2.  **Common Table Expressions (CTEs):** The nested subqueries are flattened
--     into sequential CTEs (`MonthlySales`, `RankedSales`). This improves
--     readability and helps the query planner create a more efficient execution plan.
-- 3.  **QUALIFY Clause:** Instead of a final outer query to filter the `RANK()`,
--     we use BigQuery's `QUALIFY` clause. This is a cleaner, more idiomatic
--     way to filter on window function results in the same query block.
-- 4.  **Efficient Aggregations:** The logic is streamlined to perform aggregations
--     only on the required columns, which is optimal for BigQuery's columnar architecture.
============================================================
*/

WITH MonthlySales AS (
    -- CTE 1: Calculate the total quantity for each category per region, per month
    SELECT
        Region,
        DATE_TRUNC(OrderDate, MONTH) AS OrderMonth, -- Group by a date type for better performance
        ProductCategory,
        SUM(Quantity) AS TotalQuantity
    FROM
        Sales
    WHERE
        -- SARGABLE: Filtering on the raw date column allows for partition pruning
        OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY
        1, 2, 3
),

RankedSales AS (
    -- CTE 2: Rank the product categories for each region and month based on total quantity
    SELECT
        Region,
        OrderMonth,
        ProductCategory,
        TotalQuantity,
        RANK() OVER (PARTITION BY Region, OrderMonth ORDER BY TotalQuantity DESC) AS sales_rank
    FROM
        MonthlySales
)

-- Final SELECT: Filter for the top-ranked category in each group
SELECT
    Region,
    OrderMonth,
    ProductCategory,
    TotalQuantity
FROM
    RankedSales
QUALIFY
    sales_rank = 1
ORDER BY
    Region,
    OrderMonth;
