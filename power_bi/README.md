# 📊 Power BI Dashboard Architecture: Workforce Retention & Commercial Risk

### Project: Sales Team Performance & Retention Risk Analysis
**Author:** Sarthak Agarwal  
**Stack:** Power BI Desktop, DAX, Power Query  
**Primary PBIX File:** [`HR_Analytics_Dashboard.pbix`](./HR_Analytics_Dashboard.pbix)

---

## 🎯 4 Core KPI Scorecards (Matching Resume)
The dashboard features four primary executive scorecard tiles prominently across the top ribbon:

| Core KPI Card | Value | Context & Significance |
|---|---|---|
| **1. Total Headcount** | `1,470` | Total surveyed workforce volume. |
| **2. Cumulative Departures** | `237` | Total employee exits recorded. |
| **3. Baseline Attrition Rate** | `16.12%` | Company-wide turnover benchmark ($237 / 1,470$). |
| **4. High Risk Employees** | `173` | Employees flagged by predictive multi-factor risk model. |

---

## 📐 Dynamic Slicers & Analytical Visual Layout

### Dynamic Interactive Slicers
1. **Department Slicer:** Single/Multi-select (`Sales`, `Research & Development`, `Human Resources`).
2. **Job Role Slicer:** Granular filter across 9 corporate functions.
3. **Overtime Requirement:** Binary toggle (`Yes` / `No`).
4. **Tenure Cohorts:** `0-1 Years`, `2-5 Years`, `6-10 Years`, `10+ Years`.
5. **Predictive Risk Level:** `Low Risk`, `Medium Risk`, `High Risk`.

### Key Analytical Visuals
* **Visual 1 (Ranked Horizontal Bar Chart):** Attrition rate across all 9 job roles with benchmark reference line at 16.12%. Highlights **Sales Representatives at 39.76%** turnover.
* **Visual 2 (Clustered Column Chart):** Overtime Workload Gap—comparing attrition among overtime workers (**30.53%**) vs standard hours (**10.44%**).
* **Visual 3 (Matrix Heatmap):** Tenure Cohort vs. Job Satisfaction level mapping flight risk hotspots.
* **Visual 4 (High-Risk Intervention Grid):** Drill-through table of active employees flagged in the High Risk quadrant, detailing their role, manager tenure, income, and risk factors.

---

## 🚀 Loading and Refreshing the Model
1. Open [`HR_Analytics_Dashboard.pbix`](./HR_Analytics_Dashboard.pbix) in Power BI Desktop.
2. If refreshing the data source, point Power Query to `data/cleaned_employee_attrition.csv`.
3. Review and apply DAX measures from [`dax_measures.txt`](./dax_measures.txt).
