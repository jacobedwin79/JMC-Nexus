-- ==============================================================================
-- JMC NEXUS: EXPAND CLINICAL CATALOGS IN SCHEMA 'nexus'
-- Adds 30 common diagnoses, 20 comorbidities, 30 presenting complaints with
-- sub-questions, and 4 new examination systems (ENT, Eye, MSK, Skin) + enriched findings.
-- Leaves 'public.drugmaster' untouched.
-- ==============================================================================

-- 1. Insert 20 Additional Comorbidities
INSERT INTO nexus.comorbidities (id, name, contraindicated_drug_classes) VALUES
('comorb_cirrhosis', 'Chronic Liver Disease / Cirrhosis', '["Paracetamol (High Dose)", "NSAID", "Sedatives", "Statins (Decompensated)"]'::jsonb),
('comorb_gout', 'Gout / Hyperuricemia', '["Thiazide Diuretics", "Loop Diuretics", "Aspirin (Low Dose)"]'::jsonb),
('comorb_glaucoma', 'Angle-Closure Glaucoma', '["Anticholinergics", "Tricyclic Antidepressants", "Topical Steroids", "Antihistamines (First Gen)"]'::jsonb),
('comorb_bph', 'Benign Prostatic Hyperplasia (BPH)', '["Anticholinergics", "First-gen Antihistamines", "Decongestants"]'::jsonb),
('comorb_epilepsy', 'Epilepsy / Seizure Disorder', '["Tramadol", "Fluoroquinolones", "Bupropion", "Meperidine"]'::jsonb),
('comorb_chf', 'Congestive Heart Failure (CHF)', '["NSAID", "Thiazolidinediones", "Non-DHP Calcium Channel Blockers", "Corticosteroids"]'::jsonb),
('comorb_atrial_fib', 'Atrial Fibrillation', '["Macrolides (QT Prolonging)", "Fluoroquinolones (QT Prolonging)", "Decongestants"]'::jsonb),
('comorb_parkinsons', 'Parkinson''s Disease', '["First-gen Antipsychotics", "Metoclopramide", "Prochlorperazine"]'::jsonb),
('comorb_gerd', 'Gastroesophageal Reflux Disease (GERD)', '["NSAID", "Bisphosphonates", "Calcium Channel Blockers"]'::jsonb),
('comorb_thyrotoxicosis', 'Hyperthyroidism / Thyrotoxicosis', '["Amiodarone", "Decongestants", "Sympathomimetics"]'::jsonb),
('comorb_hypothyroidism', 'Hypothyroidism', '["Sedatives (High Sensitivity)", "Amiodarone"]'::jsonb),
('comorb_ibd', 'Inflammatory Bowel Disease (UC/Crohn''s)', '["NSAID", "Opioids (Toxic Megacolon)"]'::jsonb),
('comorb_osteoporosis', 'Severe Osteoporosis', '["Long-term Systemic Steroids", "Loop Diuretics"]'::jsonb),
('comorb_g6pd', 'G6PD Deficiency', '["Sulfonamides", "Nitrofurantoin", "Primaquine", "Rasburicase", "Dapsone"]'::jsonb),
('comorb_myasthenia', 'Myasthenia Gravis', '["Aminoglycosides", "Fluoroquinolones", "Beta Blockers", "Macrolides"]'::jsonb),
('comorb_hyperkalemia', 'Hyperkalemia Tendency', '["Potassium-Sparing Diuretics", "ACE Inhibitors", "ARBs", "NSAID"]'::jsonb),
('comorb_lactation', 'Lactating Mother / Breastfeeding', '["Chloramphenicol", "Tetracyclines", "Codeine", "Amiodarone"]'::jsonb),
('comorb_depression', 'Major Depressive Disorder (on SSRI/MAOI)', '["Tramadol", "Dextromethorphan", "Linezolid", "Triptans"]'::jsonb),
('comorb_pvd', 'Peripheral Vascular Disease', '["Non-selective Beta Blockers", "Ergot Alkaloids"]'::jsonb),
('comorb_coagulopathy', 'Bleeding Disorder / On Anticoagulants', '["NSAID", "Aspirin", "Antiplatelets", "IM Injections"]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
contraindicated_drug_classes = EXCLUDED.contraindicated_drug_classes,
updated_at = now();

-- 2. Insert 30 Additional Presenting Complaints
INSERT INTO nexus.presenting_complaints (id, name, category, display_order) VALUES
('pc_fatigue', 'Fatigue / General Weakness', 'General', 11),
('pc_weight_loss', 'Unintentional Weight Loss', 'General', 12),
('pc_edema', 'Bilateral Leg Swelling / Pedal Edema', 'General', 13),
('pc_sore_throat', 'Sore Throat / Pharyngeal Pain', 'ENT', 14),
('pc_ear_pain', 'Ear Pain / Otalgia', 'ENT', 15),
('pc_ear_discharge', 'Ear Discharge / Otorrhea', 'ENT', 16),
('pc_nasal_discharge', 'Runny Nose / Rhinorrhea / Sneezing', 'ENT', 17),
('pc_nasal_congestion', 'Nasal Congestion / Blockage', 'ENT', 18),
('pc_epistaxis', 'Nosebleed / Epistaxis', 'ENT', 19),
('pc_hemoptysis', 'Coughing Blood / Hemoptysis', 'RS', 20),
('pc_throat_clearing', 'Post-Nasal Drip / Chronic Throat Clearing', 'RS', 21),
('pc_palpitations', 'Palpitations / Rapid Heartbeat', 'CVS', 22),
('pc_claudication', 'Calf Pain on Walking / Claudication', 'CVS', 23),
('pc_constipation', 'Constipation / Difficulty Defecating', 'GI', 24),
('pc_bloating', 'Abdominal Bloating / Flatulence', 'GI', 25),
('pc_bleeding_pr', 'Rectal Bleeding / Fresh Blood in Stools', 'GI', 26),
('pc_dysphagia', 'Difficulty Swallowing / Dysphagia', 'GI', 27),
('pc_low_back_pain', 'Low Back Pain / Lumbago', 'MSK', 28),
('pc_knee_pain', 'Knee Joint Pain / Arthralgia', 'MSK', 29),
('pc_neck_pain', 'Neck Pain / Cervical Spondylosis', 'MSK', 30),
('pc_shoulder_pain', 'Shoulder Pain / Restricted Movement', 'MSK', 31),
('pc_polyarthralgia', 'Multiple Joint Pain / Morning Stiffness', 'MSK', 32),
('pc_rash', 'Itchy Skin Rash / Pruritus', 'Skin', 33),
('pc_urticaria', 'Hives / Wheals (Urticaria)', 'Skin', 34),
('pc_boil', 'Painful Boil / Cutaneous Abscess', 'Skin', 35),
('pc_red_eye', 'Eye Redness / Conjunctivitis', 'Eye', 36),
('pc_eye_discharge', 'Watery / Mucopurulent Eye Discharge', 'Eye', 37),
('pc_dizziness', 'Dizziness / Lightheadedness / Vertigo', 'CNS', 38),
('pc_insomnia', 'Difficulty Sleeping / Insomnia', 'CNS', 39),
('pc_anxiety', 'Anxiety / Panic / Nervousness', 'CNS', 40)
ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
category = EXCLUDED.category,
display_order = EXCLUDED.display_order,
updated_at = now();

-- 3. Insert Sub-Questions for New Complaints
INSERT INTO nexus.complaint_sub_questions (id, complaint_id, question_label, options_json, sentence_template, is_multi_select, sequence_order) VALUES
('sq_fatigue_dur', 'pc_fatigue', 'Duration', '["< 2 weeks", "2-4 weeks", "> 1 month", "> 6 months"]'::jsonb, 'fatigue lasting {option}', false, 1),
('sq_fatigue_pattern', 'pc_fatigue', 'Pattern', '["Constant throughout day", "Worse in morning", "Worse after exertion", "Associated with unrefreshing sleep"]'::jsonb, 'pattern: {option}', false, 2),
('sq_wtloss_quant', 'pc_weight_loss', 'Amount & Duration', '["2-4 kg over month", "> 5 kg in 3 months", "> 10% body weight"]'::jsonb, 'unintentional weight loss of {option}', false, 1),
('sq_wtloss_app', 'pc_weight_loss', 'Appetite Status', '["Normal appetite", "Poor / Loss of appetite", "Increased appetite"]'::jsonb, 'with {option}', false, 2),
('sq_edema_dist', 'pc_edema', 'Distribution', '["Bilateral ankle swelling", "Extending up to mid-calf", "Ascending up to knees", "Periorbital + leg edema"]'::jsonb, '{option}', false, 1),
('sq_edema_char', 'pc_edema', 'Pitting Character', '["Pitting edema", "Non-pitting", "Worse in evening after standing"]'::jsonb, 'characterized by {option}', false, 2),
('sq_throat_sev', 'pc_sore_throat', 'Severity / Onset', '["Mild scratchy throat", "Severe sharp pain", "Painful on swallowing (odynophagia)"]'::jsonb, '{option}', false, 1),
('sq_throat_assoc', 'pc_sore_throat', 'Associated Symptoms', '["Fever", "Difficulty swallowing", "Voice change / hoarseness", "Cervical lymphadenopathy"]'::jsonb, 'associated with {option}', true, 2),
('sq_ear_side', 'pc_ear_pain', 'Laterality', '["Right ear", "Left ear", "Bilateral ears"]'::jsonb, 'involving {option}', false, 1),
('sq_ear_type', 'pc_ear_pain', 'Character', '["Throbbing severe pain", "Dull fullness / ache", "Sharp lancinating with chewing"]'::jsonb, '{option}', false, 2),
('sq_eardis_char', 'pc_ear_discharge', 'Character', '["Serous / clear fluid", "Thick yellow mucopurulent", "Foul smelling", "Blood-tinged"]'::jsonb, '{option} discharge', false, 1),
('sq_eardis_rel', 'pc_ear_discharge', 'Relation to Bathing', '["After swimming / water entry", "Preceded by upper respiratory cold", "Persistent chronic discharge"]'::jsonb, 'triggered {option}', false, 2),
('sq_rhino_char', 'pc_nasal_discharge', 'Discharge Character', '["Watery clear rhinorrhea", "Thick yellowish / green", "Associated with frequent sneezing"]'::jsonb, '{option}', false, 1),
('sq_rhino_trig', 'pc_nasal_discharge', 'Triggers', '["Early morning / dust", "Cold exposure / AC", "Seasonal changes", "Pet dander / pollen"]'::jsonb, 'triggered by {option}', true, 2),
('sq_nasal_side', 'pc_nasal_congestion', 'Pattern', '["Bilateral blockage", "Alternating sides", "Predominantly Right side", "Predominantly Left side"]'::jsonb, '{option}', false, 1),
('sq_nasal_sleep', 'pc_nasal_congestion', 'Impact on Sleep', '["Mouth breathing at night", "Snoring / disturbed sleep", "Mild daytime blockage only"]'::jsonb, 'causing {option}', false, 2),
('sq_epist_sev', 'pc_epistaxis', 'Severity', '["Scanty trickling (self-limiting)", "Active profuse bleeding", "Recurrent minor crusting"]'::jsonb, '{option}', false, 1),
('sq_epist_side', 'pc_epistaxis', 'Side Involved', '["Right nostril", "Left nostril", "Bilateral"]'::jsonb, 'from {option}', false, 2),
('sq_hemop_quant', 'pc_hemoptysis', 'Quantity', '["Blood-streaked sputum", "Frank clots (< 50ml)", "Profuse fresh blood (> 100ml)"]'::jsonb, 'presenting with {option}', false, 1),
('sq_hemop_dur', 'pc_hemoptysis', 'Duration & Precedent', '["Single isolated episode", "Recurrent over past 3 days", "Associated with chronic cough / fever"]'::jsonb, '{option}', false, 2),
('sq_pnd_timing', 'pc_throat_clearing', 'Timing', '["Predominantly morning on waking", "Constant sensation of lump in throat (globus)", "Worse after lying down"]'::jsonb, '{option}', false, 1),
('sq_palp_onset', 'pc_palpitations', 'Onset & Nature', '["Sudden rapid racing beats", "Pounding slow beats", "Skipped beats / fluttering sensation"]'::jsonb, 'describing {option}', false, 1),
('sq_palp_assoc', 'pc_palpitations', 'Associated Symptoms', '["Chest discomfort", "Dizziness / presyncope", "Shortness of breath", "Sweating / tremor"]'::jsonb, 'accompanied by {option}', true, 2),
('sq_claud_dist', 'pc_claudication', 'Pain Distance', '["After walking > 500 meters", "After walking 100-200 meters", "Pain at rest"]'::jsonb, 'calf cramping {option}', false, 1),
('sq_claud_relief', 'pc_claudication', 'Relief Factor', '["Relieved by standing rest within 5 mins", "Relieved only by sitting down / forward flexion"]'::jsonb, '{option}', false, 2),
('sq_constip_freq', 'pc_constipation', 'Bowel Frequency', '["Once every 2-3 days", "Once every 4-5 days", "< 1 bowel movement/week"]'::jsonb, 'defecation {option}', false, 1),
('sq_constip_char', 'pc_constipation', 'Stool Consistency & Straining', '["Hard scybalous pellets", "Severe straining required", "Sensation of incomplete evacuation"]'::jsonb, 'with {option}', true, 2),
('sq_bloat_rel', 'pc_bloating', 'Relation to Food', '["Post-prandial distension", "Relieved after passing flatus / stool", "Constant fullness throughout day"]'::jsonb, 'noted as {option}', false, 1),
('sq_bpr_nature', 'pc_bleeding_pr', 'Bleeding Pattern', '["Fresh blood splashing in pan", "Streaks of blood on surface of hard stool", "Dark altered blood mixed with stool", "Dripping post-defecation"]'::jsonb, '{option}', false, 1),
('sq_bpr_pain', 'pc_bleeding_pr', 'Pain during Defecation', '["Painless bleeding", "Severe burning / cutting pain", "Dull perianal throbbing"]'::jsonb, 'with {option}', false, 2),
('sq_dysph_type', 'pc_dysphagia', 'Solids vs Liquids', '["Difficulty with solids only", "Difficulty with both solids and liquids", "Progressive worsening over months"]'::jsonb, '{option}', false, 1),
('sq_dysph_level', 'pc_dysphagia', 'Perceived Level of Sticking', '["High cervical / throat level", "Mid-retrosternal", "Lower retrosternal / epigastric"]'::jsonb, 'sticking at {option}', false, 2),
('sq_lbp_rad', 'pc_low_back_pain', 'Radiation / Sciatica', '["Localized to lumbar spine without radiation", "Radiating down Right leg past knee", "Radiating down Left leg past knee", "Bilateral buttock ache"]'::jsonb, '{option}', false, 1),
('sq_lbp_agg', 'pc_low_back_pain', 'Aggravating / Relieving Factors', '["Worse with bending forward / sitting", "Worse with walking / spinal extension", "Morning stiffness > 30 minutes", "Relieved by recumbent rest"]'::jsonb, '{option}', false, 2),
('sq_knee_side', 'pc_knee_pain', 'Laterality', '["Right knee", "Left knee", "Bilateral knees"]'::jsonb, 'involving {option}', false, 1),
('sq_knee_mech', 'pc_knee_pain', 'Mechanical Symptoms', '["Worse climbing stairs / squatting", "Joint crepitus / crunching", "Swelling / warmth noted", "True locking / giving way"]'::jsonb, 'with {option}', true, 2),
('sq_neck_rad', 'pc_neck_pain', 'Radiation to Arms', '["Localized neck stiffness", "Radiating to Right shoulder / arm", "Radiating to Left shoulder / arm", "Associated tingling in fingers"]'::jsonb, '{option}', false, 1),
('sq_neck_trig', 'pc_neck_pain', 'Posture Relation', '["Worse with prolonged screen / desk work", "Worse on waking up in morning", "Restricted rotational neck movement"]'::jsonb, '{option}', false, 2),
('sq_shoulder_side', 'pc_shoulder_pain', 'Side Involved', '["Right shoulder", "Left shoulder", "Bilateral"]'::jsonb, 'involving {option}', false, 1),
('sq_shoulder_range', 'pc_shoulder_pain', 'Range Restriction', '["Painful arc (60-120 deg abduction)", "Restricted overhead reach / combing hair", "Severe night pain on lying on affected side"]'::jsonb, '{option}', true, 2),
('sq_poly_dist', 'pc_polyarthralgia', 'Joint Distribution', '["Small joints of hands (MCP / PIP)", "Large weight-bearing joints (Knees / Ankles)", "Symmetrical distribution", "Asymmetrical oligoarthritis"]'::jsonb, 'affecting {option}', false, 1),
('sq_poly_morn', 'pc_polyarthralgia', 'Morning Stiffness', '["< 15 minutes", "30-60 minutes", "> 1 hour morning gel phenomenon"]'::jsonb, 'morning stiffness lasting {option}', false, 2),
('sq_rash_loc', 'pc_rash', 'Location & Spread', '["Flexural folds (neck, cubital, popliteal)", "Trunk and back", "Extensor surfaces (elbows, knees)", "Groin / intertriginous areas", "Generalized"]'::jsonb, 'distributed over {option}', false, 1),
('sq_rash_itch', 'pc_rash', 'Pruritus / Itch Intensity', '["Severe nocturnal itching", "Moderate itch aggravated by sweating", "Mild non-itchy rash"]'::jsonb, 'characterized by {option}', false, 2),
('sq_urtic_dur', 'pc_urticaria', 'Lesion Longevity', '["Transient wheals fading within 24h", "Individual lesions persist > 24 hours", "Triggered by pressure / dermographism"]'::jsonb, '{option}', false, 1),
('sq_urtic_angio', 'pc_urticaria', 'Angioedema / Warning Signs', '["No facial swelling", "Lip / eyelid swelling present", "Throat tightness / breathing difficulty"]'::jsonb, 'with {option}', false, 2),
('sq_boil_loc', 'pc_boil', 'Site', '["Axilla", "Buttock / perianal", "Groin / thigh", "Facial / neck region"]'::jsonb, 'located in {option}', false, 1),
('sq_boil_disch', 'pc_boil', 'Discharge Status', '["Tender indurated nodule (unopened)", "Pointing with central pustule", "Spontaneously discharging purulent material"]'::jsonb, '{option}', false, 2),
('sq_redeye_lat', 'pc_red_eye', 'Laterality & Pain', '["Unilateral painless redness", "Bilateral gritty discomfort", "Severe deep throbbing pain / photophobia", "Blurring of vision"]'::jsonb, 'presenting with {option}', false, 1),
('sq_eyedis_char', 'pc_eye_discharge', 'Discharge Character', '["Watery discharge with itch", "Thick yellow crusting in morning", "Stringy mucoid discharge"]'::jsonb, '{option}', false, 1),
('sq_dizzy_type', 'pc_dizziness', 'Character of Dizziness', '["True rotatory vertigo (room spinning)", "Lightheadedness on standing (presyncope)", "Unsteadiness / disequilibrium on walking"]'::jsonb, 'describing {option}', false, 1),
('sq_dizzy_trig', 'pc_dizziness', 'Positional Triggers', '["Triggered by turning head in bed", "Triggered by rapidly standing up", "Continuous non-positional constant vertigo"]'::jsonb, '{option}', false, 2),
('sq_insom_type', 'pc_insomnia', 'Sleep Disturbance Pattern', '["Initial insomnia (difficulty falling asleep > 1h)", "Middle insomnia (frequent nocturnal awakenings)", "Terminal insomnia (early morning waking at 3-4 AM)"]'::jsonb, 'noted with {option}', false, 1),
('sq_anx_somatic', 'pc_anxiety', 'Somatic Symptoms', '["Tremors / restlessness / tension", "Chest tightness / hyperventilation", "Epigastric butterflies / loose stools", "Persistent catastrophic worry"]'::jsonb, 'associated with {option}', true, 1)
ON CONFLICT (id) DO UPDATE SET
complaint_id = EXCLUDED.complaint_id,
question_label = EXCLUDED.question_label,
options_json = EXCLUDED.options_json,
sentence_template = EXCLUDED.sentence_template,
is_multi_select = EXCLUDED.is_multi_select,
sequence_order = EXCLUDED.sequence_order,
updated_at = now();

-- 4. Insert & Enrich Examination Systems
INSERT INTO nexus.examination_systems (id, system_name, default_normal_text, abnormal_findings_json) VALUES
('sys_ent', 'ENT Examination',
'Bilateral tympanic membranes intact, pearl grey; nasal mucosa pink, no polyps; posterior pharyngeal wall clear, tonsils not enlarged, no stridor',
'["Congested posterior pharyngeal wall", "Bilateral tonsillar hypertrophy with follicular exudates", "Hyperemic bulging tympanic membrane Right", "Hyperemic bulging tympanic membrane Left", "Nasal mucosal congestion & clear rhinorrhea", "Deviated Nasal Septum (DNS) to Right", "Deviated Nasal Septum (DNS) to Left", "Impacted cerumen / wax in ear canal", "Post-nasal purulent drip visible"]'::jsonb),
('sys_eye', 'Eye / Ophthalmology',
'Bilateral pupils equal, round & reactive to light (PEERL); conjunctiva clear, no pallor or icterus; extraocular movements full & painless, visual acuity gross intact',
'["Conjunctival injection / congestion", "Mucopurulent discharge with matting of lashes", "Marked pallor in lower palpebral conjunctiva", "Icteric sclera", "Subconjunctival hemorrhage", "Periorbital edema", "Ciliary flush / photophobia"]'::jsonb),
('sys_msk', 'Musculoskeletal & Spine',
'Normal spinal curvature, full range of active/passive joint movements, no joint swelling, tenderness, warmth, crepitus, or deformities; gait normal',
'["Paravertebral lumbar muscle spasm & tenderness", "Straight Leg Raise (SLR) positive < 60 degrees", "Right knee joint effusion & medial joint line tenderness", "Left knee joint crepitus on active flexion", "Painful arc on shoulder abduction (60-120 deg)", "Restricted shoulder abduction & external rotation", "Cervical paraspinal tenderness & restricted rotation", "Point tenderness over medial calcaneal tuberosity", "Bilateral MCP / PIP joint swelling & warmth", "Antalgic gait"]'::jsonb),
('sys_skin', 'Skin & Integumentary',
'Skin texture and turgor normal, no active rashes, petechiae, purpura, ulcers, boils, or subcutaneous nodules; hair and nails healthy',
'["Erythematous pruritic maculopapular rash", "Raised erythematous wheals with central pallor (urticaria)", "Annular scaly plaque with central clearing & active erythematous margin", "Tender fluctuant erythematous furuncle / boil", "Dry excoriated eczematous lichenified plaque", "Petechiae / purpura over lower extremities", "Xerosis with superficial excoriations"]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
system_name = EXCLUDED.system_name,
default_normal_text = EXCLUDED.default_normal_text,
abnormal_findings_json = EXCLUDED.abnormal_findings_json,
updated_at = now();

UPDATE nexus.examination_systems
SET abnormal_findings_json = '["Tachycardia (> 100 bpm)", "Bradycardia (< 60 bpm)", "Systolic Murmur", "Diastolic Murmur", "Muffled heart sounds", "Irregularly irregular pulse rhythm", "Raised Jugular Venous Pressure (JVP)", "Bilateral pitting pedal edema"]'::jsonb,
    updated_at = now()
WHERE id = 'sys_cvs';

UPDATE nexus.examination_systems
SET abnormal_findings_json = '["Bilateral diffuse polyphonic wheeze", "Basal fine end-inspiratory crepitations", "Coarse crackles / rhonchi", "Decreased air entry Right", "Decreased air entry Left", "Prolonged expiratory phase", "Inspiratory stridor", "Dull percussion note at lung base"]'::jsonb,
    updated_at = now()
WHERE id = 'sys_rs';

UPDATE nexus.examination_systems
SET abnormal_findings_json = '["Mild epigastric tenderness", "Suprapubic tenderness", "Diffuse tenderness with hyperactive bowel sounds", "Guarding / rigidity present", "Right iliac fossa (McBurney point) tenderness", "Renal angle tenderness (Murphy punch positive)", "Hepatomegaly palpable 2cm below right costal margin", "Splenomegaly palpable", "Shifting dullness present (ascites)"]'::jsonb,
    updated_at = now()
WHERE id = 'sys_pa';

UPDATE nexus.examination_systems
SET abnormal_findings_json = '["Anxious / restless", "Lethargic / drowsy", "Neck stiffness / positive Kernig sign", "Disoriented to time, place or person", "Pronator drift present", "Asymmetrical facial grimace / smile", "Horizontal nystagmus on lateral gaze", "Positive Romberg sign / cerebellar ataxia"]'::jsonb,
    updated_at = now()
WHERE id = 'sys_cns';

-- 5. Insert 30 Additional Common Diagnoses
INSERT INTO nexus.diagnoses (id, name, icd10_code, linked_complaint_ids) VALUES
('diag_t2dm', 'Type 2 Diabetes Mellitus', 'E11.9', '["pc_fatigue", "pc_weight_loss"]'::jsonb),
('diag_essential_htn', 'Essential Primary Hypertension', 'I10', '["pc_headache", "pc_dizziness"]'::jsonb),
('diag_allergic_rhinitis', 'Allergic Rhinitis', 'J30.9', '["pc_nasal_discharge", "pc_nasal_congestion", "pc_cough"]'::jsonb),
('diag_acute_pharyngitis', 'Acute Pharyngitis / Tonsillitis', 'J02.9', '["pc_sore_throat", "pc_fever", "pc_cough"]'::jsonb),
('diag_acute_bronchitis', 'Acute Bronchitis', 'J20.9', '["pc_cough", "pc_fever", "pc_sob"]'::jsonb),
('diag_acute_otitis_media', 'Acute Otitis Media', 'H66.90', '["pc_ear_pain", "pc_ear_discharge", "pc_fever"]'::jsonb),
('diag_acute_sinusitis', 'Acute Maxillary / Frontal Rhinosinusitis', 'J01.90', '["pc_nasal_congestion", "pc_headache", "pc_fever"]'::jsonb),
('diag_migraine', 'Migraine Headache without Aura', 'G43.009', '["pc_headache", "pc_vomiting", "pc_dizziness"]'::jsonb),
('diag_tension_headache', 'Tension-Type Headache', 'G44.209', '["pc_headache", "pc_neck_pain"]'::jsonb),
('diag_bppv', 'Benign Paroxysmal Positional Vertigo (BPPV)', 'H81.10', '["pc_dizziness", "pc_vomiting"]'::jsonb),
('diag_gerd', 'Gastroesophageal Reflux Disease (GERD)', 'K21.0', '["pc_heartburn", "pc_abd_pain", "pc_throat_clearing"]'::jsonb),
('diag_ibs', 'Irritable Bowel Syndrome (IBS)', 'K58.9', '["pc_abd_pain", "pc_bloating", "pc_loose_stools", "pc_constipation"]'::jsonb),
('diag_chronic_constipation', 'Functional Constipation', 'K59.00', '["pc_constipation", "pc_bloating", "pc_abd_pain"]'::jsonb),
('diag_hemorrhoids', 'Internal / External Hemorrhoids (Piles)', 'K64.9', '["pc_bleeding_pr", "pc_constipation"]'::jsonb),
('diag_fatty_liver', 'Non-Alcoholic Fatty Liver Disease (NAFLD Grade 1-2)', 'K76.0', '["pc_fatigue", "pc_abd_pain"]'::jsonb),
('diag_mechanical_lbp', 'Acute Mechanical Lumbago / Back Strain', 'M54.50', '["pc_low_back_pain"]'::jsonb),
('diag_cervical_spondylosis', 'Cervical Spondylosis with Radiculopathy', 'M47.812', '["pc_neck_pain", "pc_headache"]'::jsonb),
('diag_osteoarthritis_knee', 'Primary Osteoarthritis of Knee (Bilateral/Unilateral)', 'M17.9', '["pc_knee_pain"]'::jsonb),
('diag_frozen_shoulder', 'Adhesive Capsulitis (Frozen Shoulder / Periarthritis)', 'M75.00', '["pc_shoulder_pain"]'::jsonb),
('diag_plantar_fasciitis', 'Plantar Fasciitis / Calcaneal Spur', 'M72.2', '["pc_claudication"]'::jsonb),
('diag_hyperuricemia_gout', 'Acute Gouty Arthritis', 'M10.00', '["pc_knee_pain", "pc_polyarthralgia"]'::jsonb),
('diag_acute_urticaria', 'Acute Allergic Urticaria', 'L50.0', '["pc_urticaria", "pc_rash"]'::jsonb),
('diag_tinea_infection', 'Tinea Corporis / Tinea Cruris (Fungal Dermatitis)', 'B35.9', '["pc_rash"]'::jsonb),
('diag_contact_dermatitis', 'Allergic Contact Dermatitis / Eczema', 'L23.9', '["pc_rash", "pc_urticaria"]'::jsonb),
('diag_bacterial_furuncle', 'Cutaneous Furunculosis / Follicular Abscess', 'L02.92', '["pc_boil", "pc_fever"]'::jsonb),
('diag_acute_conjunctivitis', 'Acute Catarrhal / Allergic Conjunctivitis', 'H10.9', '["pc_red_eye", "pc_eye_discharge"]'::jsonb),
('diag_iron_def_anemia', 'Microcytic Iron Deficiency Anemia', 'D50.9', '["pc_fatigue", "pc_dizziness", "pc_palpitations"]'::jsonb),
('diag_vit_d_deficiency', 'Vitamin D Deficiency & Chronic Myalgia', 'E55.9', '["pc_fatigue", "pc_polyarthralgia", "pc_low_back_pain"]'::jsonb),
('diag_insomnia_disorder', 'Primary Sleep Initiation & Maintenance Insomnia', 'G47.00', '["pc_insomnia", "pc_fatigue", "pc_headache"]'::jsonb),
('diag_generalized_anxiety', 'Generalized Anxiety & Somatization Disorder', 'F41.1', '["pc_anxiety", "pc_palpitations", "pc_insomnia", "pc_dizziness"]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
icd10_code = EXCLUDED.icd10_code,
linked_complaint_ids = EXCLUDED.linked_complaint_ids,
updated_at = now();

-- 6. Insert Matching Clinical Protocols
INSERT INTO nexus.prescription_protocols (id, diagnosis_id, protocol_items_json, general_advice) VALUES
('proto_allergic_rhinitis', 'diag_allergic_rhinitis',
'[{"drugId": "drug_levocet_mont", "doseOverride": "1 tab OD HS", "instructionsOverride": "Take at night"}, {"drugId": "drug_vit_c_zinc"}]'::jsonb,
'Avoid known allergens, dust, smoke, incense, and pet dander. Use daily saline nasal sprays/douches. Use AC filters and wash bedsheets weekly in warm water.'),
('proto_pharyngitis', 'diag_acute_pharyngitis',
'[{"drugId": "drug_pcm_650", "doseOverride": "650 mg TID SOS", "instructionsOverride": "For throat pain and fever > 100°F"}]'::jsonb,
'Warm saline gargles 4 times daily. Drink plenty of warm water or ginger-honey tea. Avoid cold beverages and ice creams. Rest voice.'),
('proto_acute_bronchitis', 'diag_acute_bronchitis',
'[{"drugId": "drug_cough_syp", "doseOverride": "10 ml TID", "instructionsOverride": "After food"}, {"drugId": "drug_pcm_650", "doseOverride": "650 mg SOS"}]'::jsonb,
'Steam inhalation twice daily. Adequate oral hydration to thin mucus secretions. Avoid exposure to cold air and environmental irritants. Avoid cigarette smoke.'),
('proto_migraine', 'diag_migraine',
'[{"drugId": "drug_pcm_650", "doseOverride": "650 mg Stat SOS"}, {"drugId": "drug_ondansetron", "doseOverride": "4 mg Stat SOS", "instructionsOverride": "Take 30 mins before analgesic"}]'::jsonb,
'Rest in a quiet, dark, and cool room during an acute attack. Maintain regular sleep-wake schedules. Avoid common triggers (skipping meals, caffeine withdrawal, excessive screen time, aged cheese, chocolate).'),
('proto_mechanical_lbp', 'diag_mechanical_lbp',
'[{"drugId": "drug_pcm_650", "doseOverride": "650 mg TID SOS", "instructionsOverride": "After meals"}]'::jsonb,
'Strict bed rest NOT recommended beyond 24-48 hours; maintain light walking. Apply warm fomentation to lower back for 15 minutes twice daily. Avoid forward bending and lifting heavy weights. Use firm mattress for sleeping.'),
('proto_urticaria', 'diag_acute_urticaria',
'[{"drugId": "drug_levocet_mont", "doseOverride": "1 tab BD / OD HS"}]'::jsonb,
'Avoid hot showers and tight clothing. Avoid suspected trigger foods (shellfish, nuts, artificial colors) and non-prescribed NSAIDs. Apply calamine lotion for soothing relief.'),
('proto_conjunctivitis', 'diag_acute_conjunctivitis',
'[]'::jsonb,
'Wash hands frequently with soap and water; do not touch or rub eyes. Use separate towels, pillows, and personal handkerchiefs. Clean crusts with sterile saline soaked cotton. Avoid contact lenses until complete resolution.'),
('proto_t2dm', 'diag_t2dm',
'[]'::jsonb,
'Diabetic diet: Avoid refined sugars, sweets, fruit juices, and white rice. Include high-fiber foods, oats, whole grains, and leafy vegetables. 30-45 minutes brisk walking daily. Regular self-monitoring of blood glucose (FBS & PPBS). Regular foot examination for any cuts/blisters.'),
('proto_htn', 'diag_essential_htn',
'[]'::jsonb,
'DASH Diet: Strictly restrict dietary salt (< 5g / 1 teaspoon daily). Avoid pickles, papads, canned foods, chips, and processed meats. Daily aerobic exercise 30 minutes. Chart blood pressure weekly in a diary. Avoid over-the-counter nasal decongestants and NSAIDs.'),
('proto_oa_knee', 'diag_osteoarthritis_knee',
'[{"drugId": "drug_pcm_650", "doseOverride": "650 mg BD SOS", "instructionsOverride": "After meals"}]'::jsonb,
'Avoid deep squatting, sitting cross-legged on floor, and using Indian-style toilets. Daily non-impact quadriceps-strengthening exercises (straight leg raises). Use knee cap during prolonged standing or walking. Maintain healthy body weight to reduce joint load.')
ON CONFLICT (id) DO UPDATE SET
diagnosis_id = EXCLUDED.diagnosis_id,
protocol_items_json = EXCLUDED.protocol_items_json,
general_advice = EXCLUDED.general_advice,
updated_at = now();

