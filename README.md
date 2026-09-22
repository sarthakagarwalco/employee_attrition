# HR Analytics – Employee Attrition Analysis

## 📊 Project Overview

This project analyzes employee attrition using Python, SQL, and Power BI to identify key factors associated with employee turnover and provide actionable HR insights.

The analysis covers employee demographics, compensation, job satisfaction, work-life balance, overtime, tenure, job roles, business travel, and other workforce characteristics.

## 🎯 Objectives

- Identify key factors associated with employee attrition
- Analyze attrition across different employee segments
- Identify high-risk employee groups
- Build an employee risk segmentation framework
- Create an interactive Power BI dashboard for HR decision-making

## 🛠️ Tech Stack

- **Python:** Pandas, NumPy, Matplotlib, Seaborn
- **SQL:** PostgreSQL
- **Power BI:** DAX, Interactive Dashboard
- **Data Source:** IBM HR Analytics Employee Attrition Dataset

## 🔍 Project Workflow

### 1. Data Cleaning & Preparation
- Loaded and cleaned the HR dataset using Pandas
- Standardized column names using snake_case
- Removed irrelevant constant/identifier fields
- Performed data quality and structural checks

### 2. Feature Engineering
Created meaningful analytical features including:
- Age Groups
- Distance Bands
- Tenure Bands
- Salary Bands
- Promotion Gap Bands
- Job Hopping Bands
- Work-Life Balance Bands
- Job Satisfaction Bands
- Employee Risk Score

### 3. Exploratory Data Analysis

Analyzed attrition across:
- Department
- Job Role
- Overtime
- Salary
- Age
- Tenure
- Distance from Home
- Job Satisfaction
- Work-Life Balance
- Business Travel
- Marital Status

### 4. SQL Analysis

Used PostgreSQL to perform:
- Attrition rate analysis
- Department and job-role analysis
- Salary comparisons
- Overtime analysis
- Employee segmentation
- CTE-based analysis
- Subqueries
- Window functions and ranking
- High-risk employee analysis

### 5. Risk Segmentation

Developed a rule-based employee risk score using multiple factors such as:
- Overtime
- Work-life balance
- Job satisfaction
- Distance from home
- Employee tenure
- Manager tenure

Employees were categorized into:
- Low Risk
- Medium Risk
- High Risk

### 6. Power BI Dashboard

Created an interactive HR Attrition Dashboard containing **4 KPI cards**:

- Total Employees
- Employees Left
- Attrition Rate
- High Risk Employees

The dashboard also includes multiple analytical visuals, slicers, and a high-risk employee detail table for interactive HR analysis.

## 📈 Key Findings

- Overall employee attrition rate was **16.12%**.
- Employees working overtime had **30.53% attrition**, compared with **10.44%** for employees without overtime.
- Employees with **0–1 years of tenure** had **34.88% attrition**.
- Employees under **25 years** had **35.77% attrition**.
- Sales Representatives had the highest attrition at **39.76%**.
- The Low Salary group had **28.61% attrition**, compared with **8.90%** for the Very High Salary group.
- Employees living Far from the workplace had **20.67% attrition**, compared with **13.77%** for employees living Near.

## 💡 Business Recommendations

Based on the analysis, key recommendations include:

1. Strengthen onboarding and early-stage employee retention programs.
2. Review excessive overtime and workload distribution.
3. Evaluate compensation for lower-paid employee groups.
4. Investigate retention challenges in high-attrition roles such as Sales Representatives.
5. Improve career growth, mentoring, and engagement opportunities for younger employees.
6. Use risk segmentation to prioritize retention efforts.

