CREATE VIEW rejoined_view AS
SELECT
	l.as_of_year,
	r.respondent_id,
	ag.agency_name,
	ag.agency_abbr,
	r.agency_code,
	lt.loan_type_name,
	l.loan_type,
	pt.property_type_name,
	p.property_type,
	lp.loan_purpose_name,
	l.loan_purpose,
	oo.owner_occupancy_name,
	p.owner_occupancy,
	l.loan_amount_000s,
	pa.preapproval_name,
	l.preapproval,
	at.action_taken_name,
	l.action_taken,
	m.msamd_name,
	loc.msamd,
	s.state_name,
	s.state_abbr,
	loc.state_code,
	c.county_name,
	loc.county_code,
	loc.census_tract_number,
	ae.ethnicity_name AS applicant_ethnicity_name,
	a.applicant_ethnicity,
	ce.ethnicity_name AS co_applicant_ethnicity_name,
	ca.co_applicant_ethnicity,
	ar1.race_name AS applicant_race_name_1,
	ar1r.applicant_race AS applicant_race_1,
	ar2.race_name AS applicant_race_name_2,
	ar2r.applicant_race AS applicant_race_2,
	ar3.race_name AS applicant_race_name_3,
	ar3r.applicant_race AS applicant_race_3,
	ar4.race_name AS applicant_race_name_4,
	ar4r.applicant_race AS applicant_race_4,
	ar5.race_name AS applicant_race_name_5,
	ar5r.applicant_race AS applicant_race_5,
	cr1.race_name AS co_applicant_race_name_1,
	cr1r.co_applicant_race AS co_applicant_race_1,
	cr2.race_name AS co_applicant_race_name_2,
	cr2r.co_applicant_race AS co_applicant_race_2,
	cr3.race_name AS co_applicant_race_name_3,
	cr3r.co_applicant_race AS co_applicant_race_3,
	cr4.race_name AS co_applicant_race_name_4,
	cr4r.co_applicant_race AS co_applicant_race_4,
	cr5.race_name AS co_applicant_race_name_5,
	cr5r.co_applicant_race AS co_applicant_race_5,
	asx.sex_name AS applicant_sex_name,
	a.applicant_sex,
	csx.sex_name AS co_applicant_sex_name,
	ca.co_applicant_sex,
	a.applicant_income_000s,
	pur.purchaser_type_name,
	l.purchaser_type,
	dr1n.denial_reason_name AS denial_reason_name_1,
	dr1.denial_reason AS denial_reason_1,
	dr2n.denial_reason_name AS denial_reason_name_2,
	dr2.denial_reason AS denial_reason_2,
	dr3n.denial_reason_name AS denial_reason_name_3,
	dr3.denial_reason AS denial_reason_3,
	l.rate_spread,
	hs.hoepa_status_name,
	l.hoepa_status,
	ls.lien_status_name,
	l.lien_status,
	es.edit_status_name,
	r.edit_status,
	l.sequence_number,
	loc.population,
	loc.minority_population,
	loc.hud_median_family_income,
	loc.tract_to_msamd_income,
	loc.number_of_owner_occupied_units,
	loc.number_of_1_to_4_family_units,
	l.application_date_indicator

FROM loan l
	-- I really wanted to use natural joins :(
	JOIN property p ON l.property_id = p.property_id
	JOIN location loc ON p.location_id = loc.location_id
	LEFT JOIN msamd_ref m ON loc.msamd = m.msamd
	JOIN state_ref s ON loc.state_code = s.state_code
	LEFT JOIN county_ref c ON loc.county_code = c.county_code
	JOIN property_type_ref pt ON p.property_type = pt.property_type
	JOIN owner_occupancy_ref oo ON p.owner_occupancy = oo.owner_occupancy

	JOIN loan_type_ref lt ON l.loan_type = lt.loan_type
	JOIN loan_purpose_ref lp ON l.loan_purpose = lp.loan_purpose
	JOIN preapproval_ref pa ON l.preapproval = pa.preapproval
	JOIN action_taken_ref at ON l.action_taken = at.action_taken
	JOIN hoepa_status_ref hs ON l.hoepa_status = hs.hoepa_status
	JOIN lien_status_ref ls ON l.lien_status = ls.lien_status
	JOIN purchaser_type_ref pur ON l.purchaser_type = pur.purchaser_type

	JOIN respondent r ON l.loan_id = r.loan_id
	JOIN agency ag ON r.agency_code = ag.agency_code
	JOIN edit_status_ref es ON r.edit_status = es.edit_status

	JOIN applicant a ON a.loan_id = l.loan_id
	JOIN ethnicity_ref ae ON a.applicant_ethnicity = ae.ethnicity
	JOIN sex_ref asx ON a.applicant_sex = asx.sex

	LEFT JOIN co_applicant ca ON ca.applicant_id = a.applicant_id
	LEFT JOIN ethnicity_ref ce ON ca.co_applicant_ethnicity = ce.ethnicity
	LEFT JOIN sex_ref csx ON ca.co_applicant_sex = csx.sex

	LEFT JOIN loan_denial dr1 ON dr1.loan_id = l.loan_id AND dr1.denial_order = 1
	LEFT JOIN loan_denial_ref dr1n ON dr1.denial_reason = dr1n.denial_reason
	LEFT JOIN loan_denial dr2 ON dr2.loan_id = l.loan_id AND dr2.denial_order = 2
	LEFT JOIN loan_denial_ref dr2n ON dr2.denial_reason = dr2n.denial_reason
	LEFT JOIN loan_denial dr3 ON dr3.loan_id = l.loan_id AND dr3.denial_order = 3
	LEFT JOIN loan_denial_ref dr3n ON dr3.denial_reason = dr3n.denial_reason

	LEFT JOIN applicant_race ar1r ON ar1r.applicant_id = a.applicant_id AND ar1r.applicant_race_order = 1
	LEFT JOIN race_ref ar1 ON ar1r.applicant_race = ar1.race
	LEFT JOIN applicant_race ar2r ON ar2r.applicant_id = a.applicant_id AND ar2r.applicant_race_order = 2
	LEFT JOIN race_ref ar2 ON ar2r.applicant_race = ar2.race
	LEFT JOIN applicant_race ar3r ON ar3r.applicant_id = a.applicant_id AND ar3r.applicant_race_order = 3
	LEFT JOIN race_ref ar3 ON ar3r.applicant_race = ar3.race
	LEFT JOIN applicant_race ar4r ON ar4r.applicant_id = a.applicant_id AND ar4r.applicant_race_order = 4
	LEFT JOIN race_ref ar4 ON ar4r.applicant_race = ar4.race
	LEFT JOIN applicant_race ar5r ON ar5r.applicant_id = a.applicant_id AND ar5r.applicant_race_order = 5
	LEFT JOIN race_ref ar5 ON ar5r.applicant_race = ar5.race

	LEFT JOIN co_applicant_race cr1r ON cr1r.co_applicant_id = ca.co_applicant_id AND cr1r.co_applicant_race_order = 1
	LEFT JOIN race_ref cr1 ON cr1r.co_applicant_race = cr1.race
	LEFT JOIN co_applicant_race cr2r ON cr2r.co_applicant_id = ca.co_applicant_id AND cr2r.co_applicant_race_order = 2
	LEFT JOIN race_ref cr2 ON cr2r.co_applicant_race = cr2.race
	LEFT JOIN co_applicant_race cr3r ON cr3r.co_applicant_id = ca.co_applicant_id AND cr3r.co_applicant_race_order = 3
	LEFT JOIN race_ref cr3 ON cr3r.co_applicant_race = cr3.race
	LEFT JOIN co_applicant_race cr4r ON cr4r.co_applicant_id = ca.co_applicant_id AND cr4r.co_applicant_race_order = 4
	LEFT JOIN race_ref cr4 ON cr4r.co_applicant_race = cr4.race
	LEFT JOIN co_applicant_race cr5r ON cr5r.co_applicant_id = ca.co_applicant_id AND cr5r.co_applicant_race_order = 5
	LEFT JOIN race_ref cr5 ON cr5r.co_applicant_race = cr5.race
	
LIMIT 5;

CREATE TABLE rejoined_table AS SELECT * FROM rejoined_view;

DROP VIEW rejoined_view;
