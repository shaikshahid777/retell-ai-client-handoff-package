# User Stories, Risks and Dependencies

## User stories (from the supplied requirement document)
**US-001: Packaging the project handoff pack.** As a Client Operations Lead, I want a complete delivery package containing prompt version logs and integration maps so that my internal engineering team can manage maintenance.
- Given a Retell agent project is finalized, when the developer packages the handoff pack, then it includes the integration data-flow map, prompt change logs, maintenance SLAs and a launch checklist, and the client team reviews the files and completes deployment verification.
- Project status: package drafted; agent/workflow exports and client verification PENDING.

**US-002: Incident escalation setup.** As a Support Engineer, I want owners and SLA targets for call failures so that I can route tickets during outages.
- Given an outage on the Retell WebRTC server, when I open the escalation matrix, then I find the telephony provider contact and the 30-minute target, and raise the ticket to the first responder.
- Project status: matrix written; contacts TBD.

## Assumptions
| ID | Assumption | Status |
|---|---|---|
| ASM-001 | Client owns Retell, Twilio and database hosting subscriptions | Documented |
| ASM-002 | Operators know basic REST APIs and database queries | Documented |
| ASM-003 | Google Sheets stands in for PostgreSQL in the demo | Project-specific |
| ASM-004 | A web call stands in for telephony | Project-specific |

## Dependencies
| ID | Dependency | Status |
|---|---|---|
| DEP-001 | Retell project configuration matching version logs | Pending export and reconciliation |
| DEP-002 | Database migration configuration | DDL documented, not executed |
| DEP-003 | n8n workspace and Google Sheets OAuth credential | Present; trial status risk |

## Risks
| ID | Risk | Mitigation | Status |
|---|---|---|---|
| RSK-001 | Docs go stale if prompts change without log updates | Block production prompt changes unless the log/version registry is updated | Documented rule |
| RSK-002 | Placeholder phone number breaks DNC matching (DEF-001) | Guard in n8n, agent prompt, DB constraint | Confirmed defect, open |
| RSK-003 | Webhooks unauthenticated (RISK-B) | Verify `x-retell-signature` or a shared secret | Open |
| RSK-004 | Duplicate rows on retry (RISK-C) | Idempotency on `call_sid` | Open |
| RSK-005 | n8n trial lapse (RISK-D) | Export workflows; move to a paid/owned instance | Open |
| RSK-006 | Sheets does not enforce constraints | Use PostgreSQL in production | Documented |
| RSK-007 | NOT NULL columns block DNC inserts for unknown numbers | UPDATE-only or separate DNC table | Design observation |
