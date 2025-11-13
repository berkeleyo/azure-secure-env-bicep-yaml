# ✅ Cutover Checklist

Use this checklist when bringing a **new secure environment** into service.

> Treat this as a **template** – copy into your change record and adapt as needed.

---

## 1. Governance & Approvals

- [ ] Change request raised and approved.
- [ ] Security review completed and signed off.
- [ ] Owners for the new environment clearly documented.

---

## 2. Technical Readiness

- [ ] Bicep validation completed (what-if / dry-run attached to change).
- [ ] Pre-production deployment completed and tested.
- [ ] Monitoring and alerting configured and validated.
- [ ] Access paths for admins tested (no direct exposure if not intended).

---

## 3. Communications

- [ ] Stakeholders informed of cutover date and impact.
- [ ] Support teams briefed and runbook shared.
- [ ] Rollback plan agreed and understood by all involved.

---

## 4. Cutover Execution

- [ ] Production deployment triggered via approved pipeline.
- [ ] All pipeline stages succeeded with no unexpected changes.
- [ ] Environment health checks passed (network, identity, logging).
- [ ] Application / workload checks completed (if applicable).

---

## 5. Post-Cutover

- [ ] Monitoring dashboards checked for the first N hours.
- [ ] Any temporary access or exemptions removed.
- [ ] Change record updated with result and evidence.
- [ ] Lessons learned captured (for future iterations).

If any critical step fails or behaviour is unexpected, follow **`docs/ROLLBACK.md`**.
