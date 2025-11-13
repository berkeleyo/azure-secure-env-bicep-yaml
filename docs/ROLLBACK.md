# ↩️ Rollback Guide

This document describes how to **safely back out** changes if a deployment or cutover fails.

> Always coordinate rollback with change management, security, and the environment owner.

---

## 1. Decide: Fix Forward vs Roll Back

Before triggering rollback, quickly assess:

- Is the failure **contained** and well-understood?
- Can it be **fixed forward** safely within the maintenance window?
- Does rollback introduce more risk than leaving the change in place?

If there is any doubt, favour a **controlled rollback**.

---

## 2. Rollback Options

### Option A – Template Reversion (Preferred)

1. Revert to the last known good version of the Bicep templates and parameters.
2. Re-run the deployment with that version.
3. Validate that the environment returns to its previous state.

### Option B – Environment Tear-Down (Non-Prod Only)

1. Decommission the environment using:

   ```powershell
   ./scripts/remove-environment.ps1 `
     -EnvironmentName "dev-sec" `
     -Location "uksouth"
   ```

2. Confirm that no required resources remain.
3. Recreate the environment from scratch with corrected templates.

### Option C – Manual Corrections (Last Resort)

1. Make targeted changes via the Azure portal / CLI.
2. Document every manual change in the change record.
3. Follow up with a **template update** so that IaC remains the source of truth.

---

## 3. Verification After Rollback

- [ ] Access control behaves as before the change.
- [ ] Network paths behave as before the change.
- [ ] Logging and monitoring are restored and functional.
- [ ] No unexpected resource deletions or downgrades occurred.

---

## 4. Lessons Learned

After rollback, conduct a brief review:

- What failed and why?
- Did the validation and testing stages miss anything?
- What can be improved in templates, parameters, or runbooks?

Update this documentation and the templates to reduce the chance of similar issues re-occurring.
