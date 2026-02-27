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
)

SELECT 
    employee_name,
    COUNT(*) AS number_of_mistakes -- employee_name can also be used in place of *, printing the same result
FROM Incorrect_records
GROUP BY employee_name
ORDER BY number_of_mistakes DESC
LIMIT 10000;