# Evidence and Limitations

## Screenshot-verified evidence
| # | Source | What it shows |
|---|---|---|
| E-01 | Retell Call History / call detail | Agent "Handoff Triage Agent", **Version 2**, web call on 2026-10-20 09:00 (IST), duration 54 s (listed 0:55), cost $0.126, Call Successful = Successful, Call Status = Ended, User Sentiment = Negative, Disconnection = user_hangup. Summary: the caller asked to stop future calls; the agent added them to the do-not-call list and confirmed. Transcript includes `register_dnc_optout` (0:17-0:18) and `log_call_outcome` (0:19-0:20) calls and responses, then the agent's confirmation. "No phone number associated with this conversation." |
| E-02 | n8n "Log Call Outcome" execution #65, 2026-10-20 09:00:20 | Succeeded in 2.667 s; Webhook, Append Call Log and Upsert Lead all green. Payload: `call_type: web_call`, `agent_version: 2`, header `x-retell-signature` present. Append output: call_sid populated, `call_duration_seconds` empty, `outcome_label = dnc_optout`. Upsert output: first_name `Arid`, `phone_number = {{user_number}}` |
| E-03 | n8n "DNC Opt-Out" execution #64 | Set DNC output: `phone_number = {{user_number}}`, `dnc_status = TRUE` |
| E-04 | n8n executions #62 and #63 (2026-10-19) | Direct POST tests succeeded (Log Call Outcome and DNC Opt-Out); earlier failure at 18:05:39 (Office-file error) and a simulated run at 18:06:52 |
| E-05 | Google Sheet "Handoff Triage Demo_1", `campaign_leads` | Row 2: Test, `919999900001`, last_call_attempt 2026-10-19; row 3: `919999900002`, TRUE; row 4: Arid, `{{user_number}}`, TRUE, 2026-10-20 09:00 |
| E-06 | Same sheet, `campaign_call_logs` | Row 2: `test_call_001`, 45, `dnc_optout`, "Free test"; row 3: `call_82eab608...`, `dnc_optout`, "Arid requested to ...", 2026-10-20 09:00:21; `call_log_id`, `lead_id` and the live row's duration are blank |
| E-07 | n8n UI | "6 days left" and "27/1000 Executions" on Oct 20 (trial) |

The Loom recording (https://www.loom.com/share/336f6e1893c34d129c5b84d8d58b4e7d) was made by the author; the claims above rest on the screenshots listed, not on a review of the video.

## Test records
The sheets contain test data: `test_call_001` / `919999900001` and `919999900002` (direct POST tests of Oct 19) and the Arid / `{{user_number}}` rows (web call of Oct 20). None of it is production data and none has been deleted by the documentation process.

## Automated checks on this repository
- Secret-pattern scan of all generated files (2026-10-20): searched for API-key-like strings, bearer tokens, AWS-style keys, n8n and Google Sheets URLs, spreadsheet/workflow/agent identifiers and credentialed database URLs. The only match was the placeholder `postgresql://DB_USER:DB_PASSWORD@DB_HOST...` line in `config/.env.example` (not a real credential). Re-run this scan after adding the Retell/n8n exports.

## Remaining assessment gaps
1. Retell agent export JSON: not included (manual).
2. n8n workflow JSON exports: not included (manual).
3. DEF-001 (placeholder phone) not fixed or retested.
4. DEF-002, DEF-003 not fixed.
5. 15-scenario QA pack not run; v1.2.0 scope lock not verified.
6. Release-label to Retell-version mapping not confirmed (call ran on version 2).
7. No Twilio/SIP number; no real phone call.
8. PostgreSQL DDL not executed.
9. NFR-001 two-hour deploy test not performed.
10. Escalation contacts TBD; SLA compliance not measurable yet.
11. Webhook authentication, idempotency and the SLA dashboard not implemented.

## Honest summary
Verified: a web call triggered both tools, n8n executed successfully and wrote to Google Sheets, and the agent confirmed the opt-out. Not verified: correct phone-number capture, production telephony, QA coverage, release records.
