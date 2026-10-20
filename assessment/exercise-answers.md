# Exercise Answers (Exercises 1-12)

The exercise prompts were supplied as titles only. Answers use the supplied Topic 14 documents and this project's evidence (tags: VERIFIED / DOCUMENTED / PENDING / DEFECT).

## Exercise 1: Handoff Package Fundamentals
A handoff package bundles requirements, prompt instructions, webhook settings, topology diagrams and test evidence so a client can run the agent alone. See `docs/client-handoff.md`. It addresses lost API keys, unchecked hallucinations and system crashes after the builder leaves.

## Exercise 2: Integration Topology Mapping
Documented: caller -> Twilio/SIP -> Retell + LLM -> n8n -> PostgreSQL. Demonstrated (VERIFIED): web call -> Retell Handoff Triage Agent -> n8n webhooks -> Google Sheets. Mermaid diagram in `docs/architecture.md`; field mapping in `docs/integration-topology.md`.

## Exercise 3: Database Schema and DDL
Two tables, `campaign_leads` and `campaign_call_logs`, linked by `lead_id`. DDL in `database/schema.sql` (DOCUMENTED, not executed). Field-by-field explanation and Sheets-versus-PostgreSQL differences in `database/README.md`.

## Exercise 4: Prompt Version Control
Publish a new Retell version for every change, describe it, and log it. Change-log entries v1.0.0 / v1.1.0 / v1.2.0 are documentation-only; the tested call ran on Retell version 2 and the label mapping is unconfirmed (`docs/prompt-change-log.md`).

## Exercise 5: Handoff vs Prompt Documentation
Prompt documentation describes agent behaviour: instructions, tools, scope rules and their versions. Handoff documentation covers the whole system around it: topology, credentials list, schema, escalation, launch checklist, maintenance and change history. The prompt change log is one section of the handoff pack.

## Exercise 6: Escalation Matrix
Four incident types with owners and SLAs (30 min, 2 h, 1 h, 4 h). `docs/escalation-matrix.md`. DOCUMENTED; contacts TBD; no SLA measured.

## Exercise 7: Pre-Launch Checklist
`docs/launch-checklist.md`. Checks 2 (webhook reachability) partly verified; DNC sync check FAILS because of DEF-001; the QA pack, telephony and version checks are PENDING.

## Exercise 8: Handoff Pack Blueprint
SECT-001 Architecture Notes, SECT-002 Prompt Change Log, SECT-003 Escalation Matrix, SECT-004 Launch Checklist. All four exist as documents in `docs/`; verification criteria (match live configuration, match portal snapshots, active contacts, developer check) are PENDING because exports and contacts are missing.

## Exercise 9: Documentation and Annotation Standards
Colour conventions and sticky-note texts from the supplied document, plus repository evidence standards: `docs/documentation-standards.md`.

## Exercise 10: Requirements Mapping
Traceability matrix BRD -> PRD -> FR -> US -> TC with implementation status: `docs/requirements-mapping.md`. FR-004, FR-005 and NFR-001 are not satisfied by evidence.

## Exercise 11: User Stories, Risks and Dependencies
US-001, US-002, RSK-001 and the project-found risks (RSK-002...007), assumptions and dependencies: `docs/user-stories-risks-dependencies.md`.

## Exercise 12: End-to-End Handoff Verification
| Step | Result | Evidence status |
|---|---|---|
| Web call, caller asks to stop calls | Agent called `register_dnc_optout` then `log_call_outcome` and confirmed the opt-out; Retell marked the call Successful (54 s) | VERIFIED |
| n8n executions | "Log Call Outcome" Succeeded (Webhook, Append Call Log, Upsert Lead all green); "DNC Opt-Out" Set DNC returned `dnc_status = TRUE` | VERIFIED |
| Call log row | `outcome_label = dnc_optout`, summary and call_sid populated | VERIFIED |
| Duration | Empty | DEFECT (DEF-003) |
| Phone number stored | Literal `{{user_number}}` | DEFECT (DEF-001) |
| Real phone call / Twilio | Not done | PENDING |
| 15-scenario QA pack | Not run | PENDING |
| 2-hour deploy test | Not run | PENDING |

Conclusion: the call-to-database path works end to end for the opt-out scenario, but the end-to-end verification is **incomplete** until DEF-001 is fixed and retested.
