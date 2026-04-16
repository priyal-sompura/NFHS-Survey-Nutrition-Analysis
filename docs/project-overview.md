
# Project Overview

## Project Title
**NFHS-5 Nutrition & Hospital Performance Analysis**

## Objective
To analyze the interlinkages between child nutrition indicators, anemia prevalence, health infrastructure, and hospital claims performance using NFHS-5 data, POSHAN Abhiyaan data, and Ayushman Bharat claims data. The project aims to identify high-burden states/districts and gaps in healthcare delivery.

## Project Description
This project combines multiple government datasets to provide actionable insights on:
- Nutritional status of children (Stunting, Wasting, Underweight)
- Anemia levels across different population groups
- Healthcare infrastructure availability
- Health insurance claims settlement efficiency

## Datasets Used (6 Datasets)

| Sr. No. | Dataset Name                  | CSV File                     | Level      | Key Indicators |
|---------|-------------------------------|------------------------------|------------|----------------|
| 1       | State Claims Data             | claims_clean.csv            | State      | Claims submitted, paid & pending (2020-23) |
| 2       | Health Infrastructure         | infra_clean.csv             | District   | Hospitals, Beds, Doctors, Nurses |
| 3       | POSHAN Nutrition Data         | poshan_clean.csv            | District   | Children Stunted, Wasted, Underweight |
| 4       | State Nutrition (Anemia)      | state_nutrition_clean.csv   | State      | Anemia in Children, Women & Men |
| 5       | NFHS-5 District Data          | nfhs_district_clean.csv     | District   | 100+ NFHS indicators (MCH, Nutrition, FP, Vaccination, etc.) |
| 6       | NFHS-5 State Data             | nfhs_state_clean.csv        | State      | State-level NFHS-5 indicators |

## Key Research Questions
1. Which states/districts have the highest nutrition burden (stunting + anemia)?
2. How does health infrastructure correlate with nutrition outcomes?
3. Is there a relationship between claims settlement ratio and nutrition status?
4. Which states show the biggest **Gap Index** (High burden + Low healthcare support)?
5. What are the major determinants of child undernutrition?

## Technologies Stack
- **Database**: MySQL
- **Data Processing**: Python (pandas, numpy, seaborn, plotly)
- **Visualization**: Power BI + Python
- **Reporting**: Excel + Markdown

## Project Folder Structure
NFHS-Survey-Nutrition-Analysis/
├── data/
│   ├── raw/                
│   └── processed/      ← All 6 cleaned CSV files
├── SQL/
│   ├── schema.sql
│   ├── load_data.sql
│   └── queries.sql
├── Python/
│   ├── notebooks/
│   └── scripts/
├── PowerBI/
│   ├── dashboards/
│   └── visuals/
├── docs/
├── images/
├── README.md
├── requirements.txt
└── .gitignore


## Expected Deliverables
- Fully loaded MySQL database with all 6 tables
- Interactive Power BI Dashboard
- Python EDA Notebook with insights
- Gap Analysis Report
- Executive Summary & Recommendations

## Current Status (Updated)

- [✅] Project structure created  
- [✅] Database schema designed  
- [✅] 6 datasets identified and mapped  
- [✅] Data loaded into MySQL database  
- [✅] Exploratory Data Analysis (EDA)  
- [✅] Advanced Analysis & Gap Index  
- [✅] Power BI Dashboard development