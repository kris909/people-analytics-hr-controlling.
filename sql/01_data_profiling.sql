-- =========================================================
-- 1. DUPLICATE CHECK
-- =========================================================

SELECT
    Employee_ID,
    COUNT(*) AS row_count
FROM workspace.default.dataset
GROUP BY Employee_ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- =========================================================
-- 2. NULL CHECKS
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Employee_ID IS NULL THEN 1 ELSE 0 END) AS null_employee_id,
    SUM(CASE WHEN Hiredate IS NULL THEN 1 ELSE 0 END) AS null_hiredate,
    SUM(CASE WHEN Termdate IS NULL THEN 1 ELSE 0 END) AS null_termdate,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS null_department,
    SUM(CASE WHEN `Job Title` IS NULL THEN 1 ELSE 0 END) AS null_job_title,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS null_salary,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN `Performance Rating` IS NULL THEN 1 ELSE 0 END) AS null_performance_rating
FROM workspace.default.dataset;

-- =========================================================
-- 3. CATEGORY CHECKS
-- =========================================================

-- Department
SELECT
    Department,
    COUNT(*) AS employees
FROM workspace.default.dataset
GROUP BY Department
ORDER BY employees DESC;

-- Job Title
SELECT
    `Job Title`,
    COUNT(*) AS employees
FROM workspace.default.dataset
GROUP BY `Job Title`
ORDER BY employees DESC;

-- State
SELECT
    State,
    COUNT(*) AS employees
FROM workspace.default.dataset
GROUP BY State
ORDER BY employees DESC;

-- Performance Rating
SELECT
    `Performance Rating`,
    COUNT(*) AS employees
FROM workspace.default.dataset
GROUP BY `Performance Rating`
ORDER BY employees DESC;

-- =========================================================
-- 4. BASIC RANGE CHECKS
-- =========================================================

SELECT
    MIN(Hiredate) AS earliest_hire,
    MAX(Hiredate) AS latest_hire,
    MIN(Termdate) AS earliest_termination,
    MAX(Termdate) AS latest_termination,
    MIN(Salary) AS min_salary,
    MAX(Salary) AS max_salary,
    ROUND(AVG(Salary), 0) AS avg_salary
FROM workspace.default.dataset;