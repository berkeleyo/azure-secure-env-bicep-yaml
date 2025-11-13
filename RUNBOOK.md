# 🧪 Secure Environment Deployment RUNBOOK

This runbook describes the **operational steps** for deploying and managing an Azure secure environment using the Bicep templates and YAML pipelines in this repository.

> This is intentionally generic: adapt resource group names, subscriptions, and approval flows to your organisation.
> All identifiers below are **placeholders** only.

---

## 0. Roles & Responsibilities

- **Environment Owner** – accountable for the environment, risk, and budget.
- **Platform Engineer** – runs deployments, maintains templates and pipelines.
- **Security Engineer** – validates controls, reviews NSGs, policies, and logs.
- **Change Manager** – tracks change records, approvals, and communications.

---

## 1. Pre-Deployment Checklist

Before running any deployment:

1. ✅ Confirm a **change request** (or ticket) is raised and approved.
2. ✅ Confirm target **subscription** and **resource group** exist.
3. ✅ Confirm necessary **RBAC roles** are granted to the deployment identity.
4. ✅ Validate the parameter file:
   - Environment name (e.g. `dev-sec`, `test-sec`, `prod-sec`)
   - Region (e.g. `uksouth`)
   - Tags (owner, cost centre, data classification)
5. ✅ Confirm that **Key Vault** / secret stores contain all required secrets (if any).

---

## 2. Validation (What-If)

1. Run the validation script:

   ```powershell
   ./scripts/validate-deployment.ps1 `
     -EnvironmentName "dev-sec" `
     -Location "uksouth" `
     -TemplateFile "./bicep/main.bicep" `
     -ParameterFile "./scripts/sample-parameters.json"
   ```

2. Review the output for:
   - New resources created
   - Changes to existing resources
   - Resources scheduled for deletion

3. If anything is unexpected, **stop** and adjust the parameters or templates.

4. Attach the validation output to your change/ticket where required.

---

## 3. Deployment (Non-Production)

1. Trigger deployment via script (non-prod):

   ```powershell
   ./scripts/deploy-environment.ps1 `
     -EnvironmentName "dev-sec" `
     -Location "uksouth" `
     -TemplateFile "./bicep/main.bicep" `
     -ParameterFile "./scripts/sample-parameters.json"
   ```

2. Monitor deployment:
   - Bicep/ARM outputs
   - Activity logs in the Azure portal
   - Pipeline logs (if using CI/CD)

3. Perform **post-deployment checks**:
   - All expected resource types present
   - NSG rules and policies match expectations
   - Diagnostic settings enabled and sending logs

4. Update the change/ticket with deployment results.

---

## 4. Deployment (Production)

Production deployments should only be run via **approved pipelines**:

1. Ensure pipeline variables and secrets are set (subscription, environment, credentials).
2. Create a **release window** and communicate to stakeholders.
3. From the pipeline UI:
   - Select the correct branch and environment.
   - Confirm approvals (e.g. Security, Platform, Change Manager).
   - Start the run and monitor until completion.

4. If any step fails:
   - Do **not** re-run blindly.
   - Consult the **ROLLBACK.md** guide.
   - Decide whether to fix-forward or roll back.

---

## 5. Cutover

Once the environment is successfully deployed:

1. Follow `docs/CUTOVER_CHECKLIST.md` line by line.
2. Validate:
   - Logging, monitoring, and alerts are working.
   - Connectivity paths are as expected.
   - Access control flows behave correctly (least privilege).
3. Update documentation and diagrams as necessary.
4. Officially **hand over** to the environment owner / operations team.

---

## 6. Day-2 Operations

Typical ongoing tasks:

- **Drift correction**
  - Re-run Bicep to re-apply desired state.
- **Policy alignment**
  - Ensure templates remain compliant with current policies.
- **Monitoring & Alerts**
  - Tune noise vs. actionable alerts.
- **Patching**
  - Ensure any compute resources follow patching policy.

Document all recurring tasks in your internal operations handbook if this repo is being used in a real organisation (keep those details out of this public/portfolio version).

---

## 7. Decommissioning

For short-lived security environments, decommissioning must be as deliberate as deployment:

1. Confirm with the **Environment Owner** that the environment can be removed.
2. Confirm required **log retention** and export any necessary evidence.
3. Execute:

   ```powershell
   ./scripts/remove-environment.ps1 `
     -EnvironmentName "dev-sec" `
     -Location "uksouth"
   ```

4. Verify that:
   - Critical logs are retained in central log stores.
   - No active users, sessions, or dependencies remain.
   - Billing is updated to reflect decommissioning.

5. Close associated changes/tickets with decommissioning evidence.

---

## 8. Incident Handling

If a security incident is suspected within this environment:

1. Freeze further changes (except emergency containment).
2. Enable additional logging if necessary (without tampering with evidence).
3. Escalate to your **security incident response** function.
4. Use this repo as **read-only reference**; do not store incident data here.
5. Update templates **after** lessons-learned, never during active investigation.
