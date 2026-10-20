# Integration Topology Mapping

## Documented production path (source docs)
```
[Inbound Caller] -> [Twilio/SIP trunk] -> [Retell telephony + LLM]
        -> (tool calls / session webhooks) -> [n8n orchestrator]
        -> (SQL writes) -> [PostgreSQL: CRM / leads]
```

## Demonstrated path (VERIFIED)
```
[Retell web call, Oct 20 2026 09:00] -> [Handoff Triage Agent]
   tool: register_dnc_optout -> n8n "DNC Opt-Out"      -> Sheet campaign_leads  (dnc_status = TRUE)
   tool: log_call_outcome    -> n8n "Log Call Outcome" -> Sheet campaign_call_logs (append)
                                                        -> Sheet campaign_leads  (upsert)
```

## Endpoint types to document in a handoff
| # | Endpoint type | Placeholder | Notes |
|---|---|---|---|
| 1 | Retell API base | `https://api.retellai.com` | From the supplied document |
| 2 | Post-call / logging webhook | `https://YOUR-N8N-HOST/webhook/post-call-outbound` | Private URL not published |
| 3 | DNC webhook | `https://YOUR-N8N-HOST/webhook/dnc-optout` | Private URL not published |
| 4 | Telephony | `sip:trunk.telephony-provider.com`, outbound E.164 number | Client-provided; not used in the demo |
| 5 | Database | `postgresql://.../campaign_analytics` | Placeholder only |

## Tool payload (observed in the n8n execution input)
n8n received the Retell function call as an HTTP POST with these relevant parts:
- `body.args.*` - tool arguments: `first_name`, `phone_number`, `outcome_label`, `call_summary`
- `body.call.call_id`, `body.call.call_type` (`web_call`), `body.call.agent_id`, `body.call.agent_version`
- Header `x-retell-signature` (present; signature verification is **not** implemented in the workflows)

The workflow expressions read `body.args.*` first and fall back to top-level `body.*`.

## Field mapping
| Source | Sheet / column | Observed |
|---|---|---|
| `body.call.call_id` | `campaign_call_logs.call_sid` | Populated (`call_82eab608...`) |
| `body.call.duration` / `duration_ms` | `call_duration_seconds` | **Empty** in the live call (DEFECT, see known defects) |
| `body.args.outcome_label` | `outcome_label` | `dnc_optout` |
| `body.args.call_summary` | `call_summary` | Populated |
| now | `occurred_at` | ISO timestamp, +05:30 |
| `body.args.phone_number` | `campaign_leads.phone_number` (match key) | **Literal `{{user_number}}`** (DEFECT) |
| `body.args.first_name` | `first_name` | `Arid` (test caller) |
| constant | `dnc_status` | `TRUE` |
