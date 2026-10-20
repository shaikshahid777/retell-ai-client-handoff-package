-- =====================================================================
-- Topic 14 handoff: production database schema (PostgreSQL)
-- Source: Topic 14 Implementation Docs, section 2.1 (DDL reproduced as supplied).
-- STATUS: DOCUMENTED. This DDL has NOT been executed against a PostgreSQL
-- instance in this project. The demonstrated implementation uses Google Sheets
-- tabs with the same column names (see database/README.md).
-- =====================================================================

CREATE TABLE IF NOT EXISTS campaign_leads (
  lead_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  phone_number VARCHAR(20) UNIQUE NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  timezone VARCHAR(50) NOT NULL,
  dnc_status BOOLEAN DEFAULT FALSE,
  last_call_attempt TIMESTAMP
);

CREATE TABLE IF NOT EXISTS campaign_call_logs (
  call_log_id SERIAL PRIMARY KEY,
  lead_id INT REFERENCES campaign_leads(lead_id),
  call_sid VARCHAR(100) UNIQUE NOT NULL,
  call_duration_seconds INT,
  outcome_label VARCHAR(30) NOT NULL,
  recording_url TEXT,
  call_summary TEXT,
  occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- PROPOSED HARDENING (NOT part of the supplied DDL, NOT tested).
-- Added in response to the confirmed {{user_number}} defect: a database
-- constraint would have rejected the literal placeholder text.
-- Uncomment only after review.
-- =====================================================================
-- ALTER TABLE campaign_leads
--   ADD CONSTRAINT chk_phone_e164 CHECK (phone_number ~ '^\+[1-9][0-9]{7,14}$');
--
-- ALTER TABLE campaign_call_logs
--   ADD CONSTRAINT chk_outcome_label
--   CHECK (outcome_label IN ('resolved','escalated','dnc_optout'));
