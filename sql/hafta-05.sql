CREATE TABLE diet_raw (
    patient_id text, age int, gender text, weight_kg numeric, height_cm int, bmi numeric,
    disease_type text, severity text, physical_activity_level text,
    daily_caloric_intake int, cholesterol_mg_dl numeric, blood_pressure_mmhg int,
    glucose_mg_dl numeric, dietary_restrictions text, allergies text,
    preferred_cuisine text, weekly_exercise_hours numeric,
    adherence_to_diet_plan numeric, dietary_nutrient_imbalance_score numeric,
    diet_recommendation text
);

--Patient_ID numarasina gore sabit (tekrar edilebilir) atama
CREATE VIEW diet AS
SELECT *,
  CASE WHEN substr(patient_id, 2)::int % 2 = 0 THEN 'v2' ELSE 'v1' END AS prompt_version,
  DATE '2026-09-01' + (substr(patient_id, 2)::int % 61) AS recommended_at,
  (adherence_to_diet_plan >= 70) AS is_completed
FROM diet_raw;

Veri kartına da ekle: prompt_version: ID çift ise v2, tek ise v1; recommended_at: 1 Eylül 2026 + ID mod 61 gün; is_completed: uyum ≥ 70.

2. sql/hafta-05.sql
sql
-- Sorgu 1 (GROUP BY, CASE WHEN)
-- Soru: Prompt surumune gore oneri sayisi ve tamamlama orani nedir?
-- Beklenti: Surumler rastgele atandigi icin iki oran birbirine yakin olmali.
SELECT prompt_version,
       COUNT(*) AS oneri_sayisi,
       ROUND(100.0 * SUM(CASE WHEN is_completed THEN 1 ELSE 0 END) / COUNT(*), 1) AS tamamlama_orani
FROM diet
GROUP BY prompt_version
ORDER BY prompt_version;

-- Sorgu 2 (NULL: NULLIF, COUNT)
-- Soru: Hastalik bilgisi olmayan (None) oneriler ve eksik uyum kaydi kac tane?
-- Beklenti: Disease_Type'ta yaklasik 204 "None" cikmali; uyum sutununda eksik olmamali.
SELECT prompt_version,
       COUNT(*) AS toplam,
       SUM(CASE WHEN NULLIF(disease_type, 'None') IS NULL THEN 1 ELSE 0 END) AS hastaliksiz,
       COUNT(*) - COUNT(adherence_to_diet_plan) AS eksik_uyum_kaydi
FROM diet
GROUP BY prompt_version;

-- Sorgu 3 (GROUP BY, HAVING)
-- Soru: Her surumde en az 50 onerisi olan diyet turleri hangileri?
-- Beklenti: Uc diyet turunun (Balanced, Low_Sodium, Low_Carb) hepsi 50'yi gecmeli.
SELECT diet_recommendation, prompt_version, COUNT(*) AS oneri_sayisi
FROM diet
GROUP BY diet_recommendation, prompt_version
HAVING COUNT(*) >= 50
ORDER BY diet_recommendation, prompt_version;

-- Sorgu 4 (CASE WHEN)
-- Soru: Haftalik egzersiz suresi short/medium/long gruplarinda surumlere gore dagilim nasil?
-- Beklenti: Dagilim iki surumde benzer olmali (atama rastgele).
SELECT prompt_version,
       CASE WHEN weekly_exercise_hours < 3 THEN 'short'
            WHEN weekly_exercise_hours < 6 THEN 'medium'
            ELSE 'long' END AS sure_grubu,
       COUNT(*) AS oneri_sayisi
FROM diet
GROUP BY prompt_version, sure_grubu
ORDER BY prompt_version, sure_grubu;

-- Sorgu 5 (tarih fonksiyonu: date_trunc)
-- Soru: Haftalik tamamlama orani iki surum icin nasil degisiyor?
-- Beklenti: Haftalar arasi kucuk dalgalanma, iki surum yakin.
SELECT date_trunc('week', recommended_at)::date AS hafta,
       prompt_version,
       COUNT(*) AS oneri_sayisi,
       ROUND(100.0 * SUM(CASE WHEN is_completed THEN 1 ELSE 0 END) / COUNT(*), 1) AS tamamlama_orani
FROM diet
GROUP BY hafta, prompt_version
ORDER BY hafta, prompt_version;
