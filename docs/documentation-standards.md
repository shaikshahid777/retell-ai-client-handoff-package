# Documentation and Annotation Standards

## Diagram state colours (from the supplied implementation document)
| Colour | Meaning |
|---|---|
| Green | Inbound state (greeting configuration nodes) |
| Purple | Telephony tool call (action tool definitions) |
| Grey | Switch intent (dialog branching) |
| Red | Escalation SLA state (support escalation matrix) |
| Yellow | Launch gate (pre-launch checklist blocks) |

## Sticky-note annotations (from the same document)
| Annotation | Text | Placed |
|---|---|---|
| Handoff | "Delivery Package: Outlines system paths, schemas, and configurations to allow client engineering teams to maintain the agent." | Above the architecture section |
| Security | "API Credentials: API endpoints are defined without hardcoded secrets to preserve security best practices." | Above the environment-variables section |
| SLA target | "Support SLAs: Predefines incident owners and resolution targets to control support expectations." | Above the escalation matrix |

## Repository standards (this project)
1. **Evidence tags:** VERIFIED / DOCUMENTED / PENDING / DEFECT on every claim about the system.
2. **No secrets:** only placeholders; private webhook URLs, sheet IDs and screenshots with address bars are not committed.
3. **No invented artifacts:** unavailable exports are marked as missing.
4. **Versioning:** each prompt change gets a Retell version and a change-log row.
5. **Status honesty:** unexecuted tests are PENDING, never PASS.
