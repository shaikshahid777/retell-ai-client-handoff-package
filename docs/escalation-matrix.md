# Escalation Matrix and SLAs

Status: **DOCUMENTED** (from the supplied requirement document). No SLA compliance has been measured and no incident has been handled under this matrix.

| Incident | Impact | First responder | Escalation owner | Target SLA |
|---|---|---|---|---|
| WebRTC / telephony disconnects | High | Telephony Operations | Carrier support (Twilio / SIP) | 30 minutes |
| LLM hallucinations (wrong data) | Medium | Voice Dev QA Team | Lead Conversation Designer | 2 hours |
| CRM / database write failures | High | DB Administrator | DevOps on-call team | 1 hour |
| Outbound timezone check failures | High | Automation Analyst | Lead Systems Architect | 4 hours |

The implementation document gives a three-row variant (telephony disconnect: 30 min, prompt hallucinations: 2 h, webhook failure: 1 h) with slightly different role names (e.g. "Support Operations", "SIP Provider Support"). Both versions agree on the SLA values for the shared incident types.

## Action plans
| Incident | First actions |
|---|---|
| Telephony disconnect | Check carrier status; verify trunk registration; check the number binding in Retell |
| Hallucination | Capture the call ID and transcript; edit the prompt; run the QA scenarios; publish a new version; log it |
| Write failure | Open n8n Executions; read the failing node's error; check credential and sheet/DB access; re-run the failed execution |
| Timezone failure | Pause outbound dialing; inspect the timezone routing workflow |

## Contacts (client to complete)
| Role | Name | Phone / channel |
|---|---|---|
| Telephony Operations | TBD | TBD |
| Voice Dev QA | TBD | TBD |
| DB Administrator | TBD | TBD |
| DevOps on-call | TBD | TBD |
| Lead Conversation Designer | TBD | TBD |
| Lead Systems Architect | TBD | TBD |

## Observed incident (for illustration)
On Oct 19 2026 (18:05:39) the "Log Call Outcome" workflow failed in 798 ms with a Google Sheets 400 error ("The document must not be an Office file") because the sheet was an uploaded `.xlsx`. It was visible in n8n Executions only; the webhook itself still answered `ok`. Fix: convert to a native Google Sheet. This is not an SLA measurement.
