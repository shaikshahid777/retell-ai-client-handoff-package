# n8n workflows

Workflow JSON exports are **not included** (not fabricated). Export them manually (see below).

## Workflows observed in screenshots
| Workflow | Nodes | Behaviour (as observed) |
|---|---|---|
| Log Call Outcome | Webhook -> Append Call Log, Webhook -> Upsert Lead | Appends a row to `campaign_call_logs`; upserts the lead in `campaign_leads` matched on `phone_number` |
| DNC Opt-Out | Webhook -> Set DNC | Append-or-update in `campaign_leads` matched on `phone_number`, sets `dnc_status = TRUE` |

Webhook paths (from the supplied documentation and tool configuration): `post-call-outbound` and `dnc-optout`. Full production URLs are intentionally not published. Both webhooks respond immediately with `{"status":"ok"}`, which means a Sheets failure is **not** visible to the caller or agent; check n8n Executions.

## Export steps
1. Open each workflow -> menu `...` -> **Download**.
2. Save as `log-call-outcome.json` and `dnc-optout.json` in this folder.
3. Search the files for secrets and private URLs before committing. Credentials should appear only as names (e.g. "Google Sheets account"). Replace the spreadsheet URL/ID with a placeholder.

## Import steps (client)
1. n8n -> Import from file.
2. Re-select your own Google Sheets OAuth2 credential on each Sheets node.
3. Point the Document at a **native Google Sheet** (an uploaded `.xlsx` fails with "The document must not be an Office file"; this error occurred during the project).
4. Publish and note the production webhook URLs for the Retell tool settings.

Status: **PENDING (manual export)**. Proposed changes are in `docs/known-defects-and-fixes.md`.
