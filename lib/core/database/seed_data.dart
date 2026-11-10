import 'dart:convert';
import 'package:drift/drift.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedAll(AppDatabase db) async {
    await db.batch((batch) {
      // 1. Seed Comorbidities
      batch.insertAll(
        db.comorbiditiesTable,
        [
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_ckd',
            name: 'Chronic Kidney Disease (CKD)',
            contraindicatedDrugClasses: jsonEncode(['NSAID', 'Metformin']),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_dm',
            name: 'Type 2 Diabetes Mellitus',
            contraindicatedDrugClasses: jsonEncode(['Systemic Steroids', 'Corticosteroids']),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_htn',
            name: 'Hypertension',
            contraindicatedDrugClasses: jsonEncode(['Decongestants', 'NSAID']),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_asthma',
            name: 'Bronchial Asthma',
            contraindicatedDrugClasses: jsonEncode([
              'Non-selective Beta Blockers',
              'Aspirin',
              'NSAID',
            ]),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_pregnant',
            name: 'Pregnancy',
            contraindicatedDrugClasses: jsonEncode([
              'Fluoroquinolones',
              'Tetracyclines',
              'ACE Inhibitors',
              'NSAID',
            ]),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_pud',
            name: 'Peptic Ulcer Disease',
            contraindicatedDrugClasses: jsonEncode([
              'NSAID',
              'Aspirin',
              'Systemic Steroids',
              'Corticosteroids',
            ]),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_cad',
            name: 'Coronary Artery Disease (CAD)',
            contraindicatedDrugClasses: jsonEncode(['NSAID']),
          ),
          ComorbiditiesTableCompanion.insert(
            id: 'comorb_copd',
            name: 'COPD',
            contraindicatedDrugClasses: jsonEncode([
              'Non-selective Beta Blockers',
              'Sedatives',
            ]),
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );

      // 2. Seed Presenting Complaints
      batch.insertAll(
        db.presentingComplaintsTable,
        [
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_fever',
            name: 'Fever',
            category: 'General',
            displayOrder: const Value(1),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_cough',
            name: 'Cough',
            category: 'RS',
            displayOrder: const Value(2),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_sob',
            name: 'Shortness of Breath',
            category: 'RS',
            displayOrder: const Value(3),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_chest_pain',
            name: 'Chest Pain',
            category: 'CVS',
            displayOrder: const Value(4),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_abd_pain',
            name: 'Abdominal Pain',
            category: 'GI',
            displayOrder: const Value(5),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_vomiting',
            name: 'Vomiting',
            category: 'GI',
            displayOrder: const Value(6),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_loose_stools',
            name: 'Loose Stools / Diarrhea',
            category: 'GI',
            displayOrder: const Value(7),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_dysuria',
            name: 'Dysuria (Burning Urination)',
            category: 'Renal',
            displayOrder: const Value(8),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_heartburn',
            name: 'Heartburn / Acid Regurgitation',
            category: 'GI',
            displayOrder: const Value(9),
          ),
          PresentingComplaintsTableCompanion.insert(
            id: 'pc_headache',
            name: 'Headache',
            category: 'CNS',
            displayOrder: const Value(10),
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );

      // 3. Seed Complaint Sub-Questions
      batch.insertAll(
        db.complaintSubQuestionsTable,
        [
          // Fever
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_fever_dur',
            complaintId: 'pc_fever',
            questionLabel: 'Duration',
            optionsJson: jsonEncode(['Custom...']),
            sentenceTemplate: const Value('Duration: {option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_fever_grade',
            complaintId: 'pc_fever',
            questionLabel: 'Grade / Type',
            optionsJson: jsonEncode(['Low grade', 'High grade', 'Intermittent with chills']),
            sentenceTemplate: const Value('{option} fever'),
            sequenceOrder: const Value(2),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_fever_assoc',
            complaintId: 'pc_fever',
            questionLabel: 'Associated Symptoms',
            optionsJson: jsonEncode(['Body aches', 'Chills & rigors', 'Sweating', 'Headache']),
            sentenceTemplate: const Value('associated with {option}'),
            isMultiSelect: const Value(true),
            sequenceOrder: const Value(3),
          ),

          // Loose Stools
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_diarrhea_dur',
            complaintId: 'pc_loose_stools',
            questionLabel: 'Duration',
            optionsJson: jsonEncode(['Custom...']),
            sentenceTemplate: const Value('since {option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_diarrhea_freq',
            complaintId: 'pc_loose_stools',
            questionLabel: 'Frequency',
            optionsJson: jsonEncode(['2-3 episodes/day', '4-6 episodes/day', '>6 episodes/day']),
            sentenceTemplate: const Value('{option}'),
            sequenceOrder: const Value(2),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_diarrhea_char',
            complaintId: 'pc_loose_stools',
            questionLabel: 'Consistency',
            optionsJson: jsonEncode(['Watery', 'Semi-solid', 'Mucoid', 'Bloody']),
            sentenceTemplate: const Value('{option} consistency'),
            sequenceOrder: const Value(3),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_diarrhea_cramps',
            complaintId: 'pc_loose_stools',
            questionLabel: 'Cramping',
            optionsJson: jsonEncode(['Mild cramping', 'Severe colicky pain', 'No cramps']),
            sentenceTemplate: const Value('with {option}'),
            sequenceOrder: const Value(4),
          ),

          // Vomiting
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_vomiting_freq',
            complaintId: 'pc_vomiting',
            questionLabel: 'Duration',
            optionsJson: jsonEncode(['Custom...']),
            sentenceTemplate: const Value('for {option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_vomiting_nature',
            complaintId: 'pc_vomiting',
            questionLabel: 'Content',
            optionsJson: jsonEncode(['Food particles', 'Bilious/yellowish', 'Watery non-bilious']),
            sentenceTemplate: const Value('{option} vomitus'),
            sequenceOrder: const Value(2),
          ),

          // Dysuria
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_dysuria_dur',
            complaintId: 'pc_dysuria',
            questionLabel: 'Duration',
            optionsJson: jsonEncode(['Custom...']),
            sentenceTemplate: const Value('for {option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_dysuria_assoc',
            complaintId: 'pc_dysuria',
            questionLabel: 'Associated Urinary Symptoms',
            optionsJson: jsonEncode(['Increased frequency', 'Urgency', 'Hesitancy', 'Suprapubic pain']),
            sentenceTemplate: const Value('with {option}'),
            isMultiSelect: const Value(true),
            sequenceOrder: const Value(2),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_dysuria_hem',
            complaintId: 'pc_dysuria',
            questionLabel: 'Hematuria',
            optionsJson: jsonEncode(['No hematuria', 'Pinkish tinge', 'Frank blood']),
            sentenceTemplate: const Value('{option}'),
            sequenceOrder: const Value(3),
          ),

          // Heartburn / APD
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_heartburn_time',
            complaintId: 'pc_heartburn',
            questionLabel: 'Timing / Trigger',
            optionsJson: jsonEncode(['After spicy meals', 'Empty stomach (fasting)', 'Night / recumbent']),
            sentenceTemplate: const Value('worse {option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_heartburn_rad',
            complaintId: 'pc_heartburn',
            questionLabel: 'Radiation',
            optionsJson: jsonEncode(['Retrosternal burning', 'Throat irritation', 'Localized epigastric']),
            sentenceTemplate: const Value('{option}'),
            sequenceOrder: const Value(2),
          ),

          // Shortness of Breath (Asthma)
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_sob_onset',
            complaintId: 'pc_sob',
            questionLabel: 'Onset',
            optionsJson: jsonEncode(['Sudden onset', 'Gradual worsening over days']),
            sentenceTemplate: const Value('{option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_sob_triggers',
            complaintId: 'pc_sob',
            questionLabel: 'Trigger Exposure',
            optionsJson: jsonEncode(['Cold air', 'Dust / smoke', 'Physical exertion', 'Night exacerbation']),
            sentenceTemplate: const Value('triggered by {option}'),
            isMultiSelect: const Value(true),
            sequenceOrder: const Value(2),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_sob_wheeze',
            complaintId: 'pc_sob',
            questionLabel: 'Wheezing',
            optionsJson: jsonEncode(['Audible wheeze present', 'Chest tightness without wheeze']),
            sentenceTemplate: const Value('{option}'),
            sequenceOrder: const Value(3),
          ),

          // Cough
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_cough_type',
            complaintId: 'pc_cough',
            questionLabel: 'Cough Type',
            optionsJson: jsonEncode(['Dry irritating cough', 'Productive / mucoid', 'Yellowish sputum']),
            sentenceTemplate: const Value('{option}'),
            sequenceOrder: const Value(1),
          ),
          ComplaintSubQuestionsTableCompanion.insert(
            id: 'sq_cough_dur',
            complaintId: 'pc_cough',
            questionLabel: 'Duration',
            optionsJson: jsonEncode(['Custom...']),
            sentenceTemplate: const Value('for {option}'),
            sequenceOrder: const Value(2),
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );

      // 4. Seed Examination Systems
      batch.insertAll(
        db.examinationSystemsTable,
        [
          ExaminationSystemsTableCompanion.insert(
            id: 'sys_cvs',
            systemName: 'CVS',
            defaultNormalText: 'S1 S2 heard, regular rate & rhythm, no murmurs',
            abnormalFindingsJson: jsonEncode([
              'Tachycardia',
              'Bradycardia',
              'Systolic Murmur',
              'Muffled heart sounds',
            ]),
          ),
          ExaminationSystemsTableCompanion.insert(
            id: 'sys_rs',
            systemName: 'RS',
            defaultNormalText: 'Bilateral Normal Vesicular Breath Sounds (NVBS), no added sounds',
            abnormalFindingsJson: jsonEncode([
              'Bilateral diffuse polyphonic wheeze',
              'Basal fine crepitations',
              'Coarse crackles',
              'Decreased air entry Right',
              'Decreased air entry Left',
              'Prolonged expiratory phase',
            ]),
          ),
          ExaminationSystemsTableCompanion.insert(
            id: 'sys_pa',
            systemName: 'Per Abdomen',
            defaultNormalText: 'Soft, non-tender, normal bowel sounds, no organomegaly',
            abnormalFindingsJson: jsonEncode([
              'Mild epigastric tenderness',
              'Suprapubic tenderness',
              'Diffuse tenderness, hyperactive bowel sounds',
              'Guarding / rigidity present',
              'Right iliac fossa (McBurney) tenderness',
              'Renal angle tenderness',
            ]),
          ),
          ExaminationSystemsTableCompanion.insert(
            id: 'sys_cns',
            systemName: 'CNS',
            defaultNormalText: 'Conscious, oriented to time, place, and person, no focal deficits',
            abnormalFindingsJson: jsonEncode([
              'Anxious / restless',
              'Lethargic / drowsy',
              'Neck stiffness / meningeal signs present',
              'Disoriented',
            ]),
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );

      // 5. Seed Diagnoses (5 Master Protocols)
      batch.insertAll(
        db.diagnosesTable,
        [
          DiagnosesTableCompanion.insert(
            id: 'diag_age',
            name: 'Acute Gastroenteritis',
            icd10Code: const Value('A09'),
            linkedComplaintIds: jsonEncode([
              'pc_loose_stools',
              'pc_vomiting',
              'pc_abd_pain',
              'pc_fever',
            ]),
          ),
          DiagnosesTableCompanion.insert(
            id: 'diag_urti',
            name: 'Viral Upper Respiratory Tract Infection (URTI)',
            icd10Code: const Value('J06.9'),
            linkedComplaintIds: jsonEncode([
              'pc_fever',
              'pc_cough',
              'pc_headache',
            ]),
          ),
          DiagnosesTableCompanion.insert(
            id: 'diag_uti',
            name: 'Acute Uncomplicated Urinary Tract Infection (UTI)',
            icd10Code: const Value('N30.0'),
            linkedComplaintIds: jsonEncode([
              'pc_dysuria',
              'pc_abd_pain',
              'pc_fever',
            ]),
          ),
          DiagnosesTableCompanion.insert(
            id: 'diag_apd',
            name: 'Acid Peptic Disease / GERD',
            icd10Code: const Value('K21.9'),
            linkedComplaintIds: jsonEncode([
              'pc_heartburn',
              'pc_abd_pain',
              'pc_vomiting',
            ]),
          ),
          DiagnosesTableCompanion.insert(
            id: 'diag_asthma',
            name: 'Bronchial Asthma (Acute Exacerbation)',
            icd10Code: const Value('J45.901'),
            linkedComplaintIds: jsonEncode([
              'pc_sob',
              'pc_cough',
            ]),
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );

      // 6. Seed Drugs Master Formulary
      batch.insertAll(
        db.drugsTable,
        [
          // AGE Drugs
          DrugsTableCompanion.insert(
            id: 'drug_ors',
            genericName: 'Oral Rehydration Salts + Zinc',
            brandName: 'Electral Sachet',
            drugClass: 'Electrolyte',
            defaultDose: '1 sachet in 1L water',
            defaultRoute: 'PO',
            defaultFrequency: 'Sip throughout day',
            defaultDuration: '3 days',
            defaultInstructions: 'Dissolve in 1 liter clean water; sip regularly',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_ondansetron',
            genericName: 'Ondansetron',
            brandName: 'Tab. Emeset 4mg',
            drugClass: 'Antiemetic',
            defaultDose: '4 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'TID SOS',
            defaultDuration: '3 days',
            defaultInstructions: 'Take 30 mins before food or vomiting episode',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_oflox_oz',
            genericName: 'Ofloxacin + Ornidazole',
            brandName: 'Tab. Oflox-OZ',
            drugClass: 'Fluoroquinolones',
            defaultDose: '200/500 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'BD',
            defaultDuration: '5 days',
            defaultInstructions: 'Take after food with plenty of water',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_dicyclomine_pcm',
            genericName: 'Dicyclomine + Paracetamol',
            brandName: 'Tab. Meftal-Spas',
            drugClass: 'NSAID',
            defaultDose: '10/325 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'SOS (Max TID)',
            defaultDuration: '3 days',
            defaultInstructions: 'For severe abdominal spasms after meals only',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_probiotic',
            genericName: 'Lactic Acid Bacillus + Probiotics',
            brandName: 'Cap. Vizylac',
            drugClass: 'Probiotic',
            defaultDose: '1 capsule',
            defaultRoute: 'PO',
            defaultFrequency: 'BD',
            defaultDuration: '5 days',
            defaultInstructions: 'Take after food',
          ),

          // URTI Drugs
          DrugsTableCompanion.insert(
            id: 'drug_pcm_650',
            genericName: 'Paracetamol',
            brandName: 'Tab. Dolo 650',
            drugClass: 'Analgesic',
            defaultDose: '650 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'TID SOS',
            defaultDuration: '5 days',
            defaultInstructions: 'Take after food for fever > 100°F or body pain',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_levocet_mont',
            genericName: 'Levocetirizine + Montelukast',
            brandName: 'Tab. Monticope',
            drugClass: 'Antihistamine',
            defaultDose: '5/10 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'OD HS',
            defaultDuration: '5 days',
            defaultInstructions: 'Take at bedtime',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_cough_syp',
            genericName: 'Dextromethorphan + Chlorpheniramine',
            brandName: 'Syp. Ascoril-D',
            drugClass: 'Antitussive',
            defaultDose: '10 ml',
            defaultRoute: 'PO',
            defaultFrequency: 'TID',
            defaultDuration: '5 days',
            defaultInstructions: 'Take after food',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_vit_c_zinc',
            genericName: 'Vitamin C + Zinc Chewable',
            brandName: 'Tab. Limcee',
            drugClass: 'Supplement',
            defaultDose: '500 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'OD',
            defaultDuration: '7 days',
            defaultInstructions: 'Chew after breakfast',
          ),

          // UTI Drugs
          DrugsTableCompanion.insert(
            id: 'drug_nitrofurantoin',
            genericName: 'Nitrofurantoin SR',
            brandName: 'Tab. Martifur-MR',
            drugClass: 'Urinary Antibacterial',
            defaultDose: '100 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'BD',
            defaultDuration: '5 days',
            defaultInstructions: 'Take with food or a glass of milk',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_citrate_alkalizer',
            genericName: 'Disodium Hydrogen Citrate',
            brandName: 'Syp. Citralka',
            drugClass: 'Urinary Alkalinizer',
            defaultDose: '2 tsp (10ml) in 1 glass water',
            defaultRoute: 'PO',
            defaultFrequency: 'TID',
            defaultDuration: '5 days',
            defaultInstructions: 'Always dilute well in water after meals',
          ),

          // APD / GERD Drugs
          DrugsTableCompanion.insert(
            id: 'drug_pan_d',
            genericName: 'Pantoprazole + Domperidone',
            brandName: 'Cap. Pan-D',
            drugClass: 'PPI',
            defaultDose: '40/30 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'OD',
            defaultDuration: '14 days',
            defaultInstructions: 'Take 30 minutes before morning breakfast',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_antacid_gel',
            genericName: 'Magaldrate + Simethicone Gel',
            brandName: 'Syp. Digene Gel',
            drugClass: 'Antacid',
            defaultDose: '10 ml',
            defaultRoute: 'PO',
            defaultFrequency: 'TID / SOS',
            defaultDuration: '7 days',
            defaultInstructions: 'Take 1 hour after meals and at bedtime',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_sucralfate',
            genericName: 'Sucralfate Suspension',
            brandName: 'Syp. Sucrafil',
            drugClass: 'Mucosal Protectant',
            defaultDose: '10 ml',
            defaultRoute: 'PO',
            defaultFrequency: 'BD',
            defaultDuration: '10 days',
            defaultInstructions: 'Take on empty stomach 1 hour before food',
          ),

          // Asthma Drugs
          DrugsTableCompanion.insert(
            id: 'drug_duolin_resp',
            genericName: 'Levosalbutamol + Ipratropium',
            brandName: 'Duolin Respules',
            drugClass: 'Bronchodilator',
            defaultDose: '1 respule (2.5ml)',
            defaultRoute: 'Inhalation/Neb',
            defaultFrequency: 'Stat & SOS',
            defaultDuration: '3 days',
            defaultInstructions: 'Nebulize with 4L oxygen/air as needed',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_foracort_200',
            genericName: 'Budesonide + Formoterol Inhaler',
            brandName: 'Foracort 200 Inhaler',
            drugClass: 'Corticosteroid/LABA',
            defaultDose: '200/6 mcg (2 puffs)',
            defaultRoute: 'Inhalation',
            defaultFrequency: 'BD',
            defaultDuration: '14 days',
            defaultInstructions: 'Rinse mouth thoroughly with water after inhalation',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_prednisolone_20',
            genericName: 'Prednisolone',
            brandName: 'Tab. Omnacortil 20',
            drugClass: 'Systemic Steroids',
            defaultDose: '20 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'OD Morning',
            defaultDuration: '5 days',
            defaultInstructions: 'Take in the morning with a full meal',
          ),
          DrugsTableCompanion.insert(
            id: 'drug_deriphyllin',
            genericName: 'Acebrophylline',
            brandName: 'Cap. AB-Phylline 100',
            drugClass: 'Bronchodilator',
            defaultDose: '100 mg',
            defaultRoute: 'PO',
            defaultFrequency: 'BD',
            defaultDuration: '7 days',
            defaultInstructions: 'Take after meals',
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );

      // 7. Seed Prescription Protocols (5 Clinical Decision Protocols)
      batch.insertAll(
        db.prescriptionProtocolsTable,
        [
          // Protocol 1: Acute Gastroenteritis
          PrescriptionProtocolsTableCompanion.insert(
            id: 'proto_age',
            diagnosisId: 'diag_age',
            protocolItemsJson: jsonEncode([
              {'drugId': 'drug_ors'},
              {'drugId': 'drug_ondansetron'},
              {'drugId': 'drug_oflox_oz'},
              {
                'drugId': 'drug_dicyclomine_pcm',
                'doseOverride': '1 tab SOS',
                'instructionsOverride': 'Take only for severe cramping spasms after meals',
              },
              {'drugId': 'drug_probiotic'},
            ]),
            generalAdvice: const Value(
              'Hydrate well with ORS, coconut water, and rice kanji. Bland diet (curd rice, bananas, toast). Strictly avoid dairy milk, spicy, and outside food. Return immediately if inability to retain liquids, severe dehydration, or high fever.',
            ),
          ),

          // Protocol 2: Viral Fever / URTI
          PrescriptionProtocolsTableCompanion.insert(
            id: 'proto_urti',
            diagnosisId: 'diag_urti',
            protocolItemsJson: jsonEncode([
              {'drugId': 'drug_pcm_650'},
              {'drugId': 'drug_levocet_mont'},
              {'drugId': 'drug_cough_syp'},
              {'drugId': 'drug_vit_c_zinc'},
            ]),
            generalAdvice: const Value(
              'Warm saline gargles 3-4 times daily. Steam inhalation twice daily. Adequate bed rest and oral hydration. Monitor temperature every 6 hours.',
            ),
          ),

          // Protocol 3: Uncomplicated UTI
          PrescriptionProtocolsTableCompanion.insert(
            id: 'proto_uti',
            diagnosisId: 'diag_uti',
            protocolItemsJson: jsonEncode([
              {'drugId': 'drug_nitrofurantoin'},
              {'drugId': 'drug_citrate_alkalizer'},
              {
                'drugId': 'drug_pcm_650',
                'doseOverride': '650 mg SOS',
                'instructionsOverride': 'For fever or severe dysuria/pelvic pain',
              },
            ]),
            generalAdvice: const Value(
              'Drink minimum 3 to 4 liters of water daily. Do not suppress or delay urination. Urinate post-coitus. Complete full 5-day antibiotic course even if symptoms subside earlier.',
            ),
          ),

          // Protocol 4: Acid Peptic Disease / GERD
          PrescriptionProtocolsTableCompanion.insert(
            id: 'proto_apd',
            diagnosisId: 'diag_apd',
            protocolItemsJson: jsonEncode([
              {'drugId': 'drug_pan_d'},
              {'drugId': 'drug_antacid_gel'},
              {'drugId': 'drug_sucralfate'},
            ]),
            generalAdvice: const Value(
              'Small, frequent meals on fixed timings. Avoid spicy, citrus, coffee, tea, and deep-fried foods. Avoid lying down for 2 hours post meals. Elevate head end of bed by 6 inches.',
            ),
          ),

          // Protocol 5: Acute Exacerbation of Bronchial Asthma
          PrescriptionProtocolsTableCompanion.insert(
            id: 'proto_asthma',
            diagnosisId: 'diag_asthma',
            protocolItemsJson: jsonEncode([
              {'drugId': 'drug_duolin_resp'},
              {'drugId': 'drug_foracort_200'},
              {'drugId': 'drug_prednisolone_20'},
              {'drugId': 'drug_deriphyllin'},
            ]),
            generalAdvice: const Value(
              'Use inhaler strictly with a spacer. Always rinse mouth thoroughly after steroid inhaler to prevent candidiasis. Avoid known triggers (dust, smoke, cold air). Visit Emergency Room immediately if acute breathlessness worsens or chest tightness is severe.',
            ),
          ),
        ],
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}

