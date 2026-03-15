--Query Overview: Shows hiring trends over time with cumulative totals.
--Skills Used : CTE, Windows Function, Aggregations, Time Based Analysis


WITH HireYears AS (
    SELECT 
        YEAR(HIREDATE) AS hire_year,
        COUNT(*) AS hires
    FROM EMP
    GROUP BY YEAR(HIREDATE)
)
SELECT 
    hire_year,
    hires,
    SUM(hires) OVER (ORDER BY hire_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_hires
FROM HireYears
ORDER BY hire_year;
