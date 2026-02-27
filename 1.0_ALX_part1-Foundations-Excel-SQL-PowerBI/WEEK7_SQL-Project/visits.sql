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