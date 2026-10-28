# Screenshot evidence index

All screenshots are original evidence from the uploaded virtual lab. Numbering follows the lab walkthrough; numbers **07, 08 and 11** were not supplied. Numbers **34 and 39** were recovered from earlier chat screenshots and given their expected filenames for consistency. Supplemental setup images use the `00-` prefix.

| Screenshot | What it demonstrates |
|---|---|
| [00-dc01-icmp-firewall-rule.png](../screenshots/00-dc01-icmp-firewall-rule.png) | Domain controller ICMPv4 inbound troubleshooting rule |
| [00-windows-server-2025-setup.png](../screenshots/00-windows-server-2025-setup.png) | Windows Server 2025 evaluation edition with Desktop Experience selected |
| [01-vmware-network-configuration.png](../screenshots/01-vmware-network-configuration.png) | VMnet1 host-only network with static subnet and DHCP disabled |
| [02-dc01-static-ip-configuration.png](../screenshots/02-dc01-static-ip-configuration.png) | DC01 IPv4 and DNS static settings |
| [03-network-verification.png](../screenshots/03-network-verification.png) | DC01 IP configuration verified by ipconfig |
| [04-client01-static-ip-configuration.png](../screenshots/04-client01-static-ip-configuration.png) | CLIENT01 initial self-referencing DNS setting (INC-001 baseline, not final configuration) |
| [05-dc01-client01-connectivity.png](../screenshots/05-dc01-client01-connectivity.png) | Successful ping from client to DC01 |
| [06-adds-role-verification.png](../screenshots/06-adds-role-verification.png) | AD DS role installed and verified |
| [09-domain-controller-options.png](../screenshots/09-domain-controller-options.png) | Server 2025 domain controller options |
| [10-ad-ds-prerequisites-check.png](../screenshots/10-ad-ds-prerequisites-check.png) | AD DS promotion prerequisites passed (DNS delegation warning was nonblocking) |
| [12-active-directory-domain-verification.png](../screenshots/12-active-directory-domain-verification.png) | Get-ADDomain output confirming forest and domain configuration |
| [13-active-directory-dns-verification.png](../screenshots/13-active-directory-dns-verification.png) | AD SRV DNS lookup resolves domain controller |
| [14-client01-dns-resolution.png](../screenshots/14-client01-dns-resolution.png) | CLIENT01 DNS corrected and name resolution verified |
| [15-client01-domain-join.png](../screenshots/15-client01-domain-join.png) | CLIENT01 domain-join configuration |
| [16-successful-domain-join.png](../screenshots/16-successful-domain-join.png) | Welcome to corp.tetsalab.test domain |
| [17-client01-domain-membership.png](../screenshots/17-client01-domain-membership.png) | CLIENT01 domain membership confirmed |
| [18-client01-active-directory-computer.png](../screenshots/18-client01-active-directory-computer.png) | AD computer object recognized on DC01 |
| [19-enterprise-ou-structure.png](../screenshots/19-enterprise-ou-structure.png) | TetsaLab OU hierarchy |
| [20-client01-workstations-ou.png](../screenshots/20-client01-workstations-ou.png) | CLIENT01 placed in workstation OU |
| [21-departmental-security-groups.png](../screenshots/21-departmental-security-groups.png) | Global security group objects in Groups OU |
| [22-manual-user-provisioning.png](../screenshots/22-manual-user-provisioning.png) | Manual creation of Alex Morgan in IT OU |
| [23-user-group-membership.png](../screenshots/23-user-group-membership.png) | Manually created user and group membership checked |
| [24-employee-csv-validation.png](../screenshots/24-employee-csv-validation.png) | Eight sample CSV rows validated |
| [25-onboarding-automation-preview.png](../screenshots/25-onboarding-automation-preview.png) | Joiner script preview, no changes |
| [26-onboarding-whatif.png](../screenshots/26-onboarding-whatif.png) | Joiner script WhatIf output |
| [27-automated-user-provisioning.png](../screenshots/27-automated-user-provisioning.png) | Eight newly created lab users and initial nine-account inventory |
| [28-iam-provisioning-validation.png](../screenshots/28-iam-provisioning-validation.png) | Nine initial user OU and group tests passed |
| [29-iam-mover-preview.png](../screenshots/29-iam-mover-preview.png) | Sales-to-Finance transfer preview |
| [30-iam-mover-whatif.png](../screenshots/30-iam-mover-whatif.png) | Mover script WhatIf output |
| [31-iam-mover-verification.png](../screenshots/31-iam-mover-verification.png) | Mover executed; Finance OU/group true and Sales group removed |
| [32-iam-leaver-preview.png](../screenshots/32-iam-leaver-preview.png) | Cameron offboarding preview |
| [33-iam-leaver-whatif.png](../screenshots/33-iam-leaver-whatif.png) | Leaver script WhatIf output |
| [34-iam-leaver-verification.png](../screenshots/34-iam-leaver-verification.png) | Account disabled, removed from Sales group and placed in DisabledUsers OU |
| [35-workstation-security-gpo.png](../screenshots/35-workstation-security-gpo.png) | Workstation inactivity limit set to 900 seconds |
| [36-workstation-gpo-verification.png](../screenshots/36-workstation-gpo-verification.png) | GPO applied and 900-second timeout registry value verified |
| [37-finance-resource-group.png](../screenshots/37-finance-resource-group.png) | Finance global group nested in domain local resource group |
| [38-finance-ntfs-permissions.png](../screenshots/38-finance-ntfs-permissions.png) | Finance folder/test-file NTFS ACLs |
| [39-finance-smb-share-configuration.png](../screenshots/39-finance-smb-share-configuration.png) | Finance SMB share access ACL |
| [40-finance-authorized-access.png](../screenshots/40-finance-authorized-access.png) | Morgan Patel read and wrote Finance resource |
| [41-finance-unauthorized-access-denied.png](../screenshots/41-finance-unauthorized-access-denied.png) | Jordan Lee denied access to Finance file |
| [42-iam-mover-resource-access.png](../screenshots/42-iam-mover-resource-access.png) | Avery Johnson successfully reads/writes after transfer to Finance |
| [43-account-lockout-policy-baseline.png](../screenshots/43-account-lockout-policy-baseline.png) | Default lockout policy and Taylor initial account state |
| [44-fine-grained-lockout-policy.png](../screenshots/44-fine-grained-lockout-policy.png) | Taylor-specific effective FGPP threshold of three |
| [45-ad-account-lockout-detected.png](../screenshots/45-ad-account-lockout-detected.png) | Taylor account shows LockedOut=True |
| [46-account-lockout-event-4740.png](../screenshots/46-account-lockout-event-4740.png) | Windows Security Event ID 4740 with caller CLIENT01 |
| [47-ad-account-unlock-verification.png](../screenshots/47-ad-account-unlock-verification.png) | Taylor account shows Enabled=True and LockedOut=False; does not prove manual unlock |
| [48-account-recovery-successful-login.png](../screenshots/48-account-recovery-successful-login.png) | Taylor successful domain sign-in evidenced by whoami |
| [49-helpdesk-share-access-investigation.png](../screenshots/49-helpdesk-share-access-investigation.png) | Jordan/Morgan AD group membership and Finance resource group nesting |
| [50-helpdesk-share-access-investigation-smb.png](../screenshots/50-helpdesk-share-access-investigation-smb.png) | Finance SMB share permissions during help desk investigation |

**Do not infer that the pre-change screenshots show the final state.** For example, screenshot 04 documents CLIENT01’s initial incorrect DNS server; screenshot 14 documents the subsequent fix. Screenshots 43–48 describe the account-lockout lab and do not prove that recovery was manually initiated.
