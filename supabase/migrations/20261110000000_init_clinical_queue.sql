-- ==============================================================================
-- JMC NEXUS: RAPID CLINICAL PRESCRIPTION & QUEUE SYSTEM
-- SUPABASE POSTGRESQL INITIAL MIGRATION SCHEMA (8 TABLES + REALTIME SYNC)
-- ==============================================================================

-- 1. Patient Queue (Real-Time Synchronized between Reception & Doctor Terminals)
CREATE TABLE IF NOT EXISTS public.patient_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_number INT NOT NULL,
    patient_name TEXT NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('M', 'F', 'O')),
    phone TEXT,
    vitals_json JSONB,
    initial_comorb_ids JSONB,
    status VARCHAR(30) NOT NULL DEFAULT 'WAITING' CHECK (status IN ('WAITING', 'IN_CONSULTATION', 'COMPLETED', 'CANCELLED')),
    entry_time TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    consultation_start_time TIMESTAMPTZ,
    completion_time TIMESTAMPTZ,
    compiled_prescription_json JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_patient_queue_status_entry ON public.patient_queue(status, entry_time);
CREATE INDEX IF NOT EXISTS idx_patient_queue_token ON public.patient_queue(token_number);

-- 2. Comorbidities Catalog
CREATE TABLE IF NOT EXISTS public.comorbidities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    contraindicated_drug_classes JSONB NOT NULL DEFAULT '[]'::jsonb
);

-- 3. Presenting Complaints
CREATE TABLE IF NOT EXISTS public.presenting_complaints (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    display_order INT NOT NULL DEFAULT 0
);

-- 4. Complaint Sub-Questions
CREATE TABLE IF NOT EXISTS public.complaint_sub_questions (
    id TEXT PRIMARY KEY,
    complaint_id TEXT NOT NULL REFERENCES public.presenting_complaints(id) ON DELETE CASCADE,
    question_label TEXT NOT NULL,
    options_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    sentence_template TEXT NOT NULL DEFAULT '',
    is_multi_select BOOLEAN NOT NULL DEFAULT false,
    sequence_order INT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_sub_questions_complaint ON public.complaint_sub_questions(complaint_id);

-- 5. Examination Systems (Default Normal Overrides)
CREATE TABLE IF NOT EXISTS public.examination_systems (
    id TEXT PRIMARY KEY,
    system_name TEXT NOT NULL,
    default_normal_text TEXT NOT NULL,
    abnormal_findings_json JSONB NOT NULL DEFAULT '[]'::jsonb
);

-- 6. Diagnoses
CREATE TABLE IF NOT EXISTS public.diagnoses (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    icd10_code TEXT,
    linked_complaint_ids JSONB NOT NULL DEFAULT '[]'::jsonb
);

-- 7. Drugs Master Formulary
CREATE TABLE IF NOT EXISTS public.drugs (
    id TEXT PRIMARY KEY,
    generic_name TEXT NOT NULL,
    brand_name TEXT NOT NULL,
    drug_class TEXT NOT NULL,
    default_dose TEXT NOT NULL,
    default_route TEXT NOT NULL,
    default_frequency TEXT NOT NULL,
    default_duration TEXT NOT NULL,
    default_instructions TEXT NOT NULL
);

-- 8. Prescription Protocols (Diagnosis -> Pre-set Drugs Mapping)
CREATE TABLE IF NOT EXISTS public.prescription_protocols (
    id TEXT PRIMARY KEY,
    diagnosis_id TEXT NOT NULL REFERENCES public.diagnoses(id) ON DELETE CASCADE,
    protocol_items_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    general_advice TEXT NOT NULL DEFAULT ''
);

-- ==============================================================================
-- ENABLE SUPABASE REALTIME ON PATIENT QUEUE FOR INSTANT MULTI-DEVICE REPLICATION
-- ==============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.patient_queue;

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================
ALTER TABLE public.patient_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comorbidities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.presenting_complaints ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.complaint_sub_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.examination_systems ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drugs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prescription_protocols ENABLE ROW LEVEL SECURITY;

-- Read policies for clinic staff
CREATE POLICY "Allow public read access to clinical catalog"
    ON public.comorbidities FOR SELECT USING (true);

CREATE POLICY "Allow public read access to complaints"
    ON public.presenting_complaints FOR SELECT USING (true);

CREATE POLICY "Allow public read access to subquestions"
    ON public.complaint_sub_questions FOR SELECT USING (true);

CREATE POLICY "Allow public read access to exam systems"
    ON public.examination_systems FOR SELECT USING (true);

CREATE POLICY "Allow public read access to diagnoses"
    ON public.diagnoses FOR SELECT USING (true);

CREATE POLICY "Allow public read access to drugs"
    ON public.drugs FOR SELECT USING (true);

CREATE POLICY "Allow public read access to protocols"
    ON public.prescription_protocols FOR SELECT USING (true);

-- Patient Queue read & write policies for OPD terminals
CREATE POLICY "Allow all OPD terminals to read patient queue"
    ON public.patient_queue FOR SELECT USING (true);

CREATE POLICY "Allow all OPD terminals to insert into patient queue"
    ON public.patient_queue FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow all OPD terminals to update patient queue"
    ON public.patient_queue FOR UPDATE USING (true);

