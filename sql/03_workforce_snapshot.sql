-- =========================================================
-- 03. WORKFORCE YEARLY SNAPSHOT
-- =========================================================
-- Purpose:
-- Reconstruct year-end workforce snapshots from employee
-- hire and termination dates.
--
-- The source dataset contains one latest employee record,
-- rather than historical workforce snapshots. This view
-- recreates employee presence at each year-end date.
--
-- An employee is included in a snapshot when:
--   Hiredate <= snapshot_date
--   AND
--   (Termdate IS NULL OR Termdate > snapshot_date)
--
-- The resulting table is used for historical Headcount
-- and FTE analysis in Power BI.
-- =========================================================

CREATE OR REPLACE VIEW workforce_yearly_snapshot AS

WITH snapshot_dates AS (
    SELECT EXPLODE(
        SEQUENCE(
            DATE('2015-12-31'),
            DATE('2024-12-31'),
            INTERVAL 1 YEAR
        )
    ) AS snapshot_date
)

SELECT
    s.snapshot_date,
    e.Employee_ID,
       e.FTE
FROM snapshot_dates s
JOIN stg_employees e
    ON e.Hiredate <= s.snapshot_date
   AND (
        e.Termdate IS NULL
        OR e.Termdate > s.snapshot_date
   );
   
-- Historical HC and FTE
   SELECT 
    snapshot_date,
    COUNT(DISTINCT Employee_ID) AS headcount,
    SUM (FTE) AS fte
    FROM workforce_yearly_snapshot
    GROUP BY snapshot_date
    ORDER BY snapshot_date;
