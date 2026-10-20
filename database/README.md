# Database

Two tables are specified by the Topic 14 implementation document. `schema.sql` reproduces the DDL; a commented, **untested** hardening section is kept separate from the supplied DDL.

| Evidence status | Detail |
|---|---|
| **DOCUMENTED** | PostgreSQL DDL in `schema.sql` (from the supplied implementation document) |
| **VERIFIED (screenshots)** | Google Sheet "Handoff Triage Demo_1" with tabs `campaign_leads` and `campaign_call_logs` and the same column names |
| **PENDING** | Running the DDL on a real PostgreSQL instance |

## `campaign_leads`
| Column | Type | Purpose |
|---|---|---|
| `lead_id` | SERIAL PK | Surrogate key; referenced by call logs |
| `first_name` | VARCHAR(50) NOT NULL | Caller/lead first name (agent collects it) |
| `phone_number` | VARCHAR(20) UNIQUE NOT NULL | Match key for upserts and DNC lookups (E.164 expected) |
| `product_name` | VARCHAR(100) NOT NULL | Campaign product |
| `timezone` | VARCHAR(50) NOT NULL | Used by the outbound timezone compliance check |
| `dnc_status` | BOOLEAN DEFAULT FALSE | `TRUE` = do not call |
| `last_call_attempt` | TIMESTAMP | Updated on every logged call |

## `campaign_call_logs`
| Column | Type | Purpose |
|---|---|---|
| `call_log_id` | SERIAL PK | Surrogate key |
| `lead_id` | INT FK -> `campaign_leads.lead_id` | Links a call to its lead (many calls per lead) |
| `call_sid` | VARCHAR(100) UNIQUE NOT NULL | Provider call ID; UNIQUE prevents duplicate rows for the same call |
| `call_duration_seconds` | INT | Call length |
| `outcome_label` | VARCHAR(30) NOT NULL | `resolved`, `escalated` or `dnc_optout` (the agent's labels) |
| `recording_url` | TEXT | Optional recording link |
| `call_summary` | TEXT | One-line summary written by the agent |
| `occurred_at` | TIMESTAMP DEFAULT now | Event time |

**Relationship:** one lead has many call logs (`campaign_call_logs.lead_id -> campaign_leads.lead_id`).

## Differences between the Google Sheets demo and PostgreSQL
| Topic | Google Sheets (demonstrated) | PostgreSQL (documented) |
|---|---|---|
| Keys / UNIQUE / FK | Not enforced | Enforced |
| `lead_id`, `call_log_id` | Blank in the demo (nothing generates them) | SERIAL auto-generated |
| Types | Text; timestamps stored as ISO text with `+05:30`; `dnc_status` stored as text `TRUE` | Typed columns |
| Phone numbers | A leading `+` can be dropped unless the column is formatted as plain text (observed: `919999900001`) | Constrained by type/length only unless the proposed CHECK is applied |
| Duplicate `call_sid` | Would create duplicate rows | Rejected by UNIQUE |

## Design observation (not tested)
`first_name`, `product_name` and `timezone` are `NOT NULL`. A DNC opt-out for a number that is not yet in `campaign_leads` cannot be inserted without those values, so a production DNC workflow should `UPDATE` existing leads or use a separate DNC registry table. The Sheets demo "append if missing" behaviour does not carry over directly.

## Apply the schema (production)
```bash
psql "$DATABASE_URL" -f database/schema.sql
```
Use your own connection string from a secret store; never commit it.
