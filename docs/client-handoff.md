# Client Handoff Guide

## What the client receives
Per the supplied documents, a handoff package contains: requirements, prompt system instructions, dynamic webhook settings, data-flow topology diagrams and testing validations.

| Deliverable | Location | Status |
|---|---|---|
| Architecture and topology | `docs/architecture.md`, `docs/integration-topology.md` | Written |
| Prompt change log | `docs/prompt-change-log.md` | Written (release entries are documentation-only) |
| Escalation matrix and SLAs | `docs/escalation-matrix.md` | Written (SLAs from supplied document) |
| Launch checklist | `docs/launch-checklist.md` | Written; items mostly not yet executed |
| Maintenance runbook | `docs/maintenance-runbook.md` | Written |
| Database schema | `database/schema.sql` | Documented; not executed on PostgreSQL |
| Credentials checklist (no secrets) | `config/.env.example` | Written |
| Retell agent export | `agent-export/` | **Missing: manual export required** |
| n8n workflow exports | `n8n-workflows/` | **Missing: manual export required** |

## Ownership after handoff
| Area | Client owner (role) | Notes |
|---|---|---|
| Retell workspace and billing | Voice agent developer | Client's own subscription (ASM-001) |
| n8n instance and credentials | Automation analyst | Re-create the Google Sheets / DB credentials |
| Database | DB administrator | Apply `schema.sql`, manage backups |
| Telephony | Telephony operations | Provide numbers / SIP trunk |
| Prompt changes | Conversation designer | Every change needs a new version and a change-log entry |

## Adoption steps (untested as a timed run)
1. Create or import the agent in Retell; check the tool URLs.
2. Import the two n8n workflows; connect the Google Sheets credential; point the nodes at a native Google Sheet.
3. Create the tabs/tables from `database/README.md`; format the phone column as plain text (Sheets).
4. Fill `.env` from `config/.env.example` in your secret store.
5. Run `docs/launch-checklist.md`; record results in the sign-off template in `docs/maintenance-runbook.md`.

The documented non-functional requirement NFR-001 (a new developer deploys in under 2 hours) has **not** been measured.

## Scope boundaries
- Included: the triage agent, two webhooks, two data tables, documentation.
- Not included: Twilio/SIP setup, outbound campaigns, SLA dashboard, webhook authentication, production PostgreSQL deployment.
- Change requests (new languages, tools) go to a backlog with a ticket, version bump and QA retest.
