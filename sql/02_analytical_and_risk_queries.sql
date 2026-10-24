-- ==============================================================================
-- File: 02_analytical_and_risk_queries.sql
-- Project: Sales Team Performance & Retention Risk Analysis
-- Author: Sarthak Agarwal
-- Stack: PostgreSQL
-- Description: Advanced CTEs, subqueries, CASE statements, and window functions
--              to analyze workforce productivity, high-risk retention cohorts,
--              overtime fatigue, and departmental sales benchmarks.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. BASELINE EXECUTIVE ATTRITION KPIS
-- ------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_workforce,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition_count,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS baseline_attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS overall_avg_monthly_salary,
    ROUND(AVG(years_at_company), 1) AS overall_avg_tenure_years
FROM hr_employee_attrition;


-- ------------------------------------------------------------------------------
-- 2. DEPARTMENTAL BENCHMARKING (HEADCOUNT, CHURN & COMP)
-- ------------------------------------------------------------------------------
SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction,
    ROUND(100.0 * SUM(CASE WHEN over_time = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS overtime_participation_rate_pct
FROM hr_employee_attrition
GROUP BY department
ORDER BY attrition_rate_pct DESC;


-- ------------------------------------------------------------------------------
-- 3. JOB ROLE TURNOVER RANKING (HIGHLIGHTING SALES REPRESENTATIVES: 39.76%)
-- ------------------------------------------------------------------------------
WITH role_performance AS (
    SELECT 
        job_role,
        department,
        COUNT(*) AS total_headcount,
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS turnover_count,
        ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS turnover_rate_pct,
        ROUND(AVG(monthly_income), 2) AS avg_monthly_income,
        ROUND(AVG(years_at_company), 1) AS avg_tenure_years
    FROM hr_employee_attrition
    GROUP BY job_role, department
)
SELECT 
    job_role,
    department,
    total_headcount,
    turnover_count,
    turnover_rate_pct,
    avg_monthly_income,
    avg_tenure_years,
    DENSE_RANK() OVER (ORDER BY turnover_rate_pct DESC) AS attrition_severity_rank
FROM role_performance
ORDER BY attrition_severity_rank;


-- ------------------------------------------------------------------------------
-- 4. OVERTIME WORKLOAD IMPACT ON ATTRITION & SATISFACTION
-- Evaluates the burnout gap (30.53% overtime attrition vs 10.44% non-overtime).
-- ------------------------------------------------------------------------------
SELECT 
    over_time,
    COUNT(*) AS employee_count,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_salary,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(work_life_balance), 2) AS avg_work_life_balance
FROM hr_employee_attrition
GROUP BY over_time
ORDER BY attrition_rate_pct DESC;


-- ------------------------------------------------------------------------------
-- 5. TENURE COHORT BREAKDOWN: EARLY STAGE CHURN (0-1 YEARS: 34.88%)
-- ------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN years_at_company <= 1 THEN '1. Early Stage (0-1 Years)'
        WHEN years_at_company <= 5 THEN '2. Developing (2-5 Years)'
        WHEN years_at_company <= 10 THEN '3. Established (6-10 Years)'
        ELSE '4. Veteran (10+ Years)'
    END AS tenure_tier,
    COUNT(*) AS total_cohort,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS turnover_count,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cohort_attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_income
FROM hr_employee_attrition
GROUP BY 1
ORDER BY 1;


-- ------------------------------------------------------------------------------
-- 6. PREDICTIVE RETENTION RISK SCORING EVALUATION
-- Validates the effectiveness of the multi-factor risk model.
-- ------------------------------------------------------------------------------
SELECT 
    risk_level,
    COUNT(*) AS headcount,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM hr_employee_attrition), 2) AS pct_of_workforce,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS actual_attrition_count,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS actual_attrition_rate_pct,
    ROUND(AVG(monthly_income), 2) AS avg_salary,
    ROUND(AVG(years_at_company), 1) AS avg_tenure
FROM hr_employee_attrition
GROUP BY risk_level
ORDER BY actual_attrition_rate_pct DESC;


-- ------------------------------------------------------------------------------
-- 7. HIGH-RISK SALES ACCOUNTS REQUIRING IMMEDIATE MANAGEMENT INTERVENTION
-- Active Sales employees flagged as High Risk due to workload & satisfaction factors.
-- ------------------------------------------------------------------------------
SELECT 
    employee_id,
    job_role,
    age,
    gender,
    monthly_income,
    over_time,
    job_satisfaction,
    work_life_balance,
    years_at_company,
    years_with_curr_manager,
    risk_score
FROM hr_employee_attrition
WHERE department = 'Sales'
  AND attrition = 'No'
  AND risk_level = 'High Risk'
ORDER BY risk_score DESC, monthly_income ASC;


-- ------------------------------------------------------------------------------
-- 8. SALARY EQUITY & DEPARTMENT RELATIVE BENCHMARKING (WINDOW FUNCTIONS)
-- Identifies employees earning below the departmental average and leaving.
-- ------------------------------------------------------------------------------
WITH dept_comp AS (
    SELECT 
        employee_id,
        department,
        job_role,
        monthly_income,
        attrition,
        ROUND(AVG(monthly_income) OVER(PARTITION BY department), 2) AS dept_avg_income,
        monthly_income - AVG(monthly_income) OVER(PARTITION BY department) AS comp_variance
    FROM hr_employee_attrition
)
SELECT 
    department,
    job_role,
    COUNT(*) AS underpaid_departed_count,
    ROUND(AVG(comp_variance), 2) AS avg_deficit_vs_department
FROM dept_comp
WHERE monthly_income < dept_avg_income AND attrition = 'Yes'
GROUP BY department, job_role
ORDER BY underpaid_departed_count DESC;


-- ------------------------------------------------------------------------------
-- 9. HIGHEST AND LOWEST EARNER TURNOVER WITHIN ROLES (RANK & WINDOW)
-- ------------------------------------------------------------------------------
WITH ranked_comp AS (
    SELECT 
        employee_id,
        job_role,
        monthly_income,
        attrition,
        DENSE_RANK() OVER(PARTITION BY job_role ORDER BY monthly_income DESC) AS salary_high_rank,
        DENSE_RANK() OVER(PARTITION BY job_role ORDER BY monthly_income ASC) AS salary_low_rank
    FROM hr_employee_attrition
)
SELECT 
    job_role,
    SUM(CASE WHEN salary_low_rank <= 3 AND attrition = 'Yes' THEN 1 ELSE 0 END) AS bottom_3_earners_left,
    SUM(CASE WHEN salary_high_rank <= 3 AND attrition = 'Yes' THEN 1 ELSE 0 END) AS top_3_earners_left
FROM ranked_comp
GROUP BY job_role
ORDER BY bottom_3_earners_left DESC;
