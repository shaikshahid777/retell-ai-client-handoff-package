# Maintenance Runbook

Status: written procedure; steps have not been exercised by a second operator.

## Daily / per-shift checks
1. n8n -> each workflow -> **Executions**: look for red executions.
2. Retell -> **Call History**: check for failed calls; spot-check transcripts and the tool-call lines.
3. Sheet / database: confirm new rows are arriving, `phone_number` values are real E.164 numbers, and `call_duration_seconds` is populated once DEF-003 is fixed.
4. Track key metrics from the supplied documents: first-token latency, call termination triggers, caller sentiment (SLA dashboard is **not implemented**).

## Troubleshooting guide
| Symptom | Likely cause | Action |
|---|---|---|
| n8n execution red, Sheets node error 400 "must not be an Office file" | Sheet is an uploaded .xlsx | Convert to Google Sheets; re-select the document in all Sheets nodes (observed Oct 19) |
| Retell shows tool response but no sheet row | Wrong sheet/tab in the node, or write error | Check the Execution; confirm Document and tab name |
| Phone number is `{{user_number}}` | Call has no caller number (web call) or variable unresolved | See DEF-001 |
| Phone number lost its `+` | Sheet column not plain text | Format column; see DEF-002 |
| Duplicate call rows | Retry or re-run | Remove duplicates; see RISK-C |
| Webhook returns 404 | Workflow unpublished or wrong URL | Publish the workflow; copy the production URL into the Retell tool |
| Agent answers wrongly | Prompt issue | Escalate per the matrix; fix, version, QA, log |
| Credential error | Expired Google OAuth | Reconnect the credential in n8n |

## Release procedure (prompt or tool changes)
1. Edit the draft in Retell.
2. Run the relevant QA scenarios (web call) and record call IDs.
3. Publish with a description (`vX.Y.Z summary`), keeping "auto-create new draft" on.
4. Add the entry to `docs/prompt-change-log.md` (date, author, change, QA status, Retell version number).
5. Update webhook URLs only in the Retell tool settings; republish n8n workflows if they changed.
6. Merge the doc change in Git. Block production changes if the log is not updated (RSK-001).

## Rollback considerations
- Retell: roll back by re-publishing / re-activating the previous version (check how versions are selected in your workspace and confirm the active version afterwards).
- n8n: keep exported workflow JSON in `n8n-workflows/` per release; re-import to restore.
- Data: rolling back a prompt does not undo rows already written; correct them manually and record the change.
- Always confirm which Retell version the next call ran on (call detail shows "Version").

## Pre-launch sign-off template
| Item | Result (PASS / FAIL / N/A) | Evidence (call ID / execution ID) | Initials / date |
|---|---|---|---|
| Webhooks on production URLs | | | |
| Prompt version = change log | | | |
| Opt-out stores a real E.164 number | | | |
| QA scenarios run (list) | | | |
| Credentials not in repo | | | |
| Escalation contacts filled | | | |
| Telephony number bound and tested | | | |
Approved by: ____________  Date: ________
