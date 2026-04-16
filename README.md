# NFHS-5 Nutrition & Hospital Performance Analysis

**End-to-End Data Analytics Project**  
**NFHS-5 Nutrition & Hospital Performance Analysis**

## Objective
Comprehensive analysis of child nutrition, anemia prevalence, health infrastructure, and hospital claims performance using **NFHS-5 (2019-21)** data combined with **POSHAN Abhiyaan** and **Ayushman Bharat (PM-JAY)** claims data.

The project identifies high-burden states/districts, infrastructure gaps, and the efficiency of health claim settlements to support data-driven public health decisions.

## Key Research Questions
- Which states/districts have the highest nutrition burden (Stunting + Anemia)?
- How strongly is health infrastructure correlated with nutrition outcomes?
- What is the relationship between claims settlement ratio and nutrition status?
- Which states show the largest **Gap Index** (High burden + Poor infrastructure/claims support)?

## Technologies Used

| Module       | Technologies/Tools                          |
|--------------|---------------------------------------------|
| **Python**   | Pandas, NumPy, Matplotlib, Seaborn, Plotly, Scipy, Jupyter Notebook |
| **SQL**      | MySQL / PostgreSQL / SQL Server             |
| **Power BI** | Power BI Desktop, DAX, Power Query          |
| **Excel**    | Advanced Excel, Power Query, Pivot Tables, Charts |
| **Others**   | Git, GitHub, Data Cleaning & Visualization |

## Project Structure

```bash
NFHS-Survey-Nutrition-Analysis/
├── data/
│   ├── raw/                    # Original 6 CSV files
│   └── processed/              # Cleaned and merged datasets
├── Python/
│   └── requirements.txt/ 
│   └── scripts/                # Python scripts (.ipynb)
├── SQL/
│   ├── schema.sql
│   ├── load_data.sql
│   └── queries.sql             # All analytical queries
├── PowerBI/
│   ├── dashboards/             # .pbix files
│   └── visuals/                # theme
├── Excel/
│   ├── reports/                # .xlsx files with analysis
│   └── templates/
├── docs/
├── README.md
├── requirements.txt
└── .gitignore