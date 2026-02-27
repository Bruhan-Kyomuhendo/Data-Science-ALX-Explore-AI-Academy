SELECT
    auditorRep.location_id,
    visitsTbl.record_id,
    auditorRep.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS employee_score,
    wq.subjective_quality_score - auditorRep.true_water_source_score AS score_diff
FROM
    auditor_report AS auditorRep
JOIN
    visits AS visitsTbl
    ON auditorRep.location_id = visitsTbl.location_id
JOIN
    water_quality AS wq
    ON visitsTbl.record_id = wq.record_id
WHERE
    (wq.subjective_quality_score - auditorRep.true_water_source_score) > 9;
