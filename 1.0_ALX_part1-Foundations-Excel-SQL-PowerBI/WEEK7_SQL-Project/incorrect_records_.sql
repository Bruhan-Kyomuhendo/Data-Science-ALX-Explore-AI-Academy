WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT
        employee_name,
        COUNT(employee_name) AS number_of_mistakes
    FROM
        Incorrect_records
    /* 
    Incorrect_records is a view that joins the audit report to the database 
    for records where the auditor and employee's scores are different 
    */
    GROUP BY
        employee_name
),
suspect_list AS (
    -- This CTE selects the employees with above-average mistakes
    SELECT
        employee_name,
        number_of_mistakes
    FROM
        error_count
    WHERE
        number_of_mistakes > (SELECT AVG(number_of_mistakes) FROM error_count)
)
-- Query to find employees in Incorrect_records with statements mentioning "cash" that are not in the suspect list
SELECT
    employee_name,
    location_id,
    record_id,
    auditor_score,
    surveyor_score,
    statements
FROM
    Incorrect_records
WHERE
    statements LIKE '%cash%'
    AND employee_name  IN (SELECT employee_name FROM suspect_list);
