-- =============================================
-- NFHS Hospital + Nutrition Database Schema
-- Project: NFHS-Survey-Nutrition-Analysis
-- Created: April 2026
-- =============================================

CREATE DATABASE IF NOT EXISTS nfhs_hospital;
USE nfhs_hospital;

-- Enable local infile for data loading
SET GLOBAL local_infile = 1;

-- =============================================
-- 1. CLAIMS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS state_claims_tb (
    state_ut             VARCHAR(100),
    claims_sub_2020_21   DOUBLE,
    claims_paid_2020_21  DOUBLE,
    claims_pend_2020_21  DOUBLE,
    claims_sub_2021_22   INT,
    claims_paid_2021_22  INT,
    claims_pend_2021_22  DOUBLE,
    claims_sub_2022_23   INT,
    claims_paid_2022_23  INT,
    claims_pend_2022_23  DOUBLE,
    PRIMARY KEY (state_ut)
);

-- =============================================
-- 2. INFRASTRUCTURE TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS infra_tb (
    state_ut         VARCHAR(100),
    district         VARCHAR(100),
    health_facilities INT,
    doctors          INT,
    nurses           INT,
    beds             INT,
    PRIMARY KEY (state_ut, district)
);

-- =============================================
-- 3. POSHAN (Nutrition) TABLE - District Level
-- =============================================
CREATE TABLE IF NOT EXISTS poshan_tb (
    state_ut             VARCHAR(100),
    district             VARCHAR(100),
    children_underweight DOUBLE,
    children_stunted     DOUBLE,
    children_wasted      DOUBLE,
    PRIMARY KEY (state_ut, district)
);

-- =============================================
-- 4. STATE NUTRITION (Anaemia)
-- =============================================
CREATE TABLE IF NOT EXISTS state_nutrition_tb (
    state_ut           VARCHAR(100),
    anaemia_children   DOUBLE,
    anaemia_women      DOUBLE,
    anaemia_men        DOUBLE,
    PRIMARY KEY (state_ut)
);

-- =============================================
-- 5. NFHS DISTRICT LEVEL TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS nfhs_district_tb (
    district                    VARCHAR(100),
    state_ut                    VARCHAR(100),
    hh_surveyed                 INT,
    women_15_49                 INT,
    men_15_54                   INT,
    female_school_6plus         DOUBLE,
    pop_below_15                DOUBLE,
    sex_ratio_total             DOUBLE,
    sex_ratio_birth             DOUBLE,
    birth_registered            DOUBLE,
    death_registered            DOUBLE,
    electricity                 DOUBLE,
    improved_water              DOUBLE,
    improved_sanitation         DOUBLE,
    clean_fuel                  DOUBLE,
    iodized_salt                DOUBLE,
    health_insurance            DOUBLE,
    pre_primary                 DOUBLE,
    women_literate              DOUBLE,
    women_10plus_edu            DOUBLE,
    women_married_18            DOUBLE,
    births_3plus                DOUBLE,
    teen_mother                 DOUBLE,
    hygienic_menstrual          DOUBLE,
    fp_any                      DOUBLE,
    fp_modern                   DOUBLE,
    fp_female_ster              DOUBLE,
    fp_male_ster                DOUBLE,
    fp_iud                      DOUBLE,
    fp_pill                     DOUBLE,
    fp_condom                   DOUBLE,
    fp_inject                   DOUBLE,
    unmet_fp_total              DOUBLE,
    unmet_spacing               DOUBLE,
    hw_fp_talk                  DOUBLE,
    fp_side_effects_told        DOUBLE,
    anc_1st_tri                 DOUBLE,
    anc_4plus                   DOUBLE,
    tetanus_protect             DOUBLE,
    ifa_100days                 DOUBLE,
    ifa_180days                 DOUBLE,
    mcp_card                    DOUBLE,
    pnc_mother_2days            DOUBLE,
    oop_delivery_public         DOUBLE,
    pnc_home_child_24hr         DOUBLE,
    pnc_child_2days             DOUBLE,
    inst_birth                  DOUBLE,
    inst_birth_public           DOUBLE,
    skilled_home_birth          DOUBLE,
    skilled_birth               DOUBLE,
    csection_total              DOUBLE,
    csection_private            DOUBLE,
    csection_public             DOUBLE,
    full_vac_card_mother        DOUBLE,
    full_vac_card_only          DOUBLE,
    bcg                         DOUBLE,
    polio_3                     DOUBLE,
    penta_dpt_3                 DOUBLE,
    mcv1                        DOUBLE,
    mcv2                        DOUBLE,
    rota_3                      DOUBLE,
    hepb_3                      DOUBLE,
    vit_a_6m                    DOUBLE,
    vac_most_public             DOUBLE,
    vac_most_private            DOUBLE,
    diarrhoea_prev              DOUBLE,
    ors                         DOUBLE,
    zinc                        DOUBLE,
    diarrhoea_facility          DOUBLE,
    ari_prev                    DOUBLE,
    ari_facility                DOUBLE,
    bf_within_1hr               DOUBLE,
    ebf_6m                      DOUBLE,
    comp_feed_6_8m              DOUBLE,
    bf_adequate_diet            DOUBLE,
    nonbf_adequate_diet         DOUBLE,
    total_adequate_diet         DOUBLE,
    stunted_u5                  DOUBLE,
    wasted_u5                   DOUBLE,
    sev_wasted_u5               DOUBLE,
    underweight_u5              DOUBLE,
    overweight_u5               DOUBLE,
    bmi_low_women               DOUBLE,
    bmi_high_women              DOUBLE,
    whr_high_women              DOUBLE,
    anaemia_child               DOUBLE,
    anaemia_nonpreg_women       DOUBLE,
    anaemia_preg_women          DOUBLE,
    anaemia_all_women           DOUBLE,
    anaemia_teen_women          DOUBLE,
    bs_high_women               DOUBLE,
    bs_veryhigh_women           DOUBLE,
    bs_high_or_med_women        DOUBLE,
    bs_high_men                 DOUBLE,
    bs_veryhigh_men             DOUBLE,
    bs_high_or_med_men          DOUBLE,
    bp_mild_elev_women          DOUBLE,
    bp_mod_sev_elev_women       DOUBLE,
    bp_elev_or_med_women        DOUBLE,
    bp_mild_elev_men            DOUBLE,
    bp_mod_sev_elev_men         DOUBLE,
    bp_elev_or_med_men          DOUBLE,
    cervical_screen             DOUBLE,
    breast_exam                 DOUBLE,
    oral_exam_women             DOUBLE,
    tobacco_women               DOUBLE,
    tobacco_men                 DOUBLE,
    alcohol_women               DOUBLE,
    alcohol_men                 DOUBLE,
    PRIMARY KEY (state_ut, district)
);

-- =============================================
-- 6. NFHS STATE LEVEL TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS nfhs_state_tb (
    state_ut                    VARCHAR(100) PRIMARY KEY,
    area                        VARCHAR(50),
    hh_surveyed                 INT,
    women_15_49                 INT,
    men_15_54                   INT,
    female_school_6plus         DOUBLE,
    pop_below_15                DOUBLE,
    sex_ratio_total             DOUBLE,
    sex_ratio_birth             DOUBLE,
    birth_registered            DOUBLE,
    death_registered            DOUBLE,
    electricity                 DOUBLE,
    improved_water              DOUBLE,
    improved_sanitation         DOUBLE,
    clean_fuel                  DOUBLE,
    iodized_salt                DOUBLE,
    health_insurance            DOUBLE,
    pre_primary                 DOUBLE,
    women_literate              DOUBLE,
    men_literate                DOUBLE,
    women_10plus_edu            DOUBLE,
    men_10plus_edu              DOUBLE,
    women_internet              DOUBLE,
    men_internet                DOUBLE,
    women_married_18            DOUBLE,
    men_married_21              DOUBLE,
    tfr                         DOUBLE,
    teen_mother                 DOUBLE,
    adolescent_fertility_rate   DOUBLE,
    neonatal_mr                 DOUBLE,
    infant_mr                   DOUBLE,
    under5_mr                   DOUBLE,
    -- Add remaining columns as needed (FP, ANC, Vaccination, Nutrition, etc.)
    stunted_u5                  DOUBLE,
    wasted_u5                   DOUBLE,
    underweight_u5              DOUBLE,
    anaemia_child               DOUBLE,
    anaemia_all_women           DOUBLE,
    anaemia_men                 DOUBLE
);

-- =============================================
-- Show all tables after creation
-- =============================================
SHOW TABLES;