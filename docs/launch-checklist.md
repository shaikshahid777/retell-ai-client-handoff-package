# Pre-Launch Checklist

Items below are the checks from the supplied documents plus project-specific checks. Statuses reflect the evidence available. Nothing is pre-ticked unless verified.

| # | Check | Verification method | Status | Evidence |
|---|---|---|---|---|
| 1 | Telephony balance / E.164 number active | Provider billing page; Retell Phone Numbers | PENDING | No number is bound; web call used |
| 2 | Webhook URLs point to production | Test POST returns HTTP 200 | PARTIAL | Direct POSTs (Oct 19) and a live call (Oct 20) reached n8n and succeeded; the URLs are n8n production endpoints |
| 3 | Prompt version matches change log | Retell version history vs `prompt-change-log.md` | PENDING | Call ran on Retell version 2; mapping unconfirmed |
| 4 | DNC status sync | `dnc_status = TRUE` row for the caller's number | **FAIL (defect)** | Row written, but with the literal `{{user_number}}` instead of a phone number |
| 5 | 15-scenario QA pack (SC-001...SC-015) | Run each scenario, record PASS/FAIL | PENDING | Only one scenario (opt-out) exercised |
| 6 | Credentials not exposed in docs | Scan the repository for secrets | PASS (generated files) | Re-run after adding exports |
| 7 | Phone column format | Sheet column formatted as plain text; `+` preserved | PENDING | `+` was dropped in direct POST tests |
| 8 | Call duration logged | `call_duration_seconds` populated | **FAIL (defect)** | Empty in the live call row |
| 9 | Agent and workflow exports saved in the repo | Files present | PENDING | Manual export required |
| 10 | n8n plan active for the handoff period | Plan status | RISK | n8n showed "6 days left" (trial) on Oct 20 |

## Go / no-go
Not ready for production. Blocking items: 4, 5, 8 and the telephony items. See `docs/known-defects-and-fixes.md`.
