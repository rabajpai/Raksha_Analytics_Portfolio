--Query Purpose:
--This query identifies the highest-paid employee in each department using a CTE and the RANK() window function.
--Skills Used - CTE, RANK(), ROW NUMBER()
--Note: Using RANK() keeps ties so in case 2 employees in same department having highest salary it will show both Employee Names while using ROWNUMBER it doesn't keep Ties.



WITH DeptSalaryRank AS (
    SELECT 
        e.EMPNO,
        e.ENAME,
        e.SAL,
        d.DNAME,
        RANK() OVER (PARTITION BY d.DEPTNO ORDER BY e.SAL DESC) AS sal_rank
    FROM EMP e
    JOIN DEPT d ON e.DEPTNO = d.DEPTNO
)
SELECT *
FROM DeptSalaryRank
WHERE sal_rank = 1;


WITH DeptSalaryRank AS (
    SELECT 
        e.EMPNO,
        e.ENAME,
        e.SAL,
        d.DNAME,
        ROW_NUMBER() OVER (PARTITION BY d.DEPTNO ORDER BY e.SAL DESC) AS sal_rank
    FROM EMP e
    JOIN DEPT d ON e.DEPTNO = d.DEPTNO
)
SELECT *
FROM DeptSalaryRank
WHERE sal_rank = 1;

