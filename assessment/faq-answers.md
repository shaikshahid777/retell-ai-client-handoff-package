# Topic 14 FAQ Answers

Answers are grounded in the supplied Topic 14 requirement, implementation, test-case and overview documents. Where the project's own evidence differs, it is stated.

## Section 1: Handoff package fundamentals
**Q1. What is a client handoff package in a Retell AI project, and why is it important?**
It is the compiled set of assets that lets a client or internal team adopt, operate and maintain the voice agent without continuous developer help: requirements, prompt system instructions, dynamic webhook settings, data-flow topology diagrams and testing validations. It prevents knowledge loss, controls client scope expectations, outlines deployment risks and gives other engineers a path to debug or extend the agent.

**Q2. What are the five core components of a professional delivery package?**
(1) Solution requirements, (2) prompt system instructions, (3) dynamic webhook settings, (4) data-flow topology diagrams, (5) testing validations.

**Q3. Why decouple integration mapping from credentials?**
The mapping can be shared and reviewed safely because it names endpoints and parameters without containing secrets. The credentials checklist lists the required API keys, SIP tokens and webhook endpoints, but the real values stay in a secret store, so nothing is hard-coded or leaked in documents.

**Q4. What does the handoff package protect against?**
System knowledge loss when the builder leaves, uncontrolled client scope expectations, undocumented deployment risks, and the inability of other engineers to debug or extend the agent.

## Section 2: Database schema and integration topology
**Q5. What are the two tables and what does each store?**
`campaign_leads` stores each lead (first name, unique phone number, product, timezone, `dnc_status`, last call attempt). `campaign_call_logs` stores each call (call_sid, duration, outcome label, recording URL, summary, timestamp) and references the lead through `lead_id`. See `database/README.md`.

**Q6. What is the full data flow from an inbound caller to the production database?**
Caller (mobile/PSTN) -> Twilio/SIP trunk -> Retell AI telephony server with the LLM -> n8n orchestrator/API gateway -> production PostgreSQL (CRM/leads). *In this project's demonstration:* web call -> Retell -> n8n -> Google Sheets.

**Q7. Which environment variables must be configured and why are raw secrets excluded?**
The supplied document lists `N8N_RETELL_API_KEY`, `SIP_TRUNK_GATEWAY` and `SYSTEM_OUTBOUND_NUMBER`. Raw secret values are excluded so the documentation can be shared without exposing credentials; `config/.env.example` carries placeholders only.

**Q8. What are the four endpoint types in the telephony and webhook topology block?**
Retell API base, post-call webhook (n8n), database integration write endpoint, and the telephony connection (SIP trunk gateway / outbound E.164 number). The supplied block lists the first three as endpoints and the SIP gateway and outbound number as environment variables; this repository groups them as four types.

## Section 3: Prompt version control and change logs
**Q9. What is a versioned prompt repository and what must each change-log entry contain?**
A store of exact copies of the system prompt at milestones (for example `v1.0.0_initial_launch`, `v1.1.0_optout_patch`). Each entry maps date, prompt version, changes made, testing status and author.

**Q10. What are the three prompt versions and what changed?**
v1.0.0: initial release of the support/triage agent. v1.1.0: added the `register_dnc_optout` tool and opt-out triggers. v1.2.0: locked Tech Support prompts with strict scope limits. These are the entries in the supplied documents; this project has not verified them as live releases (`docs/prompt-change-log.md`).

**Q11. What risk does RSK-001 identify and what mitigation prevents it?**
Outdated docs: if the agent prompt is changed in the portal without updating the change logs, the documentation becomes stale. Mitigation: a deployment rule that blocks prompt changes to the production agent unless the change log and version registry are updated.

## Section 4: Escalation matrix and launch checklist
**Q12. What are the four incident types and their SLAs?**
WebRTC telephony disconnects: 30 minutes. LLM hallucinations: 2 hours. CRM database write failures: 1 hour. Outbound timezone check failures: 4 hours.

**Q13. What are the five pre-launch checklist items and their verification methods?**
(1) Verify SIP trunk balance: query the provider billing page. (2) Check webhook URLs: place a test POST and confirm HTTP 200. (3) Verify LLM prompt versions: check the Retell release tag matches (v1.2.0 in the supplied document). (4) Confirm DNC status sync: query the database for `dnc_status = TRUE`. (5) Run the 15-scenario QA pack: confirm SC-001 to SC-015 return PASS. *This project has executed only parts of items 2 and 4; see `docs/launch-checklist.md`.*

**Q14. What are the four sections of the handoff pack blueprint?**
SECT-001 Architecture Notes (maps data flow between n8n, Retell and databases). SECT-002 Prompt Change Log (registers prompt iteration history). SECT-003 Escalation Matrix (SLA targets and incident owners). SECT-004 Launch Checklist (directs pre-deployment checks).

**Q15. What are the five Topic 14 test cases and what does each validate?**
TC-001 Integration Map Verification (FR-001; FR-001 and FR-004 in the test-cases document). TC-002 Change Log Audit (FR-003). TC-003 Credentials Verification Walkthrough (FR-002). TC-004 Launch Checklist Run (FR-004, FR-005). TC-005 Handoff Deploy Time Check (NFR-001, under 2 hours). Execution status for this project is in `assessment/test-cases.md`.
