-- ==============================================================================
-- JMC NEXUS: PERSISTENT PATIENT IDENTIFIER (UHID / MRN)
-- Adds a stable patient identifier so returning patients can be looked up.
-- ==============================================================================

ALTER TABLE public.patient_queue
    ADD COLUMN IF NOT EXISTS patient_id TEXT;

CREATE INDEX IF NOT EXISTS idx_patient_queue_patient_id
    ON public.patient_queue(patient_id);

CREATE INDEX IF NOT EXISTS idx_patient_queue_phone
    ON public.patient_queue(phone);
