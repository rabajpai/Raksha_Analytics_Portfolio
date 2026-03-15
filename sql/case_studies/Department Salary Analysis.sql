--Query Overview : Summarizes salary distribution per department.
--Skills Used : Aggregation, CTE, Joins, Grouping and Ordering



WITH DeptStats AS (
    SELECT 
        d.DNAME,
        AVG(e.SAL) AS avg_salary,
        MAX(e.SAL) AS max_salary,
        MIN(e.SAL) AS min_salary,
        COUNT(e.EMPNO) AS emp_count
    FROM EMP e
    JOIN DEPT d ON e.DEPTNO = d.DEPTNO
    GROUP BY d.DNAME
)
SELECT *
FROM DeptStats
ORDER BY avg_salary DESC;
