# Prompt Version Control and Change Log

## Rule
No change to the production prompt or tools is allowed unless it is (1) published as a new Retell version with a description, and (2) recorded here first. This mitigates RSK-001 (documentation going stale).

## Change log
The release entries come from the supplied Topic 14 implementation document. They are **reference entries, not independently verified live release records**.

| Release ID | Date (as supplied) | Prompt patch summary | QA reference (as supplied) | Evidence status |
|---|---|---|---|---|
| v1.0.0 | 2026-06-20 | Initial support agent configuration | SC-001 | DOCUMENTED. Not independently verified |
| v1.1.0 | 2026-06-25 | Integrated `register_dnc_optout` tool parameters | SC-013 | DOCUMENTED. The tool is **VERIFIED working** in the Oct 20 call, but the release record is not |
| v1.2.0 | 2026-06-27 | Locked Tech Support prompts to restrict scope | SC-006 | DOCUMENTED. **Not verified live; do not treat as deployed** |

## What was actually observed
| Observation | Source | Status |
|---|---|---|
| The Oct 20 2026 09:00 web call ran on **Retell agent version 2** | Retell call detail ("Version: 2") and n8n payload (`agent_version 2`) | VERIFIED |
| Mapping between release labels (v1.x.x) and Retell version numbers | Not shown in any screenshot | **PENDING**: confirm in the Retell version history |
| Tech-support scope lock (v1.2.0) active in the tested agent | Not tested; the call covered only the opt-out intent | **PENDING** |

## Source inconsistencies to be aware of
The requirement document's change log cites `TC-003, TC-013` for v1.1.0 and `TC-006, SC-006` for v1.2.0, while the implementation document cites `SC-013` and `SC-006`. Test cases `TC-006`/`TC-013` are not defined in the five Topic 14 test cases. The labels are kept as supplied; they should be reconciled before relying on them.

## Template for new entries
| Release ID | Retell version | Date | Author | Changes | QA retest | Evidence link |
|---|---|---|---|---|---|---|
| vX.Y.Z | N | YYYY-MM-DD | name | what changed and why | scenarios run + result | execution/call ID |
