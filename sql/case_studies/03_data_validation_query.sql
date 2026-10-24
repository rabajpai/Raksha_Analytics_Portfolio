/*
============================================================
-- DATA VALIDATION RECONCILIATION QUERY
-- File: 03_data_validation_query.sql
--
-- PURPOSE:
-- This script provides a robust method for reconciling data between a
-- source system and a target system after a data migration. It's a
-- critical step in remediation projects to ensure data integrity.
--
-- HOW IT WORKS:
-- 1.  **CTEs for Source and Target Aggregates:** We create a summary of
--     the data from both the source and target tables. This is more
--     efficient than comparing row-by-row for large datasets.
-- 2.  **FULL OUTER JOIN:** The `FULL OUTER JOIN` is the key. It ensures
--     we capture records that exist only in the source, only in the target,
--     or in both.
-- 3.  **Flagging Mismatches:** The `CASE` statement creates a clear status
--     for each record:
--     - 'MISMATCH_SUM': The record exists in both systems but the aggregate value differs.
--     - 'MISSING_IN_TARGET': The record exists in the source but not the target.
--     - 'EXTRA_IN_TARGET': The record exists in the target but not the source.
-- 4.  **Filtering for Issues:** The final `WHERE` clause filters the result
--     to show only the records that have a problem, providing a clear,
--     actionable list of discrepancies.
============================================================
*/

-- This query can be run directly in a BigQuery environment
-- or adapted for a local SQL Server/Oracle instance.

WITH SourceAggregates AS (
    SELECT
        CustomerID,
        DATE(TransactionDate) AS TransactionDay,
        COUNT(*) AS Source_TransactionCount,
        SUM(Amount) AS Source_TotalAmount
    FROM
        `my_project.source_dataset.transactions` -- Placeholder for source
    GROUP BY
        1, 2
),

TargetAggregates AS (
    SELECT
        CustomerID,
        TransactionDay,
        COUNT(*) AS Target_TransactionCount,
        SUM(Amount) AS Target_TotalAmount
    FROM
        `my_project.target_dataset.transactions` -- Placeholder for target
    GROUP BY
        1, 2
)

SELECT
    COALESCE(s.CustomerID, t.CustomerID) AS CustomerID,
    COALESCE(s.TransactionDay, t.TransactionDay) AS TransactionDay,
    s.Source_TransactionCount,
    t.Target_TransactionCount,
    s.Source_TotalAmount,
    t.Target_TotalAmount,
    CASE
        WHEN s.CustomerID IS NULL THEN 'EXTRA_IN_TARGET'
        WHEN t.CustomerID IS NULL THEN 'MISSING_IN_TARGET'
        WHEN s.Source_TransactionCount != t.Target_TransactionCount OR s.Source_TotalAmount != t.Target_TotalAmount THEN 'MISMATCH_SUM'
        ELSE 'MATCH'
    END AS ReconciliationStatus
FROM
    SourceAggregates s
FULL OUTER JOIN
    TargetAggregates t
    ON s.CustomerID = t.CustomerID AND s.TransactionDay = t.TransactionDay
WHERE
    -- We only care about the mismatches!
    s.Source_TransactionCount != t.Target_TransactionCount OR
    s.Source_TotalAmount != t.Target_TotalAmount OR
    s.CustomerID IS NULL OR
    t.CustomerID IS NULL;
