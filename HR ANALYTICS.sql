SELECT * FROM hr_employee_attrition
ALTER TABLE hr_employee_attrition
ADD COLUMN employee_id SERIAL PRIMARY KEY;
SELECT job_satisfaction_band,count(job_satisfaction_band) FROM hr_employee_attrition group by job_satisfaction_band
select risk_level,count(*) as employee_count from hr_employee_attrition group by risk_level

--OVERALL ATTRITON RATE
SELECT COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM hr_employee_attrition;

--ATTRITION BY DEPARTMENT
SELECT department,COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM hr_employee_attrition
GROUP BY department
ORDER BY attrition_rate DESC;

--ATTRITION BY JOB ROLE
SELECT job_role,COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM hr_employee_attrition
GROUP BY job_role
ORDER BY attrition_rate DESC;

--OVERTIME VS ATTRITON
SELECT over_time,COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM hr_employee_attrition
GROUP BY over_time
ORDER BY attrition_rate DESC;

--SALARY BS ATTRITON
SELECT attrition,COUNT(*) AS employees,ROUND(AVG(monthly_income), 2) AS average_monthly_income
FROM hr_employee_attrition
GROUP BY attrition;

--AGE GROUP VS ATTRITON
SELECT age_group,COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM hr_employee_attrition
GROUP BY age_group

--EMPLOYEES EARNING MORE THAN THEIR DEPARTMENT AVERAGE
WITH avg_salary AS (
SELECT AVG(monthly_income) AS average_income
FROM hr_employee_attrition
)
SELECT employee_id,job_role, monthly_income,attrition
FROM hr_employee_attrition
WHERE monthly_income > (SELECT average_income FROM avg_salary)
ORDER BY monthly_income DESC;

--HIGH RISK EMPLOYEES
SELECT risk_level,COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM hr_employee_attrition
GROUP BY risk_level
ORDER BY attrition_rate DESC;

--DEPARTMENT WITH HIGHEST ATTRITION
WITH department_attrition AS (
SELECT department,ROUND(100.0* SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM hr_employee_attrition GROUP BY department )
SELECT department, attrition_rate
FROM department_attrition
ORDER BY attrition_rate DESC
LIMIT 1;


--Overtime + Low/Medium Satisfaction Employees
SELECT job_role,department,over_time,job_satisfaction,monthly_income,years_at_company
FROM hr_employee_attrition
WHERE over_time = 'Yes' AND job_satisfaction_band in("Low Satisfaction","Moderate Satisfaction")
ORDER BY years_at_company;

--HIGHEST PAID EMPLOYEE IN EACH JOB ROLE
WITH ranked_employees AS (
SELECT employee_id,job_role,monthly_income,RANK() OVER (PARTITION BY job_role
ORDER BY monthly_income DESC) AS salary_rank
FROM hr_employee_attrition
)
SELECT *
FROM ranked_employees
WHERE salary_rank = 1;

--EMPLOYEES WITH SALARY ABOVE DEPARTMENT AVERRAGE AND LEFT THE JOB
WITH department_salary AS (
SELECT department,AVG(monthly_income) AS avg_salary FROM hr_employee_attrition
GROUP BY department
)
SELECT h.employee_id,h.department,h.job_role,h.monthly_income,h.attrition
FROM hr_employee_attrition h
JOIN department_salary d ON h.department = d.department
WHERE h.monthly_income > d.avg_salary AND h.attrition = 'Yes';

--JOB ROLES BY ATTRITION RATE
WITH role_attrition AS (
 SELECT job_role,COUNT(*) AS total_employees,SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
  100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)/ COUNT(*) AS attrition_rate 
  FROM hr_employee_attrition
  GROUP BY job_role
)
SELECT job_role,total_employees,employees_left,ROUND(attrition_rate, 2) AS attrition_rate,
 RANK() OVER (ORDER BY attrition_rate DESC) AS attrition_rank
FROM role_attrition
ORDER BY attrition_rank;

--DEPARTMENTS WHERE ATTRITION IS ABOVE COMPANY'S AVERAGE
WITH department_attrition AS (
    SELECT
        department,
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*) AS dept_attrition_rate
    FROM hr_employee_attrition
    GROUP BY department
),
company_attrition AS (
    SELECT
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*) AS company_attrition_rate
    FROM hr_employee_attrition
)
SELECT
    d.department,
    ROUND(d.dept_attrition_rate, 2) AS department_attrition,
    ROUND(c.company_attrition_rate, 2) AS company_attrition
FROM department_attrition d
CROSS JOIN company_attrition c
WHERE d.dept_attrition_rate > c.company_attrition_rate;

--HIGH RISK EMPLOYEES BY DEPARTMENT

SELECT department,COUNT(*) AS high_risk_employees,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)/ COUNT(*), 2) AS attrition_rate
FROM hr_employee_attrition
WHERE risk_level = 'High'
GROUP BY department
ORDER BY attrition_rate DESC;