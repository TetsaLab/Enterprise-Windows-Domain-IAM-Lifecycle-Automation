# Lab reproduction and verification guide

**Scope:** Isolated training lab. These are reference steps, not a one-click deployment and not production rollout instructions. The screenshot evidence documents the original build; your fresh environment will differ.

## Requirements

- VMware Workstation or another hypervisor with a private virtual network
- Windows Server 2025 Standard Evaluation with AD DS/DNS features
- Windows 11 Pro or another domain-join capable Windows edition
- Administrative rights on the lab domain controller and ActiveDirectory PowerShell module
- A disposable lab-only AD forest named `corp.tetsalab.test`

## Original topology

| System | Address | Roles |
|---|---|---|
| DC01 | `192.168.184.10/24` | AD DS, DNS, GPO, SMB Finance share |
| CLIENT01 | `192.168.184.20/24` | Domain member / policy and access tests |
| Network | `192.168.184.0/24` | VMware VMnet1 host-only; local DHCP disabled |

## Deployment sequence

1. Build a host-only network and deploy both virtual machines.
2. Configure static IPv4 addresses; configure CLIENT01 DNS to point to `192.168.184.10`.
3. Install AD DS and DNS on DC01 and promote it into a new forest named `corp.tetsalab.test`.
4. Validate `Get-ADDomain` and an AD SRV-record lookup.
5. Join CLIENT01 to the domain; restart and validate computer membership.
6. Build the `TetsaLab` OU structure and global departmental security groups.
7. Create one manual lab account; use the included CSV and Joiner script for additional fictional employees.
8. Preview, `-WhatIf`, then (in your own authorized test forest) execute the Mover and Leaver scripts; verify results.
9. Link the workstation GPO and verify the applied 900-second inactivity policy.
10. Create nested Finance resource permissions and test separate permitted/denied user sessions.
11. Document the controlled DNS, lockout, and share-access investigations.

## Domain and DNS verification examples

```powershell
Get-ADDomain | Select-Object DNSRoot,DomainMode
Resolve-DnsName -Name '_ldap._tcp.dc._msdcs.corp.tetsalab.test' -Type SRV -Server 192.168.184.10
Get-ADComputer -Identity CLIENT01 | Select-Object Name,DistinguishedName
```

## Script usage examples

Copy or clone the project into a folder on DC01. PowerShell commands below assume the current directory is the repository root. They **do not modify AD** without an explicit `-Apply` argument. Review target account and groups before running anything.

```powershell
# Joiner — preview then simulation
& '.\scripts\New-ADLabUsers.ps1' -CsvPath '.\sample-data\employees.csv'
& '.\scripts\New-ADLabUsers.ps1' -CsvPath '.\sample-data\employees.csv' -Apply -WhatIf

# Mover — preview then simulation
& '.\scripts\Move-ADLabUser.ps1' -SamAccountName 'avery.johnson' -NewDepartment 'Finance'
& '.\scripts\Move-ADLabUser.ps1' -SamAccountName 'avery.johnson' -NewDepartment 'Finance' -Apply -WhatIf

# Leaver — preview then simulation
& '.\scripts\Disable-ADLabUser.ps1' -SamAccountName 'cameron.davis'
& '.\scripts\Disable-ADLabUser.ps1' -SamAccountName 'cameron.davis' -Apply -WhatIf
```

Live `-Apply` is intentionally omitted from this quickstart: it should only be used in an authorized disposable lab with verified prerequisites, explicit approval and a suitable snapshot/rollback strategy. Script-level execution safeguards do not replace backup or change control.

## GPO verification

```powershell
gpupdate /force
gpresult /scope computer /r
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name InactivityTimeoutSecs
```

## Access-control verification

```powershell
Get-ADGroupMember 'DL_Finance_Share_Modify'
Get-SmbShareAccess -Name 'Finance'
icacls 'C:\Lab\Shares\Finance'
# From a permitted domain account on CLIENT01:
Get-Content '\\DC01\Finance\Finance-Test.txt'
```

For the complete execution evidence and incident investigations, refer to the [project README](../README.md) and [evidence index](evidence-index.md).
