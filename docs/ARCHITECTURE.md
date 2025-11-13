# 🏗️ Architecture

This document describes the **logical** and **deployment** architecture of the secure environment templates.

> All names, ranges, and identifiers are **examples only**. Replace them with your own values in private forks.

---

## Logical Components

- **Hub / Security VNet (optional)** – central services and shared controls.
- **Secure Environment VNet** – the main network for the environment.
- **Subnets** (example):
  - `management` – jump hosts, management tools, bastion-type access.
  - `workload` – workloads / services hosted in the secure zone.
- **Network Security**:
  - NSGs on subnets / NICs.
  - Optional Azure Firewall / security appliances (not fully modelled here).
- **Monitoring & Logging**:
  - Log Analytics workspace.
  - Diagnostic settings on critical resources.

---

## Example Logical Diagram

```mermaid
flowchart TB
  A[Users / Admins] -->|Controlled Access| B[Secure Entry (e.g. VPN / Proxy)]
  B --> C[Management Subnet]
  B --> D[Workload Subnet]

  C --> E[Jump / Admin Tools]
  D --> F[Apps / Services]

  C --> G[Monitoring & Logs]
  D --> G

  G[Log Analytics / SIEM] --> H[Security Operations]
```

---

## Deployment Architecture

- **Bicep**:
  - `bicep/main.bicep` – orchestrates environment-wide deployment.
  - `bicep/modules/network.bicep` – networks and subnets.
  - `bicep/modules/security.bicep` – NSGs and guardrail structures.
  - `bicep/modules/monitoring.bicep` – logging and diagnostics.

- **Pipelines (YAML)**:
  - Validate (`what-if` or similar).
  - Deploy to non-prod.
  - Deploy to prod with approvals.

- **Scripts**:
  - Provide CLI shims for local engineers to mimic pipeline behaviour.

---

## Trust Boundaries

- The secure environment sits behind **network and identity controls**.
- Admin access should be strictly controlled (e.g. via bastion or jump hosts).
- Monitoring is **foundational**, not optional.

Specific solutions (bastion, firewall SKUs, SIEM brand) are intentionally left abstract so this repo can be used across different organisations.
