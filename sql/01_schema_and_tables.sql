-- ==============================================================================
-- File: 01_schema_and_tables.sql
-- Project: Sales Team Performance & Retention Risk Analysis
-- Author: Sarthak Agarwal
-- Stack: PostgreSQL 14+
-- Description: DDL table definitions and data loading script for the IBM HR
--              Analytics workforce dataset (1,470 employee records).
-- ==============================================================================

DROP TABLE IF EXISTS hr_employee_attrition;

CREATE TABLE hr_employee_attrition (
    employee_id SERIAL PRIMARY KEY,
    age INT NOT NULL,
    attrition VARCHAR(10) NOT NULL,
    business_travel VARCHAR(50),
    daily_rate INT,
    department VARCHAR(50) NOT NULL,
    distance_from_home INT,
    education INT,
    education_field VARCHAR(50),
    environment_satisfaction INT,
    gender VARCHAR(10),
    hourly_rate INT,
    job_involvement INT,
    job_level INT,
    job_role VARCHAR(100) NOT NULL,
    job_satisfaction INT,
    marital_status VARCHAR(20),
    monthly_income NUMERIC(10, 2) NOT NULL,
    monthly_rate INT,
    num_companies_worked INT,
    over_time VARCHAR(10) NOT NULL,
    percent_salary_hike INT,
    performance_rating INT,
    relationship_satisfaction INT,
    stock_option_level INT,
    total_working_years INT,
    training_times_last_year INT,
    work_life_balance INT,
    years_at_company INT NOT NULL,
    years_in_current_role INT,
    years_since_last_promotion INT,
    years_with_curr_manager INT,
    
    -- Feature-Engineered Bands
    attrition_flag INT,
    age_group VARCHAR(20),
    distance_band VARCHAR(20),
    tenure_band VARCHAR(20),
    salary_band VARCHAR(20),
    promotion_gap_band VARCHAR(20),
    job_satisfaction_band VARCHAR(50),
    work_life_balance_band VARCHAR(20),
    risk_score INT,
    risk_level VARCHAR(20)
);

-- Performance Indexes
CREATE INDEX idx_hr_department ON hr_employee_attrition(department);
CREATE INDEX idx_hr_job_role ON hr_employee_attrition(job_role);
CREATE INDEX idx_hr_attrition ON hr_employee_attrition(attrition);
CREATE INDEX idx_hr_over_time ON hr_employee_attrition(over_time);
CREATE INDEX idx_hr_risk_level ON hr_employee_attrition(risk_level);
CREATE INDEX idx_hr_tenure ON hr_employee_attrition(years_at_company);

-- Optional: Copy command
-- COPY hr_employee_attrition FROM '/path/to/cleaned_employee_attrition.csv' WITH (FORMAT csv, HEADER true);
