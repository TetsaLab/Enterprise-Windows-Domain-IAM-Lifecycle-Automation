# INC-002 — Active Directory account lockout and authentication recovery

| Field | Detail |
|---|---|
| Type | Controlled simulated help desk incident |
| Category | Active Directory authentication / IAM |
| Priority | P3 (simulated lab classification) |
| Status | Authentication restored; account state verified |
| Account | Taylor Chen (`CORP\taylor.chen`, fictional) |
| Client | CLIENT01 |
| Domain controller | DC01 |

## Issue / impact

The fictional employee Taylor Chen's AD account was intentionally locked by entering incorrect credentials on CLIENT01. The purpose was to reproduce an authentication support case, locate the relevant Windows Security record, determine the caller workstation, and demonstrate recovery verification.

## Policy baseline and test setup

The default domain password policy returned a **lockout threshold of 0** (automatic lockout disabled under that default policy). To avoid changing the entire domain's behavior, a **fine-grained password policy** was created specifically for Taylor:

| Setting | Effective value |
|---|---|
| Policy | `PSO-Lab-Taylor-Lockout` |
| Lockout threshold | 3 attempts |
| Duration | 15 minutes |
| Observation window | 15 minutes |

The effective user-specific policy was verified using `Get-ADUserResultantPasswordPolicy`.

## Investigation and observed evidence

- Initial account state: `Enabled = True`, `LockedOut = False`.
- Following controlled incorrect sign-in attempts: `Enabled = True`, `LockedOut = True`.
- Windows Security **Event ID 4740** recorded the lockout on DC01.
- The event's **Caller Computer Name** was `CLIENT01`.
- Event time as displayed by the server: **October 27, 2026, 5:17:46 PM** (timezone not independently established).

```powershell
Get-ADUser -Identity 'taylor.chen' -Properties Enabled,LockedOut |
    Select-Object Name,SamAccountName,Enabled,LockedOut
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4740} |
    Where-Object {$_.Message -match 'taylor\.chen'} |
    Select-Object TimeCreated,Id,Message
```

## Root cause

Controlled, intentionally incorrect password attempts triggered Taylor's fine-grained policy. This was an **authorized lab exercise**, not evidence of an attack.

## Recovery / validation

The user subsequently signed in successfully to CLIENT01 as `CORP\taylor.chen` (`whoami` verified the identity). A later DC01 query confirmed `Enabled = True` and `LockedOut = False`.

**Recovery mechanism not established:** The evidence does **not** distinguish whether an administrator ran `Unlock-ADAccount` or whether the configured 15-minute lockout expired. The verified outcome is restored authentication and an unlocked AD account.

## Evidence

- [Default policy and initial user status](../../screenshots/43-account-lockout-policy-baseline.png)
- [Effective fine-grained password policy](../../screenshots/44-fine-grained-lockout-policy.png)
- [Locked account](../../screenshots/45-ad-account-lockout-detected.png)
- [Security Event ID 4740, caller CLIENT01](../../screenshots/46-account-lockout-event-4740.png)
- [Final unlocked user status](../../screenshots/47-ad-account-unlock-verification.png)
- [Successful domain login](../../screenshots/48-account-recovery-successful-login.png)

## Lessons learned / closure

Correlate AD account-state queries with domain-controller Security events before performing any reset/unlock. Verify identity and approved recovery procedure. After remediation, require actual successful authentication and a final account status check. **Status: Closed (lab simulation).**
