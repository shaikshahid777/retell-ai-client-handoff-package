# Test Cases

Status values: **PASS**, **FAIL**, **PARTIAL**, **PENDING** (not executed). Nothing unexecuted is marked as passed.

## Project test matrix
| ID | Purpose | Steps | Expected result | Actual evidence | Status |
|---|---|---|---|---|---|
| T-01 | Successful opt-out handling by the agent | Web call; give a name; ask to stop calls | Agent calls `register_dnc_optout`, confirms, then calls `log_call_outcome` | Retell transcript (Oct 20 09:00): both tool calls and responses, agent confirmed the do-not-call addition; call marked Successful, 54 s | **PASS** (single call) |
| T-02 | DNC status persistence | After opt-out, check `campaign_leads` | Row for the caller's real number with `dnc_status = TRUE` | Direct POST test (Oct 19): row `919999900002`, TRUE. Live call (Oct 20): TRUE but stored against `{{user_number}}` | **PARTIAL** (persists, wrong key in the live path) |
| T-03 | Call outcome logging | After a call, check `campaign_call_logs` | Row with call_sid, outcome, summary, timestamp, duration | Row appended with `call_82eab608...`, `dnc_optout`, summary, timestamp; duration empty | **PARTIAL** (DEF-003) |
| T-04 | Correct phone-number matching | Opt out with a real number, then upsert/lookup the same number | One row per number, `+` preserved | Literal placeholder stored (DEF-001); `+` dropped in direct tests (DEF-002) | **FAIL** |
| T-05 | Webhook failure handling | Break the Sheets target; call the webhook | Failure visible; no silent data loss; alerting | Not run as a designed test. Incidental observation: the Oct 19 failure showed only in n8n Executions while the webhook still answered `ok` | **PENDING** |
| T-06 | Duplicate call handling | POST the same `call_id` twice | One log row | Not run. Design check: Append is not idempotent in Sheets | **PENDING** |
| T-07 | Missing fields | POST without `phone_number`, `outcome_label` or `call_id` | Request rejected or flagged; no garbage rows | Not run. Expressions default to empty strings, so rows could be written blank | **PENDING** |
| T-08 | Credential security | Scan the repository for keys, tokens, private URLs | None found | Pattern scan of the generated files found none (see `evidence-and-limitations.md`). Must be repeated after the Retell/n8n exports are added | **PASS** (generated files only) |
| T-09 | Pre-launch validation | Run `docs/launch-checklist.md` | All items PASS | Checklist drafted; items 4 and 8 FAIL, others PENDING | **PENDING** (not ready) |

## Source test cases (Topic 14 documents)
| ID | Name | Linked requirement | Project status |
|---|---|---|---|
| TC-001 | Integration Map Verification | FR-001 (and FR-004 in the test-cases document) | PENDING (diagram written; not compared against exports) |
| TC-002 | Change Log Audit | FR-003 | PENDING (needs the Retell version history) |
| TC-003 | Credentials Verification Walkthrough | FR-002 | PARTIAL (checklist uses placeholders; walk-through with real host config not done) |
| TC-004 | Launch Checklist Run | FR-004, FR-005 | PENDING |
| TC-005 | Handoff Deploy Time Check | NFR-001 | PENDING (not timed) |

## Retest required after fixes
T-02, T-03, T-04 and the launch-checklist items 4 and 8, as listed in `docs/known-defects-and-fixes.md`.
