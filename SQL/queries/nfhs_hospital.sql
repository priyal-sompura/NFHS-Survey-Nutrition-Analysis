-- Using Database For NFHS Hospital 
USE nfhs_hospital;

SHOW TABLES;

SELECT COUNT(*) AS total_rows FROM infra_tb;
SELECT COUNT(*) AS total_rows FROM nfhs_district_tb;
SELECT COUNT(*) AS total_rows FROM nfhs_state_tb;
SELECT COUNT(*) AS total_rows FROM poshan_tb;
SELECT COUNT(*) AS total_rows FROM state_claims_tb;
SELECT COUNT(*) AS total_rows FROM state_nutrition_tb;

-- 1. Total Claims Summary by State (GROUP BY + ORDER BY)
SELECT 
    state_ut,
    SUM(claims_sub_2022_23) AS total_submitted,
    SUM(claims_paid_2022_23) AS total_paid,
    ROUND(SUM(claims_paid_2022_23) / NULLIF(SUM(claims_sub_2022_23), 0) * 100, 2) AS settlement_ratio
FROM state_claims_tb
GROUP BY state_ut
ORDER BY settlement_ratio DESC;

-- 2. States with High Nutrition Burden (Anaemia + Stunting)
SELECT 
    n.state_ut,
    n.anaemia_children,
    p.children_stunted,
    ROUND((n.anaemia_children + p.children_stunted)/2, 2) AS nutrition_burden_score
FROM state_nutrition_tb n
JOIN poshan_tb p ON n.state_ut = p.state_ut
WHERE n.state_ut != 'India'
GROUP BY n.state_ut, n.anaemia_children, p.children_stunted
HAVING nutrition_burden_score > 30
ORDER BY nutrition_burden_score DESC;

-- 3. Infrastructure vs Nutrition Burden (JOIN)
SELECT 
    i.state_ut,
    SUM(i.beds) AS total_beds,
    AVG(p.children_stunted) AS avg_stunted,
    AVG(n.anaemia_children) AS avg_anaemia_children
FROM infra_tb i
JOIN poshan_tb p ON i.state_ut = p.state_ut
JOIN state_nutrition_tb n ON i.state_ut = n.state_ut
GROUP BY i.state_ut
ORDER BY total_beds ASC;

-- 4. Master Join - Claims + Nutrition + POSHAN + Infrastructure
SELECT 
    c.state_ut,
    ROUND(AVG(c.claims_paid_2022_23) / NULLIF(AVG(c.claims_sub_2022_23), 0) * 100, 2) 
        AS settlement_ratio,
    AVG(p.children_stunted) AS avg_stunted,
    AVG(p.children_underweight) AS avg_underweight,
    AVG(n.anaemia_children) AS avg_anaemia,
    SUM(i.beds) AS total_beds
FROM state_claims_tb c
JOIN poshan_tb p ON c.state_ut = p.state_ut
JOIN state_nutrition_tb n ON c.state_ut = n.state_ut
JOIN infra_tb i ON c.state_ut = i.state_ut
GROUP BY c.state_ut
ORDER BY settlement_ratio ASC;

-- 5. CTE - Gap Index Calculation 
WITH metrics AS (
    SELECT 
        c.state_ut,
        ROUND(AVG(p.children_stunted) + AVG(n.anaemia_children), 2) AS burden_score,
        ROUND(AVG(c.claims_paid_2022_23) / NULLIF(AVG(c.claims_sub_2022_23), 0) * 100, 2) 
            AS settlement_ratio,
        SUM(i.beds) AS total_beds
    FROM state_claims_tb c
    JOIN poshan_tb p ON c.state_ut = p.state_ut
    JOIN state_nutrition_tb n ON c.state_ut = n.state_ut
    JOIN infra_tb i ON c.state_ut = i.state_ut
    GROUP BY c.state_ut
)
SELECT *, 
       ROUND(burden_score / NULLIF(settlement_ratio, 0), 2) AS gap_index
FROM metrics
ORDER BY gap_index DESC;


-- 6. Multi-level CTE (District Level Analysis)
WITH state_avg AS (
    SELECT AVG(children_stunted) AS avg_stunting 
    FROM poshan_tb
),
district_data AS (
    SELECT district, state_ut, children_stunted 
    FROM poshan_tb
)
SELECT d.*, s.avg_stunting,
       CASE WHEN d.children_stunted > s.avg_stunting THEN 'High Burden' 
            ELSE 'Low Burden' END AS burden_status
FROM district_data d
CROSS JOIN state_avg s
ORDER BY d.children_stunted DESC;

-- 7. Ranking States by Gap Index (WINDOW FUNCTION)
WITH gap AS (
    SELECT 
        c.state_ut,
        ROUND(AVG(p.children_stunted) + AVG(n.anaemia_children), 2) AS burden_score,
        ROUND(AVG(c.claims_paid_2022_23)/NULLIF(AVG(c.claims_sub_2022_23),0)*100, 2) AS settlement_ratio
    FROM state_claims_tb c
    JOIN poshan_tb p ON c.state_ut = p.state_ut
    JOIN state_nutrition_tb n ON c.state_ut = n.state_ut
    GROUP BY c.state_ut
)
SELECT *,
       RANK() OVER (ORDER BY (burden_score / NULLIF(settlement_ratio,0)) DESC) AS gap_rank
FROM gap
ORDER BY gap_rank;

-- 8. District Ranking within Each State (PARTITION BY)
SELECT 
    district,
    state_ut,
    children_stunted,
    RANK() OVER (PARTITION BY state_ut ORDER BY children_stunted DESC) AS rank_in_state,
    ROW_NUMBER() OVER (ORDER BY children_stunted DESC) AS national_rank
FROM poshan_tb
ORDER BY state_ut, rank_in_state;

-- 9. POSHAN Trend Analysis using LAG (Window Function)
SELECT 
    state_ut,
    children_stunted AS stunted_latest,
    LAG(children_stunted) OVER (PARTITION BY state_ut ORDER BY district) AS previous_stunted
FROM poshan_tb;

-- 10. Categorization using CASE Statement
SELECT 
    state_ut,
    children_stunted,
    CASE 
        WHEN children_stunted >= 40 THEN 'Very High'
        WHEN children_stunted >= 35 THEN 'High'
        WHEN children_stunted >= 25 THEN 'Moderate'
        ELSE 'Low'
    END AS stunting_category
FROM poshan_tb
GROUP BY state_ut, children_stunted
ORDER BY children_stunted DESC;

-- 11. Top 10 High Gap Districts
SELECT 
    d.district,
    d.state_ut,
    d.children_stunted,
    d.children_underweight,
    ROUND(c.claims_paid_2022_23 / NULLIF(c.claims_sub_2022_23,0)*100, 2) AS settlement_ratio,
    ROUND((d.children_stunted + d.children_underweight)/2, 2) AS burden_score
FROM poshan_tb d
JOIN state_claims_tb c ON d.state_ut = c.state_ut
ORDER BY burden_score / NULLIF((c.claims_paid_2022_23 / NULLIF(c.claims_sub_2022_23,0)*100),0) DESC
LIMIT 10;


-- 12. Master View
CREATE OR REPLACE VIEW master_health_view AS
SELECT
    c.state_ut,
    
    -- Claims Settlement Ratio (2022-23)
    ROUND(
        SUM(c.claims_paid_2022_23) / NULLIF(SUM(c.claims_sub_2022_23), 0) * 100, 
    2) AS settlement_ratio,
    
    -- Nutrition (Poshan)
    AVG(p.children_stunted)     AS avg_stunted,
    AVG(p.children_wasted)      AS avg_wasted,
    AVG(p.children_underweight) AS avg_underweight,
    
    -- Anaemia
    AVG(n.anaemia_children)     AS avg_anaemia_children,
    
    -- Infrastructure
    SUM(i.beds)                 AS total_beds,
    SUM(i.health_facilities)    AS total_facilities,
    SUM(i.doctors)              AS total_doctors,
    SUM(i.nurses)               AS total_nurses

FROM state_claims_tb c
JOIN poshan_tb p ON c.state_ut = p.state_ut
JOIN state_nutrition_tb n ON c.state_ut = n.state_ut
JOIN infra_tb i ON c.state_ut = i.state_ut
GROUP BY c.state_ut;

SELECT * 
FROM master_health_view 
ORDER BY settlement_ratio ASC, avg_stunted DESC;


-- 13. Top Gap Districts for a State (Stored Procedure)
DELIMITER //
CREATE PROCEDURE GetTopGapDistricts(IN input_state VARCHAR(100), IN top_n INT)
BEGIN
    SELECT 
        district,
        children_stunted,
        children_underweight,
        ROUND((children_stunted + children_underweight)/2, 2) AS burden_score,
        ROUND(c.claims_paid_2022_23 / NULLIF(c.claims_sub_2022_23,0)*100, 2) AS settlement_ratio,
        RANK() OVER (ORDER BY (children_stunted + children_underweight) DESC) AS rank_no
    FROM poshan_tb p
    JOIN state_claims_tb c ON p.state_ut = c.state_ut
    WHERE p.state_ut = input_state
    ORDER BY burden_score DESC
    LIMIT top_n;
END //
DELIMITER ;

CALL GetTopGapDistricts('Bihar', 10);


-- 15. Stored Procedure - National Gap Report
DELIMITER //
CREATE PROCEDURE NationalGapReport()
BEGIN
    SELECT 
        state_ut,
        AVG(children_stunted) AS avg_stunting,
        ROUND(AVG(claims_paid_2022_23 / NULLIF(claims_sub_2022_23,0)*100), 2) AS avg_settlement,
        SUM(beds) AS total_beds
    FROM poshan_tb p
    JOIN state_claims_tb c ON p.state_ut = c.state_ut
    JOIN infra_tb i ON p.state_ut = i.state_ut
    GROUP BY state_ut
    ORDER BY (AVG(children_stunted) / NULLIF(AVG(claims_paid_2022_23 / NULLIF(claims_sub_2022_23,0)*100),0)) DESC;
END //
DELIMITER ;


-- 16. Pending Claims Analysis
SELECT 
    state_ut,
    claims_pend_2022_23,
    claims_sub_2022_23,
    ROUND(claims_pend_2022_23 / NULLIF(claims_sub_2022_23,0) * 100, 2) AS pending_percentage
FROM state_claims_tb
ORDER BY pending_percentage DESC;


-- 17. NFHS District vs State Comparison
SELECT 
    d.state_ut,
    AVG(d.stunted_u5) AS district_stunted,
    AVG(n.anaemia_children) AS state_anaemia
FROM nfhs_district_tb d
JOIN state_nutrition_tb n ON d.state_ut = n.state_ut
GROUP BY d.state_ut
ORDER BY district_stunted DESC;

-- 18. High Anaemia States
SELECT 
    state_ut,
    anaemia_children,
    anaemia_women,
    anaemia_men
FROM state_nutrition_tb
ORDER BY anaemia_children DESC;

-- 19. POSHAN Reduction Trend
SELECT 
    state_ut,
    AVG(children_stunted) AS avg_stunted
FROM poshan_tb
GROUP BY state_ut
ORDER BY avg_stunted ASC;

-- 20. Final Comprehensive Ranking
WITH master_data AS (
    SELECT 
        c.state_ut,
        ROUND(AVG(p.children_stunted), 2) AS avg_stunted,
        ROUND(AVG(c.claims_paid_2022_23) / NULLIF(AVG(c.claims_sub_2022_23), 0) * 100, 2) 
            AS settlement_ratio,
        SUM(i.beds) AS total_beds
    FROM state_claims_tb c
    JOIN poshan_tb p ON c.state_ut = p.state_ut
    JOIN infra_tb i ON c.state_ut = i.state_ut
    GROUP BY c.state_ut
)
SELECT *,
       ROUND(avg_stunted / NULLIF(settlement_ratio, 0), 2) AS gap_index,
       RANK() OVER (ORDER BY (avg_stunted / NULLIF(settlement_ratio, 0)) DESC) AS final_rank
FROM master_data
ORDER BY final_rank
LIMIT 15;