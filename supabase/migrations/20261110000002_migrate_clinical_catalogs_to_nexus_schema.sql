-- ==============================================================================
-- JMC NEXUS: MIGRATE CLINICAL CATALOGS TO SCHEMA 'nexus'
-- Migrates Diagnoses, Protocols, Comorbidities, Complaints, Sub-questions, and Exams
-- Leaves 'public.drugmaster' as the master drugs repository (no drug table created).
-- ==============================================================================

-- 1. Ensure Schema Exists
CREATE SCHEMA IF NOT EXISTS nexus;

-- 2. Comorbidities Catalog
CREATE TABLE IF NOT EXISTS nexus.comorbidities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    contraindicated_drug_classes JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INT NOT NULL DEFAULT 1,
    deleted_at TIMESTAMPTZ
);

-- 3. Presenting Complaints Catalog
CREATE TABLE IF NOT EXISTS nexus.presenting_complaints (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INT NOT NULL DEFAULT 1,
    deleted_at TIMESTAMPTZ
);

-- 4. Complaint Sub-Questions Catalog
CREATE TABLE IF NOT EXISTS nexus.complaint_sub_questions (
    id TEXT PRIMARY KEY,
    complaint_id TEXT NOT NULL REFERENCES nexus.presenting_complaints(id) ON DELETE CASCADE,
    question_label TEXT NOT NULL,
    options_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    sentence_template TEXT NOT NULL DEFAULT '',
    is_multi_select BOOLEAN NOT NULL DEFAULT false,
    sequence_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INT NOT NULL DEFAULT 1,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_nexus_sub_questions_complaint ON nexus.complaint_sub_questions(complaint_id);

-- 5. Examination Systems Catalog
CREATE TABLE IF NOT EXISTS nexus.examination_systems (
    id TEXT PRIMARY KEY,
    system_name TEXT NOT NULL,
    default_normal_text TEXT NOT NULL,
    abnormal_findings_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INT NOT NULL DEFAULT 1,
    deleted_at TIMESTAMPTZ
);

-- 6. Diagnoses Master Catalog
CREATE TABLE IF NOT EXISTS nexus.diagnoses (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    icd10_code TEXT,
    linked_complaint_ids JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INT NOT NULL DEFAULT 1,
    deleted_at TIMESTAMPTZ
);

-- 7. Prescription Protocols Catalog
CREATE TABLE IF NOT EXISTS nexus.prescription_protocols (
    id TEXT PRIMARY KEY,
    diagnosis_id TEXT NOT NULL REFERENCES nexus.diagnoses(id) ON DELETE CASCADE,
    protocol_items_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    general_advice TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INT NOT NULL DEFAULT 1,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_nexus_protocols_diagnosis ON nexus.prescription_protocols(diagnosis_id);

-- 8. Grants and Permissions
GRANT USAGE ON SCHEMA nexus TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA nexus TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA nexus GRANT ALL ON TABLES TO anon, authenticated, service_role;

-- 9. Enable Row Level Security (RLS)
ALTER TABLE nexus.comorbidities ENABLE ROW LEVEL SECURITY;
ALTER TABLE nexus.presenting_complaints ENABLE ROW LEVEL SECURITY;
ALTER TABLE nexus.complaint_sub_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE nexus.examination_systems ENABLE ROW LEVEL SECURITY;
ALTER TABLE nexus.diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE nexus.prescription_protocols ENABLE ROW LEVEL SECURITY;

-- 10. RLS Policies
CREATE POLICY "Allow read access to comorbidities" ON nexus.comorbidities FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Allow write access to comorbidities" ON nexus.comorbidities FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Allow read access to complaints" ON nexus.presenting_complaints FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Allow write access to complaints" ON nexus.presenting_complaints FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Allow read access to complaint subquestions" ON nexus.complaint_sub_questions FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Allow write access to complaint subquestions" ON nexus.complaint_sub_questions FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Allow read access to exam systems" ON nexus.examination_systems FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Allow write access to exam systems" ON nexus.examination_systems FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Allow read access to diagnoses" ON nexus.diagnoses FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Allow write access to diagnoses" ON nexus.diagnoses FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Allow read access to protocols" ON nexus.prescription_protocols FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Allow write access to protocols" ON nexus.prescription_protocols FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 11. Seed Data Insertions
INSERT INTO nexus.comorbidities (id, name, contraindicated_drug_classes) VALUES
('comorb_ckd', 'Chronic Kidney Disease (CKD)', '["NSAID", "Metformin"]'::jsonb),
('comorb_dm', 'Type 2 Diabetes Mellitus', '["Systemic Steroids", "Corticosteroids"]'::jsonb),
('comorb_htn', 'Hypertension', '["Decongestants", "NSAID"]'::jsonb),
('comorb_asthma', 'Bronchial Asthma', '["Non-selective Beta Blockers", "Aspirin", "NSAID"]'::jsonb),
('comorb_pregnant', 'Pregnancy', '["Fluoroquinolones", "Tetracyclines", "ACE Inhibitors", "NSAID"]'::jsonb),
('comorb_pud', 'Peptic Ulcer Disease', '["NSAID", "Aspirin", "Systemic Steroids", "Corticosteroids"]'::jsonb),
('comorb_cad', 'Coronary Artery Disease (CAD)', '["NSAID"]'::jsonb),
('comorb_copd', 'COPD', '["Non-selective Beta Blockers", "Sedatives"]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
contraindicated_drug_classes = EXCLUDED.contraindicated_drug_classes,
updated_at = now();

INSERT INTO nexus.presenting_complaints (id, name, category, display_order) VALUES
('pc_fever', 'Fever', 'General', 1),
('pc_cough', 'Cough', 'RS', 2),
('pc_sob', 'Shortness of Breath', 'RS', 3),
('pc_chest_pain', 'Chest Pain', 'CVS', 4),
('pc_abd_pain', 'Abdominal Pain', 'GI', 5),
('pc_vomiting', 'Vomiting', 'GI', 6),
('pc_loose_stools', 'Loose Stools / Diarrhea', 'GI', 7),
('pc_dysuria', 'Dysuria (Burning Urination)', 'Renal', 8),
('pc_heartburn', 'Heartburn / Acid Regurgitation', 'GI', 9),
('pc_headache', 'Headache', 'CNS', 10)
ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
category = EXCLUDED.category,
display_order = EXCLUDED.display_order,
updated_at = now();

INSERT INTO nexus.complaint_sub_questions (id, complaint_id, question_label, options_json, sentence_template, is_multi_select, sequence_order) VALUES
('sq_fever_dur', 'pc_fever', 'Duration', '["Custom..."]'::jsonb, 'Duration: {option}', false, 1),
('sq_fever_grade', 'pc_fever', 'Grade / Type', '["Low grade", "High grade", "Intermittent with chills"]'::jsonb, '{option} fever', false, 2),
('sq_fever_assoc', 'pc_fever', 'Associated Symptoms', '["Body aches", "Chills & rigors", "Sweating", "Headache"]'::jsonb, 'associated with {option}', true, 3),
('sq_diarrhea_dur', 'pc_loose_stools', 'Duration', '["Custom..."]'::jsonb, 'since {option}', false, 1),
('sq_diarrhea_freq', 'pc_loose_stools', 'Frequency', '["2-3 episodes/day", "4-6 episodes/day", ">6 episodes/day"]'::jsonb, '{option}', false, 2),
('sq_diarrhea_char', 'pc_loose_stools', 'Consistency', '["Watery", "Semi-solid", "Mucoid", "Bloody"]'::jsonb, '{option} consistency', false, 3),
('sq_diarrhea_cramps', 'pc_loose_stools', 'Cramping', '["Mild cramping", "Severe colicky pain", "No cramps"]'::jsonb, 'with {option}', false, 4),
('sq_vomiting_freq', 'pc_vomiting', 'Duration', '["Custom..."]'::jsonb, 'for {option}', false, 1),
('sq_vomiting_nature', 'pc_vomiting', 'Content', '["Food particles", "Bilious/yellowish", "Watery non-bilious"]'::jsonb, '{option} vomitus', false, 2),
('sq_dysuria_dur', 'pc_dysuria', 'Duration', '["Custom..."]'::jsonb, 'for {option}', false, 1),
('sq_dysuria_assoc', 'pc_dysuria', 'Associated Urinary Symptoms', '["Increased frequency", "Urgency", "Hesitancy", "Suprapubic pain"]'::jsonb, 'with {option}', true, 2),
('sq_dysuria_hem', 'pc_dysuria', 'Hematuria', '["No hematuria", "Pinkish tinge", "Frank blood"]'::jsonb, '{option}', false, 3),
('sq_heartburn_time', 'pc_heartburn', 'Timing / Trigger', '["After spicy meals", "Empty stomach (fasting)", "Night / recumbent"]'::jsonb, 'worse {option}', false, 1),
('sq_heartburn_rad', 'pc_heartburn', 'Radiation', '["Retrosternal burning", "Throat irritation", "Localized epigastric"]'::jsonb, '{option}', false, 2),
('sq_sob_onset', 'pc_sob', 'Onset', '["Sudden onset", "Gradual worsening over days"]'::jsonb, '{option}', false, 1),
('sq_sob_triggers', 'pc_sob', 'Trigger Exposure', '["Cold air", "Dust / smoke", "Physical exertion", "Night exacerbation"]'::jsonb, 'triggered by {option}', true, 2),
('sq_sob_wheeze', 'pc_sob', 'Wheezing', '["Audible wheeze present", "Chest tightness without wheeze"]'::jsonb, '{option}', false, 3),
('sq_cough_type', 'pc_cough', 'Cough Type', '["Dry irritating cough", "Productive / mucoid", "Yellowish sputum"]'::jsonb, '{option}', false, 1),
('sq_cough_dur', 'pc_cough', 'Duration', '["Custom..."]'::jsonb, 'for {option}', false, 2)
ON CONFLICT (id) DO UPDATE SET
complaint_id = EXCLUDED.complaint_id,
question_label = EXCLUDED.question_label,
options_json = EXCLUDED.options_json,
sentence_template = EXCLUDED.sentence_template,
is_multi_select = EXCLUDED.is_multi_select,
sequence_order = EXCLUDED.sequence_order,
updated_at = now();

INSERT INTO nexus.examination_systems (id, system_name, default_normal_text, abnormal_findings_json) VALUES
('sys_cvs', 'CVS', 'S1 S2 heard, regular rate & rhythm, no murmurs', '["Tachycardia", "Bradycardia", "Systolic Murmur", "Muffled heart sounds"]'::jsonb),
('sys_rs', 'RS', 'Bilateral Normal Vesicular Breath Sounds (NVBS), no added sounds', '["Bilateral diffuse polyphonic wheeze", "Basal fine crepitations", "Coarse crackles", "Decreased air entry Right", "Decreased air entry Left", "Prolonged expiratory phase"]'::jsonb),
('sys_pa', 'Per Abdomen', 'Soft, non-tender, normal bowel sounds, no organomegaly', '["Mild epigastric tenderness", "Suprapubic tenderness", "Diffuse tenderness, hyperactive bowel sounds", "Guarding / rigidity present", "Right iliac fossa (McBurney) tenderness", "Renal angle tenderness"]'::jsonb),
('sys_cns', 'CNS', 'Conscious, oriented to time, place, and person, no focal deficits', '["Anxious / restless", "Lethargic / drowsy", "Neck stiffness / meningeal signs present", "Disoriented"]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
system_name = EXCLUDED.system_name,
default_normal_text = EXCLUDED.default_normal_text,
abnormal_findings_json = EXCLUDED.abnormal_findings_json,
updated_at = now();

INSERT INTO nexus.diagnoses (id, name, icd10_code, linked_complaint_ids) VALUES
('diag_age', 'Acute Gastroenteritis', 'A09', '["pc_loose_stools", "pc_vomiting", "pc_abd_pain", "pc_fever"]'::jsonb),
('diag_urti', 'Viral Upper Respiratory Tract Infection (URTI)', 'J06.9', '["pc_fever", "pc_cough", "pc_headache"]'::jsonb),
('diag_uti', 'Acute Uncomplicated Urinary Tract Infection (UTI)', 'N30.0', '["pc_dysuria", "pc_abd_pain", "pc_fever"]'::jsonb),
('diag_apd', 'Acid Peptic Disease / GERD', 'K21.9', '["pc_heartburn", "pc_abd_pain", "pc_vomiting"]'::jsonb),
('diag_asthma', 'Bronchial Asthma (Acute Exacerbation)', 'J45.901', '["pc_sob", "pc_cough"]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
icd10_code = EXCLUDED.icd10_code,
linked_complaint_ids = EXCLUDED.linked_complaint_ids,
updated_at = now();

INSERT INTO nexus.prescription_protocols (id, diagnosis_id, protocol_items_json, general_advice) VALUES
('proto_age', 'diag_age',
'[{"drugId": "drug_ors"}, {"drugId": "drug_ondansetron"}, {"drugId": "drug_oflox_oz"}, {"drugId": "drug_dicyclomine_pcm", "doseOverride": "1 tab SOS", "instructionsOverride": "Take only for severe cramping spasms after meals"}, {"drugId": "drug_probiotic"}]'::jsonb,
'Hydrate well with ORS, coconut water, and rice kanji. Bland diet (curd rice, bananas, toast). Strictly avoid dairy milk, spicy, and outside food. Return immediately if inability to retain liquids, severe dehydration, or high fever.'),
('proto_urti', 'diag_urti',
'[{"drugId": "drug_pcm_650"}, {"drugId": "drug_levocet_mont"}, {"drugId": "drug_cough_syp"}, {"drugId": "drug_vit_c_zinc"}]'::jsonb,
'Warm saline gargles 3-4 times daily. Steam inhalation twice daily. Adequate bed rest and oral hydration. Monitor temperature every 6 hours.'),
('proto_uti', 'diag_uti',
'[{"drugId": "drug_nitrofurantoin"}, {"drugId": "drug_citrate_alkalizer"}, {"drugId": "drug_pcm_650", "doseOverride": "650 mg SOS", "instructionsOverride": "For fever or severe dysuria/pelvic pain"}]'::jsonb,
'Drink minimum 3 to 4 liters of water daily. Do not suppress or delay urination. Urinate post-coitus. Complete full 5-day antibiotic course even if symptoms subside earlier.'),
('proto_apd', 'diag_apd',
'[{"drugId": "drug_pan_d"}, {"drugId": "drug_antacid_gel"}, {"drugId": "drug_sucralfate"}]'::jsonb,
'Small, frequent meals on fixed timings. Avoid spicy, citrus, coffee, tea, and deep-fried foods. Avoid lying down for 2 hours post meals. Elevate head end of bed by 6 inches.'),
('proto_asthma', 'diag_asthma',
'[{"drugId": "drug_duolin_resp"}, {"drugId": "drug_foracort_200"}, {"drugId": "drug_prednisolone_20"}, {"drugId": "drug_deriphyllin"}]'::jsonb,
'Use inhaler strictly with a spacer. Always rinse mouth thoroughly after steroid inhaler to prevent candidiasis. Avoid known triggers (dust, smoke, cold air). Visit Emergency Room immediately if acute breathlessness worsens or chest tightness is severe.')
ON CONFLICT (id) DO UPDATE SET
diagnosis_id = EXCLUDED.diagnosis_id,
protocol_items_json = EXCLUDED.protocol_items_json,
general_advice = EXCLUDED.general_advice,
updated_at = now();

