# Requirements Mapping

## Traceability matrix (from the supplied requirement document)
| Source | BRD | PRD | FR | User story | Test case |
|---|---|---|---|---|---|
| BRD-001 | BRD-001 | PRD-001 | FR-001, FR-004 | US-001 | TC-001 |
| BRD-002 | BRD-002 | PRD-003 | FR-003 | US-001 | TC-002 |
| BRD-003 | BRD-003 | PRD-002 | FR-005 | US-002 | TC-004 |
| BRD-004 | BRD-004 | PRD-004 | FR-002 | US-001 | TC-003, TC-005 |

## Requirement definitions and this project's status
| ID | Requirement (summary) | Status in this repository |
|---|---|---|
| BRD-001 | Map integration topology, call flows, DB connections | Written (`docs/integration-topology.md`); not validated against exports |
| BRD-002 | Change log tracking prompt versions | Written; release entries documentation-only |
| BRD-003 | Operational owners, SLAs, escalation paths | Written; contacts TBD |
| BRD-004 | Launch checklist verifying numbers and keys | Written; mostly PENDING |
| PRD-001 | Project exporter utility | Not implemented (manual export) |
| PRD-002 | SLA dashboard integration | Not implemented |
| PRD-003 | Change log registry | Markdown table |
| PRD-004 | Key management checklist | `config/.env.example` |
| FR-001 | DB schema document with lead-tracking DDL | `database/` |
| FR-002 | File mapping E.164 numbers and API keys | Placeholders in `.env.example` |
| FR-003 | Prompt configs matching release tags | Partially; exports missing |
| FR-004 | n8n sub-workflow paths for outbound timezone check | NOT covered (the demo has no outbound timezone workflow) |
| FR-005 | Results of the 15-scenario QA sheet | NOT available; scenarios not run |
| NFR-001 | New developer deploys in under 2 hours | NOT measured |
| NFR-002 | Diagrams omit private IPs and secret tokens | Followed in this repository |

## Source inconsistencies
- TC-001 links FR-001 in the requirement document and FR-001, FR-004 in the test-cases document.
- Change-log QA references `TC-013` / `TC-006` have no matching defined test case (see `docs/prompt-change-log.md`).
