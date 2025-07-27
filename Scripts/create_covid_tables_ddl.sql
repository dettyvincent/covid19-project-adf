CREATE SCHEMA covid_reporting
GO

CREATE TABLE covid_reporting.cases_and_deaths
(
    country                 VARCHAR(100),
    country_code_2_digit    VARCHAR(2),
    country_code_3_digit    VARCHAR(3),
    population              BIGINT,
    cases_count             BIGINT,
    deaths_count            BIGINT,
    reported_date           DATE,
    source                  VARCHAR(500)
)
GO

CREATE TABLE covid_reporting.hospital_admissions_daily
(
    country                 VARCHAR(100),
    country_code_2_digit    VARCHAR(2),
    country_code_3_digit    VARCHAR(3),
    population              BIGINT,
    reported_date           DATE,
    hospital_occupancy_count BIGINT,
    icu_occupancy_count      BIGINT,
    source                  VARCHAR(500)
)
GO

CREATE TABLE covid_reporting.hospital_admissions_weekly
(
	country varchar(100),
	country_code_2_digit varchar(2),
	country_code_3_digit varchar(3),
	population bigint,
	reported_year_week varchar(10),
	reported_week_start_date date,
	reported_week_end_date date,
	new_hospital_occupancy_count decimal(16, 13),
	new_icu_occupancy_count decimal(16, 13),
	source varchar(500) 
)
GO

CREATE TABLE covid_reporting.testing
(
    country                 VARCHAR(100),
    country_code_2_digit    VARCHAR(2),
    country_code_3_digit    VARCHAR(3),
    year_week               VARCHAR(8),
    week_start_date         DATE,
    week_end_date           DATE,
    new_cases               BIGINT,
    tests_done              BIGINT,
    population              BIGINT,
    testing_data_source      VARCHAR(500)
)
GO

CREATE TABLE covid_reporting.population
(
	country varchar(100),
	country_code_2_digit varchar(2),
	country_code_3_digit varchar(3),
	population bigint,
	age_group_0_14 decimal(10, 7),
	age_group_15_24 decimal(10, 7),
	age_group_25_49 decimal(10, 7),
	age_group_50_64 decimal(10, 7),
	age_group_65_79 decimal(10, 7),
	age_group_80_max decimal(10, 7) 
)
GO
