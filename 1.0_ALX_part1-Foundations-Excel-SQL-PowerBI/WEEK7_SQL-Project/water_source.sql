WITH Incorrect_records AS (
    SELECT 
        Audit.location_id AS Location_Id, 
        Visit.record_id,
        employee.employee_name, 
        Audit.true_water_source_score AS auditor_score,
        water_quality.subjective_quality_score AS surveyor_score
    FROM auditor_report AS Audit
    JOIN visits AS Visit
    ON Audit.location_id = Visit.location_id 
    JOIN water_quality
    ON Visit.record_id = water_quality.record_id
    JOIN employee
    ON employee.assigned_employee_id = Visit.assigned_employee_id
    WHERE Audit.true_water_source_score != water_quality.subjective_quality_score 
    AND Visit.visit_count = 1
),
Error_count AS (
    SELECT 
        employee_name,
        COUNT(*) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
),
Avg_error_count AS (
    SELECT AVG(number_of_mistakes) AS avg_error_count_per_empl
    FROM Error_count
)

SELECT 
    Error_count.employee_name,
    Error_count.number_of_mistakes,
    Avg_error_count.avg_error_count_per_empl
FROM Error_count, Avg_error_count
WHERE Error_count.number_of_mistakes > Avg_error_count.avg_error_count_per_empl
ORDER BY Error_count.number_of_mistakes DESC
LIMIT 10000;

-- OR use this query, however, this is the most preferable code/query to use
-- CTE to identify incorrect records
WITH Incorrect_records AS (
    SELECT 
        Audit.location_id AS Location_Id, 
        Visit.record_id,
        employee.employee_name, 
        Audit.true_water_source_score AS auditor_score,
        water_quality.subjective_quality_score AS surveyor_score
    FROM auditor_report AS Audit
    JOIN visits AS Visit
    ON Audit.location_id = Visit.location_id 
    JOIN water_quality
    ON Visit.record_id = water_quality.record_id
    JOIN employee
    ON employee.assigned_employee_id = Visit.assigned_employee_id
    -- Filter for mismatches between auditor and surveyor scores, and first visits only
    WHERE Audit.true_water_source_score != water_quality.subjective_quality_score 
    AND Visit.visit_count = 1
),
-- CTE to count errors for each employee
error_count AS (
    SELECT 
        employee_name,
        COUNT(*) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
),
-- CTE to calculate the average number of errors across all employees
avg_error_count AS (
    SELECT AVG(number_of_mistakes) AS avg_error_count_per_empl
    FROM error_count
)
-- Main query to select employees with above-average errors
SELECT 
    ec.employee_name, 
    ec.number_of_mistakes
FROM 
    error_count ec,
    avg_error_count aec
-- Filter for employees with above-average number of mistakes
WHERE 
    ec.number_of_mistakes > aec.avg_error_count_per_empl
-- Sort results by number of mistakes, highest first
ORDER BY 
    ec.number_of_mistakes DESC;
    