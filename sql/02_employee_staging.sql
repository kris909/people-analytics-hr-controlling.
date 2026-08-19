-- =========================================================
-- 02. EMPLOYEE STAGING
-- =========================================================
-- Purpose:
-- Create a reusable employee-level staging view from the raw dataset.
-- Synthetic FTE values are added using a deterministic hash so that
-- the same employee receives the same FTE value on every execution.
-- =========================================================


CREATE OR REPLACE VIEW stg_employees AS

SELECT
    *,
    CASE
        WHEN PMOD(HASH(Employee_ID), 100) < 75 THEN 1.0
        WHEN PMOD(HASH(Employee_ID), 100) < 83 THEN 0.8
        WHEN PMOD(HASH(Employee_ID), 100) < 90 THEN 0.75
        WHEN PMOD(HASH(Employee_ID), 100) < 96 THEN 0.6
        ELSE 0.5
    END AS FTE
FROM workspace.default.dataset;


-- Check active workforce totals

SELECT
    COUNT(DISTINCT Employee_ID) AS headcount,
    SUM(FTE) AS total_fte
FROM stg_employees
WHERE Termdate IS NULL;

