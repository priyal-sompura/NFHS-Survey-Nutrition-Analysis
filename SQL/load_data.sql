-- =============================================
-- LOAD DATA SCRIPT - NFHS Nutrition & Hospital Analysis
-- Project: NFHS-Survey-Nutrition-Analysis
-- Created: April 2026
-- =============================================

USE nfhs_hospital;

-- Enable loading local files
SET GLOBAL local_infile = 1;

-- =============================================
-- 1. Load State Claims Data
-- =============================================
LOAD DATA LOCAL INFILE 'C:/Users/Priyal/FlyTheNest/NFHS-Survey-Nutrition-Analysis/data/raw/claims_clean.csv'
INTO TABLE state_claims_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =============================================
-- 2. Load Health Infrastructure Data
-- =============================================
LOAD DATA LOCAL INFILE 'C:/Users/Priyal/FlyTheNest/NFHS-Survey-Nutrition-Analysis/data/raw/infra_clean.csv'
INTO TABLE infra_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =============================================
-- 3. Load POSHAN Nutrition Data
-- =============================================
LOAD DATA LOCAL INFILE 'C:/Users/Priyal/FlyTheNest/NFHS-Survey-Nutrition-Analysis/data/raw/poshan_clean.csv'
INTO TABLE poshan_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =============================================
-- 4. Load State Nutrition (Anaemia) Data
-- =============================================
LOAD DATA LOCAL INFILE 'C:/Users/Priyal/FlyTheNest/NFHS-Survey-Nutrition-Analysis/data/raw/state_nutrition_clean.csv'
INTO TABLE state_nutrition_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =============================================
-- 5. Load NFHS-5 District Level Data
-- =============================================
LOAD DATA LOCAL INFILE 'C:/Users/Priyal/FlyTheNest/NFHS-Survey-Nutrition-Analysis/data/raw/nfhs_district_clean.csv'
INTO TABLE nfhs_district_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =============================================
-- 6. Load NFHS-5 State Level Data
-- =============================================
LOAD DATA LOCAL INFILE 'C:/Users/Priyal/FlyTheNest/NFHS-Survey-Nutrition-Analysis/data/raw/nfhs_state_clean.csv'
INTO TABLE nfhs_state_tb
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =============================================
-- Verification - Row Counts
-- =============================================
SELECT 
    'state_claims_tb'     AS table_name, COUNT(*) AS row_count FROM state_claims_tb
UNION ALL
SELECT 
    'infra_tb'            AS table_name, COUNT(*) FROM infra_tb
UNION ALL
SELECT 
    'poshan_tb'           AS table_name, COUNT(*) FROM poshan_tb
UNION ALL
SELECT 
    'state_nutrition_tb'  AS table_name, COUNT(*) FROM state_nutrition_tb
UNION ALL
SELECT 
    'nfhs_district_tb'    AS table_name, COUNT(*) FROM nfhs_district_tb
UNION ALL
SELECT 
    'nfhs_state_tb'       AS table_name, COUNT(*) FROM nfhs_state_tb
ORDER BY table_name;