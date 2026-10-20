# Known Defects, Impact, Proposed Fixes and Required Retests

All proposed fixes are **untested proposals**. Nothing here has been implemented or verified.

## DEF-001: Literal `{{user_number}}` stored as the phone number
| Item | Detail |
|---|---|
| Evidence (VERIFIED) | `campaign_leads` row 4: first_name `Arid`, phone_number `{{user_number}}`, dnc_status `TRUE`, last_call_attempt 2026-10-20 09:00. n8n executions #64 (DNC Opt-Out) and #65 (Log Call Outcome) show `phone_number = {{user_number}}` in the node output. The Retell call detail says "No phone number associated with this conversation." |
| Likely cause | The test was a **web call**, which has no caller phone number, so the dynamic variable was never resolved and the agent passed the placeholder text as the tool argument. |
| Impact | DNC matching is unreliable: the opt-out is stored against a fake key, so a later lookup of the caller's real number would **not** find `dnc_status = TRUE`. The upsert also created a lead that is not a real number. This is a compliance risk for do-not-call handling. |
| Whether it occurs on real phone calls | Unknown (NOT TESTED). With a bound phone number the variable may resolve, but this must be verified. |
| Proposed fix 1 (n8n guard) | Add an IF node right after the Webhook in both workflows. Valid when `{{ /^\+[1-9]\d{7,14}$/.test(($json.body.args?.phone_number ?? $json.body.phone_number ?? '').trim()) }}`. On the false branch, do not write to the leads sheet. Switch the webhook to "Respond to Webhook" and return `{"status":"needs_phone_number"}` so the agent can ask the caller for a number. |
| Proposed fix 2 (agent) | Tool parameter description / prompt: use the caller ID only if it is a real E.164 number; otherwise ask the caller to state their phone number and read it back before calling the tool. Never pass placeholder text. |
| Proposed fix 3 (storage) | Format `phone_number` as plain text in Sheets; in PostgreSQL apply the proposed `CHECK` constraint in `database/schema.sql`. |
| Existing row 4 | Do not delete silently. Either keep it and label it as test data in the evidence log, or remove it after recording the deletion in `assessment/evidence-and-limitations.md`. |
| Required retest | (a) POST `{"args":{"phone_number":"{{user_number}}"}}` to each webhook: expect rejection and no new sheet row. (b) Web call where the caller states a number: expect a real E.164 number stored. (c) Real phone call via a bound number (PENDING, needs telephony). |

## DEF-002: `+` dropped from phone numbers in Google Sheets
Evidence (VERIFIED, direct POST tests Oct 19): `+919999900001` appeared as `919999900001`. Impact: a later match on `+919999900001` may not find the row and could append a duplicate. Proposed fix: format the column as plain text before writing; retest with a `+` number.

## DEF-003: `call_duration_seconds` empty
Evidence (VERIFIED): the live call row has no duration; the Append node's expression output was empty. Likely cause (inference): `log_call_outcome` fires **during** the call, before the duration exists. Proposed fix: update the row after the call ends using Retell's call-ended webhook event, or compute duration later from the call record. Retest: row has a numeric duration after the call.

## DEF-004: Identifier columns blank in the Sheets demo
`lead_id` and `call_log_id` are empty because nothing generates them; the Sheets demo therefore does not show the lead-to-call relationship. In PostgreSQL these are SERIAL columns and `lead_id` must be resolved when inserting a call log.

## RISK-A: Webhooks reply before work is done
Both webhooks answer `{"status":"ok"}` immediately, so failures (such as the Oct 19 Office-file error) are only visible in n8n Executions. Proposed: monitor Executions and/or return a real status.

## RISK-B: No webhook authentication
Retell sends an `x-retell-signature` header (seen in the execution input), but the workflows do not verify it. Anyone with the URL could post data. Proposed: verify the signature per Retell's documentation or add a shared-secret header check. Treat the production URLs as secrets.

## RISK-C: Non-idempotent logging
Append Call Log would add a second row if Retell retried the same call. Proposed: look up `call_sid` first (Sheets) or rely on `UNIQUE` / `ON CONFLICT DO NOTHING` (PostgreSQL).

## RISK-D: n8n trial
n8n showed "6 days left" on Oct 20 2026. If the workspace lapses, the webhooks stop. Export workflows before then.
