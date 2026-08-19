-- =========================================================
-- 05. OPEN POSITIONS
-- =========================================================
-- Purpose:
-- Create synthetic open-position data at
-- Department x State level.
--
-- Open positions are derived from actual 2024 FTE using
-- predefined vacancy-rate assumptions. A deterministic
-- hash is used so that the same department/state
-- combination receives the same vacancy-rate scenario
-- whenever the script is executed.
--
-- Vacancy counts are rounded to whole positions and are
-- used to analyse where recruiting demand is concentrated.
--
-- The resulting table supports HR controlling and
-- workforce planning analysis in Power BI.
--
-- Note:
-- Open-position values are synthetic and do not represent
-- actual recruiting requisitions from the source dataset.
-- =========================================================


CREATE OR REPLACE TABLE fact_open_positions_2024 AS

WITH actual_fte AS (
    SELECT
        e.Department,
        e.State,
        ROUND(SUM(s.FTE), 2) AS Actual_FTE
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
    Actual_FTE,

    CASE
        WHEN State = 'Ohio' THEN 1
        ELSE CAST(
            round(
                Actual_FTE *
                CASE
                    WHEN PMOD(HASH(Department, State), 3) = 0 THEN 0.005
                    WHEN PMOD(HASH(Department, State), 3) = 1 THEN 0.007
                    ELSE 0.010
                END
            ) AS INT
        )
    END AS Open_Positions

FROM actual_fte;


