# Security, operational limitations, and responsible publishing

This is a **lab project**, not a production identity automation platform. The three scripts in `scripts/` are copied from the user's successfully tested VM files; they have **not** been run again or retested against an AD environment as part of this GitHub packaging.

## Safeguards present in the submitted scripts

- Domain guard restricting script execution to `corp.tetsalab.test`.
- Human-readable **preview by default**, with `-Apply -WhatIf` simulation support.
- Fixed department-to-group/OU mapping and validation of target OUs and groups.
- Joiner input username validation, duplicate CSV checking and existing-account detection.
- Offboarding limited to employees within the designated lab Users OU hierarchy.

## Limitations and recommendations

- **No transaction / rollback:** Multiple directory changes can partially succeed before a later error. Inspect state before retrying.
- **No comprehensive entitlement review:** Leaver removes only the defined four departmental groups, not all nested, application, SaaS, file-share, conditional, or historical access. Offboarding does not force expiration of existing sessions or tokens.
- **Lab password process:** The onboarding script prompts for a temporary SecureString shared by the eight fictional test accounts. This is a convenience for an isolated demonstration, **not acceptable production credential provisioning**.
- **No formal approvals or centralized logs:** Change authorization, approval, audit trail, exception handling, owner review, service desk records and retention schedules are not implemented.
- **Self-contained lab topology:** The DC also hosts the Finance share. A production environment should segregate file-server workload from domain controller roles and apply dedicated server hardening.
- **FGPP lockout test:** An isolated fine-grained password policy targeted the fictional employee Taylor Chen; the original default domain account lockout threshold was 0. The lab does **not** demonstrate a domain-wide lockout baseline.
- **ICMP test rule:** A diagnostic inbound ICMPv4 firewall exception was used for host-only connectivity testing. This should not be treated as a generalized production firewall recommendation.
- **Access tests:** Morgan/Finance success, Jordan/IT denial, and post-transfer Avery success validate specific accounts and resources, not exhaustive least-privilege governance.
- **Recovery documentation:** The INC-002 screenshots confirm Taylor's locked then unlocked state and successful login; they do not establish whether recovery was a manual administrative unlock or automatic expiration.

## Publication check

The repository uses fictional employee records and local lab addressing. **No password, authentication token, private key, ACL backup, VM disk, or credential dump is included.** The local `finance-acl-backup.txt` from the supplied ZIP was deliberately excluded because it contains domain ACL identifiers and is not needed for reproducibility. The shared PowerShell source remains readable for peer review.

If using this material in a job application, describe it as a **hands-on virtualized lab** and distinguish it from workplace IT administration experience.
