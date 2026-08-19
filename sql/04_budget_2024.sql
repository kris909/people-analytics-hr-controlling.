-- =========================================================
-- 04. 2024 WORKFORCE BUDGET
-- =========================================================
-- Purpose:
-- Create a synthetic 2024 workforce budget at
-- Department x State level for HR controlling analysis.
--
-- The budget includes:
--   Planned Headcount
--   Planned FTE
--   Planned Salary
--
-- Planned values are based on the actual 2024 workforce
-- structure and adjusted using reproducible SQL logic to
-- create realistic budget variances across departments
-- and states.
--
-- The resulting table is used in Power BI to compare
-- planned vs actual workforce and salary costs.
--
-- Note:
-- Budget values are synthetic and created solely for
-- analytical and portfolio purposes.
-- Planned values are generated from the actual 2024 workforce
-- structure using reproducible SQL logic and then selectively
-- adjusted manually for several Department x State combinations
-- to create more realistic planning scenarios and variances.
-- =========================================================

-- Create Budget for 2024


    CREATE OR REPLACE TABLE fact_budget_2024 AS

WITH actual_2024 AS (
    SELECT
        e.Department,
        e.State,
        COUNT(DISTINCT e.Employee_ID) AS Actual_HC,
        ROUND(SUM(s.FTE), 2) AS Actual_FTE,
        ROUND(SUM(e.Salary), 0) AS Actual_Salary
    FROM stg_employees e
    JOIN workforce_yearly_snapshot s
        ON e.Employee_ID = s.Employee_ID
       AND s.snapshot_date = DATE('2024-12-31')
    WHERE e.Termdate IS NULL
    GROUP BY
        e.Department,
        e.State
)

SELECT
    Department,
    State,

    CAST(
        ROUND(
            Actual_HC *
            CASE
                WHEN PMOD(HASH(Department, State), 5) = 0 THEN 0.95
                WHEN PMOD(HASH(Department, State), 5) = 1 THEN 0.98
                WHEN PMOD(HASH(Department, State), 5) = 2 THEN 1.00
                WHEN PMOD(HASH(Department, State), 5) = 3 THEN 1.03
                ELSE 1.05
            END
        ) AS INT
    ) AS Planned_HC,

    ROUND(
        Actual_FTE *
        CASE
            WHEN PMOD(HASH(Department, State), 5) = 0 THEN 0.96
            WHEN PMOD(HASH(Department, State), 5) = 1 THEN 0.99
            WHEN PMOD(HASH(Department, State), 5) = 2 THEN 1.00
            WHEN PMOD(HASH(Department, State), 5) = 3 THEN 1.02
            ELSE 1.04
        END,
        2
    ) AS Planned_FTE,

    ROUND(
        Actual_Salary *
        CASE
            WHEN PMOD(HASH(Department, State), 5) = 0 THEN 0.94
            WHEN PMOD(HASH(Department, State), 5) = 1 THEN 0.97
            WHEN PMOD(HASH(Department, State), 5) = 2 THEN 1.00
            WHEN PMOD(HASH(Department, State), 5) = 3 THEN 1.04
            ELSE 1.07
        END,
        0
    ) AS Planned_Salary

FROM actual_2024;


 -- Check totals

SELECT
    SUM(Planned_HC) AS Planned_HC,
    ROUND(SUM(Planned_FTE), 2) AS Planned_FTE,
    ROUND(SUM(Planned_Salary), 0) AS Planned_Salary
FROM fact_budget_2024;


-- =========================================================
-- MANUAL BUDGET ADJUSTMENTS
-- =========================================================
-- Selected Department x State combinations were manually
-- adjusted to introduce realistic planning deviations and
-- avoid a purely formula-driven budget scenario.
--
-- These changes are synthetic and intended for analytical
-- and portfolio purposes only.
-- =========================================================

UPDATE fact_budget_2024
SET
    Planned_HC = 50,
    Planned_FTE = 45,
    Planned_Salary = 3999000
WHERE Department = 'IT'
  AND State = 'Illinois';

  UPDATE fact_budget_2024
SET
    Planned_HC = 13,
    Planned_FTE = 11.5,
    Planned_Salary = 1010013
WHERE Department = 'Finance'
  AND State = 'Illinois';

   UPDATE fact_budget_2024
SET
    Planned_HC = 147,
    Planned_FTE = 139.95,
    Planned_Salary = 9759457
WHERE Department = 'Customer Service'
  AND State = 'Michigan';

  UPDATE fact_budget_2024
SET
    Planned_HC = 192,
    Planned_FTE = 174.5,
    Planned_Salary = 15096098
WHERE Department = 'Sales'
  AND State = 'Michigan';

  
   UPDATE fact_budget_2024
SET
    Planned_HC = 2,
    Planned_FTE = 2,
    Planned_Salary = 145500
WHERE Department = 'HR'
  AND State = 'Ohio';

  UPDATE fact_budget_2024
SET
    Planned_HC = 40,
    Planned_FTE = 38,
    Planned_Salary = 3010500
WHERE Department = 'IT'
  AND State = 'Ohio';

    UPDATE fact_budget_2024
SET
    Planned_HC = 63,
    Planned_FTE = 58,
    Planned_Salary = 4025300
WHERE Department = 'Operations'
  AND State = 'Ohio';

    UPDATE fact_budget_2024
SET
    Planned_HC = 845,
    Planned_FTE = 770.5,
    Planned_Salary = 68989013
WHERE Department = 'IT'
  AND State = 'New York';

   UPDATE fact_budget_2024
SET
     Planned_Salary = 68705300
WHERE Department = 'Customer Service'
  AND State = 'New York';

  UPDATE fact_budget_2024
SET
      Planned_HC = 1726,
      Planned_FTE = 1583.5,
      Planned_Salary = 112412600
WHERE Department = 'Operations'
  AND State = 'New York';