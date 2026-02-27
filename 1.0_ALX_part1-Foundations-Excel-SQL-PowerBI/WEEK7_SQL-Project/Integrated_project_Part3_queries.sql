-- Page 11
SELECT 
	Audit.location_id AS Location_Id, 
    Visit.record_id,
    Audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS  surveyor_score
    
FROM auditor_report AS Audit
JOIN visits AS Visit
ON Audit.location_id= Visit.location_id 
JOIN water_quality
ON Visit.record_id= water_quality.record_id
WHERE Audit.true_water_source_score = water_quality.subjective_quality_score 
AND Visit.visit_count =1
LIMIT 10000;

-- getting the 102 records with errors
/*To find the records where the auditor's score and the surveyor's score do not match,
you can modify the query by changing the condition in the WHERE clause to look for
 records where the scores are different */
SELECT 
    Audit.location_id AS Location_Id, 
    Visit.record_id,
    Audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM auditor_report AS Audit
JOIN visits AS Visit
ON Audit.location_id = Visit.location_id 
JOIN water_quality
ON Visit.record_id = water_quality.record_id
WHERE Audit.true_water_source_score != water_quality.subjective_quality_score 
AND Visit.visit_count = 1
LIMIT 10000;


-- page 12 , validate type of water source
SELECT 
    Audit.location_id AS Location_Id, 
    Audit.type_of_water_source AS auditor_source, 
    water_source.type_of_water_source AS survey_source,
    Visit.record_id,
    Audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM auditor_report AS Audit
JOIN visits AS Visit
ON Audit.location_id = Visit.location_id 
JOIN water_quality
ON Visit.record_id = water_quality.record_id
JOIN water_source
ON water_source.source_id = Visit.source_id
WHERE Audit.true_water_source_score != water_quality.subjective_quality_score 
AND Visit.visit_count = 1
LIMIT 10000;
-- remove columns for water source
-- later get column of assigned_employee_id
-- now we can link the incorrect records to the employees who recorded them

-- page 14-15 , validate type of water source
SELECT 
    Audit.location_id AS Location_Id, 
    Visit.record_id,
    Visit.assigned_employee_id,
	Audit.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM auditor_report AS Audit
JOIN visits AS Visit
ON Audit.location_id = Visit.location_id 
JOIN water_quality
ON Visit.record_id = water_quality.record_id
WHERE Audit.true_water_source_score != water_quality.subjective_quality_score 
AND Visit.visit_count = 1
LIMIT 10000;

-- -- page 15 employee names linked to incorrect records
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
    LIMIT 10000;

-- CTE Incorrect_records 
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

SELECT * FROM Incorrect_records
LIMIT 10000;
-- Count how many times their name is in Incorrect_records list, and then group them by name

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
    COUNT(*) AS number_of_mistakes
FROM Incorrect_records
GROUP BY employee_name
ORDER BY number_of_mistakes DESC
LIMIT 10000;


-- page 19,   CTE to identify incorrect records
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
    
-- create view for incorrect records to access it as a table

CREATE VIEW Incorrect_records AS (
    SELECT 
        auditor_report.location_id,
        visits.record_id,
        employee.employee_name,
        auditor_report.true_water_source_score AS auditor_score,
        wq.subjective_quality_score AS surveyor_score,
        auditor_report.statements AS statements
    FROM auditor_report
    JOIN visits ON auditor_report.location_id = visits.location_id
    JOIN water_quality AS wq ON visits.record_id = wq.record_id
    JOIN employee ON employee.assigned_employee_id = visits.assigned_employee_id
    WHERE visits.visit_count = 1
    AND auditor_report.true_water_source_score != wq.subjective_quality_score
);

SELECT * FROM Incorrect_records;

-- CTE  for error_count 
WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT 
        employee_name, 
        COUNT(employee_name) AS number_of_mistakes
    FROM Incorrect_records
    /* Incorrect_records is a view that joins the audit report to the database 
       for records where the auditor and employee's scores are different */
    GROUP BY employee_name
)
-- Main query to display the error count for each employee
SELECT * 
FROM error_count
ORDER BY number_of_mistakes DESC;  -- Added to sort results

-- calculate the average of the number_of_mistakes in error_count. You should get a single value
WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT 
        employee_name, 
        COUNT(employee_name) AS number_of_mistakes
    FROM Incorrect_records
    /* Incorrect_records is a view that joins the audit report to the database 
       for records where the auditor and employee's scores are different */
    GROUP BY employee_name
)
-- Query to calculate the average number of mistakes
SELECT AVG(number_of_mistakes) AS average_mistakes
FROM error_count;


-- page 22, find employees with above-average mistakes
WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT 
        employee_name, 
        COUNT(employee_name) AS number_of_mistakes
    FROM Incorrect_records
    /* Incorrect_records is a view that joins the audit report to the database 
       for records where the auditor and employee's scores are different */
    GROUP BY employee_name
)
-- Query to find employees with above-average mistakes
SELECT 
    employee_name,
    number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT AVG(number_of_mistakes) FROM error_count)
ORDER BY number_of_mistakes DESC;

-- page 22 a more effficient query, giving the same result as the above query
-- find employees with above-average mistakes
WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT 
        employee_name, 
        COUNT(employee_name) AS number_of_mistakes
    FROM Incorrect_records
    /* Incorrect_records is a view that joins the audit report to the database 
       for records where the auditor and employee's scores are different */
    GROUP BY employee_name
),
avg_mistakes AS (
    -- This CTE calculates the average number of mistakes once
    SELECT AVG(number_of_mistakes) AS avg_mistake_count
    FROM error_count
)
-- Main query to find employees with above-average mistakes
SELECT 
    ec.employee_name,
    ec.number_of_mistakes
FROM error_count ec, avg_mistakes am
WHERE ec.number_of_mistakes > am.avg_mistake_count
ORDER BY ec.number_of_mistakes DESC;


-- //creating a suspect list
-- First convert the suspect_list to a CTE and then use it to filter the records from the Incorrect_records 

WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT 
        employee_name, 
        COUNT(employee_name) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
),
-- This CTE calculates the average number of mistakes
avg_mistakes AS (
    SELECT AVG(number_of_mistakes) AS avg_mistake_count
    FROM error_count
),
-- This CTE finds employees with above-average mistakes
suspect_list AS (
    SELECT 
        employee_name,
        number_of_mistakes
    FROM error_count
    WHERE number_of_mistakes > (SELECT avg_mistake_count FROM avg_mistakes)
    ORDER BY number_of_mistakes DESC
)

-- Final query to display the suspect list
SELECT 
    employee_name,
    number_of_mistakes
FROM 
    suspect_list;
    
-- // after we have coverted the suspect_list to a CTE and 
-- then we can use it to filter the records from the Incorrect_records 
--  Isolate Records for the Four Employees in the Suspect List as shown below

WITH error_count AS (
    -- This CTE calculates the number of mistakes each employee made
    SELECT 
        employee_name, 
        COUNT(employee_name) AS number_of_mistakes
    FROM Incorrect_records
    GROUP BY employee_name
),
avg_mistakes AS (
    -- This CTE calculates the average number of mistakes
    SELECT AVG(number_of_mistakes) AS avg_mistake_count
    FROM error_count
),
suspect_list AS (
    -- This CTE finds employees with above-average mistakes
    SELECT 
        employee_name,
        number_of_mistakes
    FROM error_count
    WHERE number_of_mistakes > (SELECT avg_mistake_count FROM avg_mistakes)
    ORDER BY number_of_mistakes DESC
),
-- Convert the suspect list to a CTE
suspects AS (
    SELECT employee_name FROM suspect_list
)

-- Query to isolate all records for the four suspect employees from Incorrect_records
SELECT 
    ir.location_id,   -- this included more results
    ir.record_id, 
    ir.employee_name, 
    ir.auditor_score, 
    ir.surveyor_score, 
    ir.statements
FROM 
    Incorrect_records ir
WHERE 
    ir.employee_name IN (SELECT employee_name FROM suspects);



-- similiar to the above code but cleaner
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
-- This query filters all of the records where the "corrupt" employees gathered data.
SELECT
    employee_name,
    location_id,
    statements
FROM
    Incorrect_records
WHERE
    employee_name IN (SELECT employee_name FROM suspect_list);


--  Filters out employee name, all location ids and statements that mention cash
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
-- This query filters all of the records where the "corrupt" employees gathered data and refer to "cash"
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
    employee_name IN (SELECT employee_name FROM suspect_list)
    AND statements LIKE '%cash%';

-- Filters out employee name, specific location Ids and statements that mention cash
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
-- This query filters all of the records where the "corrupt" employees gathered data and refer to "cash"
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
    employee_name IN (SELECT employee_name FROM suspect_list)
    AND location_id IN ('AkRu04508', 'AkRu07310', 'KiRu29639', 'AmAm09607')
    AND statements LIKE '%cash%';

-- Find out if there are any employees in the Incorrect_records table with statements 
-- mentioning "cash" that are not in our suspect list. This should be as simple as adding one word

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
    AND employee_name NOT IN (SELECT employee_name FROM suspect_list); -- here include NOT IN suspect
    
/*So we can sum up the evidence  we have for Zuriel Matembo, Malachi Mavuso, Bello Azibo and Lalitha Kaburi:
1. They all made more mistakes than their peers on average.
2. They all have incriminating statements made against them, and only them.
Keep in mind, that this is not decisive proof, but it is concerning enough that we should flag it. Pres.
 Naledi has worked hard to stamp out
corruption, so she would urge us to report this.

I am a bit shocked to be honest! After all our teams set out to do, it is hard for me to uncover this. 
I'll let Pres. Naledi know what we found out.*/ 
