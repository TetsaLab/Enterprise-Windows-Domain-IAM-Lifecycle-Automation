# INC-003 — Finance network share access denied

| Field | Detail |
|---|---|
| Type | Simulated help desk access investigation |
| Category | Access management / AD security groups / SMB / NTFS |
| Priority | P4 (simulated lab classification) |
| Status | Resolved — expected security enforcement; no permissions changed |
| Reported user | Jordan Lee (`CORP\jordan.lee`, IT department) |
| Resource | `\\DC01\Finance\Finance-Test.txt` |

## Issue / impact

Jordan Lee, a fictional IT department employee, received **Access is denied** when attempting to read a document on the Finance network share. The investigation tested whether the denial represented a technical misconfiguration or appropriate protection of departmental resources.

## Investigation

- Verified the identity using `whoami` in Jordan's separate CLIENT01 Windows session.
- Reproduced an **Access is denied** error with `Get-Content` against `\\DC01\Finance\Finance-Test.txt`.
- Queried Jordan's and authorized Finance employee Morgan Patel's group memberships.
- Confirmed `GG_Finance_Users` was nested in the domain-local group `DL_Finance_Share_Modify`.
- Verified `Get-SmbShareAccess -Name Finance`: group had **Change**; local Administrators had **Full**.
- Verified Finance folder NTFS access: Finance resource group had **Modify**, with administrative and SYSTEM controls retained.
- Corroborated the policy by successfully reading, creating and reading back files as Morgan Patel.

```powershell
Get-ADPrincipalGroupMembership 'jordan.lee' |
    Where-Object Name -like 'GG_*_Users'
Get-ADPrincipalGroupMembership 'morgan.patel' |
    Where-Object Name -like 'GG_*_Users'
Get-ADGroupMember 'DL_Finance_Share_Modify'
Get-SmbShareAccess -Name 'Finance'
icacls 'C:\Lab\Shares\Finance'
```

## Findings

| Check | Observation |
|---|---|
| Jordan's departmental group | `GG_IT_Users` |
| Morgan's departmental group | `GG_Finance_Users` |
| Resource group membership | `GG_Finance_Users` nested in `DL_Finance_Share_Modify` |
| SMB permission | `DL_Finance_Share_Modify` → Change |
| NTFS permission | `DL_Finance_Share_Modify` → Modify |
| Finance user | Read/write succeeded |
| IT user | Access denied |

## Root cause and resolution

**Expected security enforcement.** Jordan had not been assigned the Finance departmental entitlement. The share/NTFS rules performed as configured. **No permissions were changed** to eliminate the denial.

If Jordan had a legitimate business requirement, a production service desk would route an access request for appropriate resource-owner approval and only then authorize a least-privilege change. No such approval was simulated or implied by this case.

## Evidence

- [Global-to-domain-local group nesting](../../screenshots/37-finance-resource-group.png)
- [Finance folder and test-file NTFS permissions](../../screenshots/38-finance-ntfs-permissions.png)
- [SMB share permissions](../../screenshots/39-finance-smb-share-configuration.png)
- [Finance user's successful read/write](../../screenshots/40-finance-authorized-access.png)
- [IT user's denied read](../../screenshots/41-finance-unauthorized-access-denied.png)
- [Group membership investigation](../../screenshots/49-helpdesk-share-access-investigation.png)
- [Share ACL investigation](../../screenshots/50-helpdesk-share-access-investigation-smb.png)

## Lessons learned / closure

An access denied message is not necessarily a failure. Verify identity, AD group inheritance, NTFS and SMB ACLs, and actual outcomes before deciding whether a permission change is appropriate. **Status: Closed — expected security behavior (lab simulation).**
