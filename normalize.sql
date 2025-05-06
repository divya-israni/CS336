/************************ Loan References ************************/

CREATE TABLE loan_type_ref(
	loan_type int NOT NULL,
	loan_type_name text NOT NULL,
	PRIMARY KEY (loan_type)
);

CREATE TABLE loan_purpose_ref(
	loan_purpose int NOT NULL,
	loan_purpose_name text NOT NULL,
	PRIMARY KEY (loan_purpose)
);

CREATE TABLE preapproval_ref(
	preapproval int NOT NULL,
	preapproval_name text NOT NULL,
	PRIMARY KEY (preapproval)
);

CREATE TABLE action_taken_ref(
	action_taken int NOT NULL,
	action_taken_name text NOT NULL,
	PRIMARY KEY (action_taken)
);

CREATE TABLE hoepa_status_ref(
	hoepa_status int NOT NULL,
	hoepa_status_name text NOT NULL,
	PRIMARY KEY (hoepa_status)
);

CREATE TABLE lien_status_ref(
	lien_status int NOT NULL,
	lien_status_name text NOT NULL,
	PRIMARY KEY (lien_status)
);

CREATE TABLE purchaser_type_ref(
	purchaser_type int NOT NULL,
	purchaser_type_name text NOT NULL,
	PRIMARY KEY (purchaser_type)
);

/************************ Loan Denial References ************************/

CREATE TABLE loan_denial_ref(
	denial_reason int NOT NULL,
	denial_reason_name text NOT NULL,
	PRIMARY KEY (denial_reason)
);

/************************ Property References ************************/

CREATE TABLE property_type_ref(
	property_type int NOT NULL,
	property_type_name text NOT NULL,
	PRIMARY KEY (property_type)
);

CREATE TABLE owner_occupancy_ref(
	owner_occupancy int NOT NULL,
	owner_occupancy_name text NOT NULL,
	PRIMARY KEY (owner_occupancy)
);

/************************ Location References ************************/

CREATE TABLE msamd_ref(
	msamd int NOT NULL,
	msamd_name text NOT NULL,
	PRIMARY KEY (msamd)
);

CREATE TABLE state_ref(
	state_code int NOT NULL,
	state_name text NOT NULL,
	state_abbr text NOT NULL,
	PRIMARY KEY (state_code)
);

CREATE TABLE county_ref(
	county_code int NOT NULL,
	county_name text NOT NULL,
	PRIMARY KEY (county_code)
);

CREATE TABLE location(
	location_id serial NOT NULL,
	msamd int,
	state_code int NOT NULL,
	county_code int,
	census_tract_number NUMERIC,
	population int,
	minority_population NUMERIC,
	hud_median_family_income int,
	tract_to_msamd_income NUMERIC,
	number_of_owner_occupied_units int,
	number_of_1_to_4_family_units int,
	PRIMARY KEY (location_id),
	FOREIGN KEY (msamd) REFERENCES msamd_ref(msamd),
	FOREIGN KEY (state_code) REFERENCES state_ref(state_code),
	FOREIGN KEY (county_code) REFERENCES county_ref(county_code)
);

/************************ Respondent References ************************/

CREATE TABLE agency(
	agency_code int NOT NULL,
	agency_name text NOT NULL,
	agency_abbr text NOT NULL,
	PRIMARY KEY (agency_code)
);

CREATE TABLE edit_status_ref(
	edit_status text NOT NULL,
	edit_status_name text NOT NULL,
	PRIMARY KEY (edit_status)
);

/************************ Applicant/Co-Applicant References ************************/

CREATE TABLE race_ref(
	race int NOT NULL,
	race_name text NOT NULL,
	PRIMARY KEY (race)
); 

CREATE TABLE ethnicity_ref(
	ethnicity int NOT NULL,
	ethnicity_name text NOT NULL,
	PRIMARY KEY (ethnicity)
);

CREATE TABLE sex_ref(
	sex int NOT NULL,
	sex_name text NOT NULL,
	PRIMARY KEY (sex)
);

/************************ Normalized "Main" Relations ************************/

CREATE TABLE property(
	property_id serial NOT NULL,
	location_id int NOT NULL,
	property_type int NOT NULL,
	owner_occupancy int NOT NULL,
	PRIMARY KEY (property_id),
	FOREIGN KEY (location_id) REFERENCES location(location_id),
	FOREIGN KEY (property_type) REFERENCES property_type_ref(property_type),
	FOREIGN KEY (owner_occupancy) REFERENCES owner_occupancy_ref(owner_occupancy) 
);

CREATE TABLE loan(
	loan_id int NOT NULL,
	property_id int NOT NULL,
	loan_type int NOT NULL,
	loan_purpose int NOT NULL,
	preapproval int NOT NULL,
	action_taken int NOT NULL,
	hoepa_status int NOT NULL,
	lien_status int NOT NULL,
	purchaser_type int NOT NULL,
	as_of_year int NOT NULL,
	loan_amount_000s int,
	rate_spread NUMERIC,
	sequence_number int,
	application_date_indicator int,
	PRIMARY KEY (loan_id),
	FOREIGN KEY (property_id) REFERENCES property(property_id),
	FOREIGN KEY (loan_type) REFERENCES loan_type_ref(loan_type),
	FOREIGN KEY (loan_purpose) REFERENCES loan_purpose_ref(loan_purpose),
	FOREIGN KEY (preapproval) REFERENCES preapproval_ref(preapproval),
	FOREIGN KEY (action_taken) REFERENCES action_taken_ref(action_taken),
	FOREIGN KEY (hoepa_status) REFERENCES hoepa_status_ref(hoepa_status),
	FOREIGN KEY (lien_status) REFERENCES lien_status_ref(lien_status),
	FOREIGN KEY (purchaser_type) REFERENCES purchaser_type_ref(purchaser_type)
);

CREATE TABLE loan_denial(
	loan_id int NOT NULL,
	denial_reason int NOT NULL,
	denial_order int NOT NULL,
	PRIMARY KEY (loan_id, denial_reason),
	FOREIGN KEY (loan_id) REFERENCES loan(loan_id),
	FOREIGN KEY (denial_reason) REFERENCES loan_denial_ref(denial_reason)
);

CREATE TABLE respondent(
	loan_id int NOT NULL,
	respondent_id text NOT NULL,
	agency_code int NOT NULL,
	edit_status text,
	PRIMARY KEY (loan_id, respondent_id, agency_code),
	FOREIGN KEY (loan_id) REFERENCES loan(loan_id),
	FOREIGN KEY (agency_code) REFERENCES agency(agency_code),
	FOREIGN KEY (edit_status) REFERENCES edit_status_ref(edit_status)
);

CREATE TABLE applicant(
	applicant_id serial NOT NULL,
	loan_id int NOT NULL,
	applicant_ethnicity int NOT NULL,
	applicant_sex int NOT NULL,
	applicant_income_000s int,
	PRIMARY KEY (applicant_id),
	FOREIGN KEY (loan_id) REFERENCES loan(loan_id),
	FOREIGN KEY (applicant_ethnicity) REFERENCES ethnicity_ref(ethnicity),
	FOREIGN KEY (applicant_sex) REFERENCES sex_ref(sex)
);

CREATE TABLE co_applicant(
	co_applicant_id serial NOT NULL,
	applicant_id int NOT NULL,
	co_applicant_ethnicity int NOT NULL,
	co_applicant_sex int NOT NULL,
	PRIMARY KEY (co_applicant_id),
	FOREIGN KEY (applicant_id) REFERENCES applicant(applicant_id),
	FOREIGN KEY (co_applicant_ethnicity) REFERENCES ethnicity_ref(ethnicity),
	FOREIGN KEY (co_applicant_sex) REFERENCES sex_ref(sex)
);

CREATE TABLE applicant_race(
	applicant_id int NOT NULL,
	applicant_race int NOT NULL,
	applicant_race_order int NOT NULL,
	PRIMARY KEY (applicant_id, applicant_race),
	FOREIGN KEY (applicant_id) REFERENCES applicant(applicant_id)
);

CREATE TABLE co_applicant_race(
	co_applicant_id int NOT NULL,
	co_applicant_race int NOT NULL,
	co_applicant_race_order int NOT NULL,
	PRIMARY KEY (co_applicant_id, co_applicant_race),
	FOREIGN KEY (co_applicant_id) REFERENCES co_applicant(co_applicant_id)
);

/************************ Populating Reference Relations ************************/

INSERT INTO loan_type_ref VALUES
	(1, 'Conventional'),
	(2, 'FHA-insured'),
	(3, 'VA-guaranteed'),
	(4, 'FSA/RHS');

INSERT INTO loan_purpose_ref VALUES
	(1, 'Home purchase'),
	(2, 'Home improvement'),
	(3, 'Refinancing');

INSERT INTO preapproval_ref VALUES
	(1, 'Preapproval was requested'),
	(2, 'Preapproval was not requested'),
	(3, 'Not applicable');

INSERT INTO action_taken_ref VALUES
	(1, 'Loan originated'),
	(2, 'Application approved but not accepted'),
	(3, 'Application denied by financial institution'),
	(4, 'Application withdrawn by applicant'),
	(5, 'File closed for incompleteness'),
	(6, 'Loan purchased by the institution'),
	(7, 'Preapproval request denied by financial institution'),
	(8, 'Preapproval request approved but not accepted');

INSERT INTO hoepa_status_ref VALUES
	(1, 'HOEPA loan'),
	(2, 'Not a HOEPA loan');

INSERT INTO lien_status_ref VALUES
	(1, 'Secured by a first lien'),
	(2, 'Secured by a subordinate lien'),
	(3, 'Not secured by a lien'),
	(4, 'Not applicable');

INSERT INTO purchaser_type_ref VALUES
	(0, 'Loan was not originated or was not sold in calendar year covered by register'),
	(1, 'Fannie Mae (FNMA)'),
	(2, 'Ginnie Mae (GNMA)'),
	(3, 'Freddie Mac (FHLMC)'),
	(4, 'Farmer Mac (FAMC)'),
	(5, 'Private securitization'),
	(6, 'Commercial bank, savings bank or savings association'),
	(7, 'Life insurance company, credit union, mortgage bank, or finance company'),
	(8, 'Affiliate institution'),
	(9, 'Other type of purchaser');

INSERT INTO loan_denial_ref VALUES
	(1, 'Debt-to-income ratio'),
	(2, 'Employment history'),
	(3, 'Credit history'),
	(4, 'Collateral'),
	(5, 'Insufficient cash (downpayment, closing costs)'),
	(6, 'Unverifiable information'),
	(7, 'Credit application incomplete'),
	(8, 'Mortgage insurance denied'),
	(9, 'Other');

INSERT INTO property_type_ref VALUES
	(1, 'One to four-family (other than manufactured housing)'),
	(2, 'Manufactured housing'),
	(3, 'Multifamily');

INSERT INTO owner_occupancy_ref VALUES
	(1, 'Owner-occupied as a principal dwelling'),
	(2, 'Not owner-occupied'),
	(3, 'Not applicable');

INSERT INTO msamd_ref
	SELECT DISTINCT msamd, msamd_name
	FROM typed_preliminary
	WHERE msamd IS NOT NULL;

INSERT INTO state_ref VALUES
	(34, 'New Jersey', 'NJ');

INSERT INTO county_ref
	SELECT DISTINCT county_code, county_name
	FROM typed_preliminary
	WHERE county_code IS NOT NULL;

INSERT INTO location
	(
		msamd,
		state_code,
		county_code,
		census_tract_number,
		population,
		minority_population,
		hud_median_family_income,
		tract_to_msamd_income,
		number_of_owner_occupied_units,
		number_of_1_to_4_family_units
	)
	SELECT DISTINCT
		msamd,
		state_code,
		county_code,
		census_tract_number,
		population,
		minority_population,
		hud_median_family_income,
		tract_to_msamd_income,
		number_of_owner_occupied_units,
		number_of_1_to_4_family_units
	FROM
		typed_preliminary;

INSERT INTO agency VALUES
	(1, 'Office of the Comptroller of the Currency', 'OCC'),
	(2, 'Federal Reserve System', 'FRS'),
	(3, 'Federal Deposit Insurance Corporation', 'FDIC'),
	(5, 'National Credit Union Administration', 'NCUA'),
	(7, 'Department of Housing and Urban Development', 'HUD'),
	(9, 'Consumer Financial Protection Bureau', 'CFPB');

INSERT INTO edit_status_ref VALUES
	('', 'No edit failures'),
	('5', 'Validity edit failure only'),
	('6', 'Quality edit failure only'),
	('7', 'Validity and quality edit failures');

INSERT INTO race_ref VALUES
	(1, 'American Indian or Alaska Native'),
	(2, 'Asian'),
	(3, 'Black or African American'),
	(4, 'Native Hawaiian or Other Pacific Islander'),
	(5, 'White'),
	(6, ' Information not provided by applicant in mail, Internet, or telephone application'),
	(7, 'Not applicable'),
	(8, 'No co-applicant');

INSERT INTO ethnicity_ref VALUES
	(1, 'Hispanic or Latino'),
	(2, 'Not Hispanic or Latino'),
	(3, 'Information not provided by applicant in mail, Internet, or telephone application'),
	(4, 'Not applicable'),
	(5, 'No co-applicant');

INSERT INTO sex_ref VALUES
	(1, 'Male'),
	(2, 'Female'),
	(3, 'Information not provided by applicant in mail, Internet, or telephone application'),
	(4, 'Not applicable'),
	(5, 'No co-applicant');

/************************ Populating "Main" Relations ************************/

-- Property --
INSERT INTO property
	(
		location_id,
		property_type,
		owner_occupancy
	)
	SELECT DISTINCT
		loc.location_id,
		tp.property_type,
		tp.owner_occupancy
	FROM
		typed_preliminary tp JOIN location loc ON
			tp.msamd = loc.msamd AND
			tp.state_code = loc.state_code AND
			(tp.county_code IS NOT DISTINCT FROM loc.county_code) AND
			(tp.census_tract_number IS NOT DISTINCT FROM loc.census_tract_number) AND
			(tp.population IS NOT DISTINCT FROM loc.population) AND
			(tp.minority_population IS NOT DISTINCT FROM loc.minority_population) AND
			(tp.hud_median_family_income IS NOT DISTINCT FROM loc.hud_median_family_income) AND
			(tp.tract_to_msamd_income IS NOT DISTINCT FROM loc.tract_to_msamd_income) AND
			(tp.number_of_owner_occupied_units IS NOT DISTINCT FROM loc.number_of_owner_occupied_units) AND
			(tp.number_of_1_to_4_family_units IS NOT DISTINCT FROM loc.number_of_1_to_4_family_units);

-- Loan --
INSERT INTO loan
	SELECT
		tp.application_id,
		p.property_id,
		tp.loan_type,
		tp.loan_purpose,
		tp.preapproval,
		tp.action_taken,
		tp.hoepa_status,
		tp.lien_status,
		tp.purchaser_type,
		tp.as_of_year,
		tp.loan_amount_000s,
		tp.rate_spread,
		tp.sequence_number,
		tp.application_date_indicator
	FROM
		typed_preliminary tp JOIN location loc ON
			tp.msamd = loc.msamd AND
			tp.state_code = loc.state_code AND
			(tp.county_code IS NOT DISTINCT FROM loc.county_code) AND
			(tp.census_tract_number IS NOT DISTINCT FROM loc.census_tract_number) AND
			(tp.population IS NOT DISTINCT FROM loc.population) AND
			(tp.minority_population IS NOT DISTINCT FROM loc.minority_population) AND
			(tp.hud_median_family_income IS NOT DISTINCT FROM loc.hud_median_family_income) AND
			(tp.tract_to_msamd_income IS NOT DISTINCT FROM loc.tract_to_msamd_income) AND
			(tp.number_of_owner_occupied_units IS NOT DISTINCT FROM loc.number_of_owner_occupied_units) AND
			(tp.number_of_1_to_4_family_units IS NOT DISTINCT FROM loc.number_of_1_to_4_family_units)
		JOIN property p ON
			p.location_id = loc.location_id AND
			p.property_type = tp.property_type AND
			p.owner_occupancy = tp.owner_occupancy;

-- Denial Reason 1 --
INSERT INTO loan_denial
	SELECT
		tp.application_id,
		tp.denial_reason_1,
		1
	FROM
		typed_preliminary tp JOIN loan l ON
			tp.application_id = l.loan_id
	WHERE
		tp.denial_reason_1 IS NOT NULL;

-- Denial Reason 2 --
INSERT INTO loan_denial
	SELECT
		tp.application_id,
		tp.denial_reason_2,
		2
	FROM
		typed_preliminary tp JOIN loan l ON
			tp.application_id = l.loan_id
	WHERE
		tp.denial_reason_2 IS NOT NULL;

-- Denial Reason 3 --
INSERT INTO loan_denial
	SELECT
		tp.application_id,
		tp.denial_reason_3,
		3
	FROM
		typed_preliminary tp JOIN loan l ON
			tp.application_id = l.loan_id
	WHERE
		tp.denial_reason_3 IS NOT NULL;

-- Respondent --
INSERT INTO respondent
	SELECT
		tp.application_id,
		tp.respondent_id,
		tp.agency_code,
		tp.edit_status
	FROM
		typed_preliminary tp JOIN loan l ON
			tp.application_id = l.loan_id;

-- Applicant --
INSERT INTO applicant
	(
		loan_id,
		applicant_ethnicity,
		applicant_sex,
		applicant_income_000s
	)
	SELECT
		tp.application_id,
		tp.applicant_ethnicity,
		tp.applicant_sex,
		tp.applicant_income_000s
	FROM
		typed_preliminary tp JOIN loan l ON
			tp.application_id = l.loan_id;

-- Co-Applicant --
INSERT INTO co_applicant
	(
		applicant_id,
		co_applicant_ethnicity,
		co_applicant_sex
	)
	SELECT
		a.applicant_id,
		tp.co_applicant_ethnicity,
		tp.co_applicant_sex
	FROM
		applicant a JOIN typed_preliminary tp ON
			a.loan_id = tp.application_id AND
			tp.co_applicant_ethnicity <> 5; -- 5 -> 'No co-applicant'

-- Applicant Race 1 --
INSERT INTO applicant_race
	SELECT
		a.applicant_id,
		tp.applicant_race_1,
		1
	FROM
		applicant a JOIN typed_preliminary tp ON
			a.loan_id = tp.application_id
	WHERE
		tp.applicant_race_1 IS NOT NULL;

-- Applicant Race 2 --
INSERT INTO applicant_race
	SELECT
		a.applicant_id,
		tp.applicant_race_2,
		2
	FROM
		applicant a JOIN typed_preliminary tp ON
			a.loan_id = tp.application_id
	WHERE
		tp.applicant_race_2 IS NOT NULL;

-- Applicant Race 3 --
INSERT INTO applicant_race
	SELECT
		a.applicant_id,
		tp.applicant_race_3,
		3
	FROM
		applicant a JOIN typed_preliminary tp ON
			a.loan_id = tp.application_id
	WHERE
		tp.applicant_race_3 IS NOT NULL;

-- Applicant Race 4 --
INSERT INTO applicant_race
	SELECT
		a.applicant_id,
		tp.applicant_race_4,
		4
	FROM
		applicant a JOIN typed_preliminary tp ON
			a.loan_id = tp.application_id
	WHERE
		tp.applicant_race_4 IS NOT NULL;

-- Applicant Race 5 --
INSERT INTO applicant_race
	SELECT
		a.applicant_id,
		tp.applicant_race_5,
		5
	FROM
		applicant a JOIN typed_preliminary tp ON
			a.loan_id = tp.application_id
	WHERE
		tp.applicant_race_5 IS NOT NULL;

-- Co-Applicant Race 1 --
INSERT INTO co_applicant_race
	SELECT
		c.co_applicant_id,
		tp.co_applicant_race_1,
		1
	FROM
		(co_applicant c JOIN applicant a ON
			c.applicant_id = a.applicant_id) JOIN typed_preliminary tp ON
				a.loan_id = tp.application_id
	WHERE
		tp.co_applicant_race_1 IS NOT NULL;

-- Co-Applicant Race 2 --
INSERT INTO co_applicant_race
	SELECT
		c.co_applicant_id,
		tp.co_applicant_race_2,
		2
	FROM
		(co_applicant c JOIN applicant a ON
			c.applicant_id = a.applicant_id) JOIN typed_preliminary tp ON
				a.loan_id = tp.application_id
	WHERE
		tp.co_applicant_race_2 IS NOT NULL;

-- Co-Applicant Race 3 --
INSERT INTO co_applicant_race
	SELECT
		c.co_applicant_id,
		tp.co_applicant_race_3,
		3
	FROM
		(co_applicant c JOIN applicant a ON
			c.applicant_id = a.applicant_id) JOIN typed_preliminary tp ON
				a.loan_id = tp.application_id
	WHERE
		tp.co_applicant_race_3 IS NOT NULL;

-- Co-Applicant Race 4 --
INSERT INTO co_applicant_race
	SELECT
		c.co_applicant_id,
		tp.co_applicant_race_4,
		4
	FROM
		(co_applicant c JOIN applicant a ON
			c.applicant_id = a.applicant_id) JOIN typed_preliminary tp ON
				a.loan_id = tp.application_id
	WHERE
		tp.co_applicant_race_4 IS NOT NULL;

-- Co-Applicant Race 5 --
INSERT INTO co_applicant_race
	SELECT
		c.co_applicant_id,
		tp.co_applicant_race_5,
		5
	FROM
		(co_applicant c JOIN applicant a ON
			c.applicant_id = a.applicant_id) JOIN typed_preliminary tp ON
				a.loan_id = tp.application_id
	WHERE
		tp.co_applicant_race_5 IS NOT NULL;
