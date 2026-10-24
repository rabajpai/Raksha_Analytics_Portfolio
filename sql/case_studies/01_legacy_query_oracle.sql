/*
============================================================
-- LEGACY QUERY (Simulated Oracle Syntax)
-- File: 01_legacy_query_oracle.sql
--
-- PURPOSE:
-- This query calculates the top-selling product category for each region
-- on a month-over-month basis. It's written in a style common in older
-- data warehouses, using nested subqueries and non-sargable date functions.
--
-- PERFORMANCE ISSUES TO NOTE:
-- 1.  **Non-Sargable Filters:** Using functions like `TO_CHAR` on a date
--     column in the `WHERE` clause prevents the database from using an index
--     on that column. This forces a full table scan.
-- 2.  **Nested Subqueries:** The logic is built up with multiple layers of
--     subqueries, which can be less readable and harder for the query
--     optimizer to deconstruct effectively.
-- 3.  **`SELECT *` in Subquery:** The innermost query selects all columns,
--     which is inefficient, especially in columnar databases, as it reads
--     data that is not needed.
-- 4.  **Inefficient Joins:** The final join on a derived column (month string)
--     can be less performant than joining on a proper date or integer key.
============================================================
*/

SELECT
    Region,
    OrderMonth,
    ProductCategory,
    TotalQuantity
FROM
    (
        -- Subquery to get total quantity and rank for each category
        SELECT
            Main.Region,
            Main.OrderMonth,
            Main.ProductCategory,
            Main.TotalQuantity,
            RANK() OVER (PARTITION BY Main.Region, Main.OrderMonth ORDER BY Main.TotalQuantity DESC) as sales_rank
        FROM
            (
                -- Innermost subquery to get aggregate quantities
                SELECT
                    Region,
                    TO_CHAR(OrderDate, 'YYYY-MM') AS OrderMonth,
                    ProductCategory,
                    SUM(Quantity) AS TotalQuantity
                FROM
                    Sales
                WHERE
                    -- NON-SARGABLE: Applying a function to the date column
                    TO_CHAR(OrderDate, 'YYYY') = '2023'
                GROUP BY
                    Region,
                    TO_CHAR(OrderDate, 'YYYY-MM'),
                    ProductCategory
            ) Main
    ) Ranked
WHERE
    sales_rank = 1
ORDER BY
    Region,
    OrderMonth;
