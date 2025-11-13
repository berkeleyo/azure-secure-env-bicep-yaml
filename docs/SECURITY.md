# 🔐 Security & Redaction

This document explains how this repository is kept **safe to share** and how to use it in a secure way.

---

## ✅ Redaction Principles

This repo is intentionally built as a **public/portfolio-safe** example:

- ✅ No real IP addresses
- ✅ No tenant IDs, subscription IDs, or object IDs
- ✅ No customer or organisation names
- ✅ No secrets, keys, passwords, or tokens
- ✅ No screenshots or exports from real systems

Any identifiers used are **generic placeholders** only (e.g. `dev-sec`, `prod-sec`, `uksouth`).

---

## 🔑 Handling Secrets

When you adapt this to a real project:

- Use **Key Vault** or your equivalent secret store.
- Integrate with pipelines using managed identities / OIDC where possible.
- Never commit:
  - Connection strings
  - Client secrets
  - Certificates or private keys
  - Real hostnames or IP addresses

Add any local or secret configuration files to `.gitignore` (e.g. `*.local.json`, `.env`).

---

## 🛡️ Hardening Notes

The templates and docs encourage, but do not enforce:

- Least privilege for access to the environment.
- Segmented networks and strong NSGs.
- Centralised logging and alerting.
- Clear separation between non-prod and prod.

Extend these patterns in your own implementation to match your organisational standards.

---

## 📌 Badge Meaning

The **Redaction** badge in `README.md` indicates that this repo has been reviewed to remove sensitive data.  
If you fork this repository and add real configuration, **you are responsible** for keeping your fork safe.

> When in doubt, assume something is sensitive and **do not commit it.**
