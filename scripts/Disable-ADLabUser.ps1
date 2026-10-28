
# Enterprise Windows Domain & IAM Lifecycle Automation Lab
# LEAVER: Employee offboarding automation
# Default: Preview only
# Use -Apply to execute or -Apply -WhatIf to simulate.

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$SamAccountName,

    [switch]$Apply
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

# Restrict script to our isolated lab domain.
$domain = Get-ADDomain

if ($domain.DNSRoot -ne "corp.tetsalab.test") {
    throw "Incorrect domain. Lab execution only."
}

$usersOU = "OU=Users,OU=TetsaLab,$($domain.DistinguishedName)"
$disabledOU = "OU=DisabledUsers,OU=TetsaLab,$($domain.DistinguishedName)"

# Retrieve employee and verify their current location.
$user = Get-ADUser -Identity $SamAccountName `
    -Properties Department, MemberOf, Enabled

if ($user.DistinguishedName -notlike "*,$usersOU") {
    throw "User is not in the approved lab Users OU hierarchy."
}

# Verify the offboarding destination exists.
Get-ADOrganizationalUnit -Identity $disabledOU | Out-Null

# Identify departmental group memberships.
$departments = @("IT", "Finance", "HR", "Sales")
$groupsToRemove = @()

foreach ($dept in $departments) {
    $groupName = "GG_${dept}_Users"
    $group = Get-ADGroup -Identity $groupName

    if ($user.MemberOf -contains $group.DistinguishedName) {
        $groupsToRemove += $groupName
    }
}

# Display the planned offboarding actions.
Write-Host "`nEMPLOYEE OFFBOARDING PLAN" -ForegroundColor Cyan
Write-Host "Username: $SamAccountName"
Write-Host "Department: $($user.Department)"
Write-Host "Currently enabled: $($user.Enabled)"
Write-Host "Current OU: $($user.DistinguishedName)"
Write-Host "Groups to remove: $($groupsToRemove -join ', ')"
Write-Host "Target OU: $disabledOU"
Write-Host "Action: Disable account and revoke departmental access"

if (-not $Apply) {
    Write-Host "`nPREVIEW ONLY: No AD changes made."
    return
}

# Execute only after explicit approval.
if ($PSCmdlet.ShouldProcess(
    $SamAccountName,
    "Disable account, revoke departmental groups and move to DisabledUsers"
)) {
    try {
        # Disable the employee account first.
        Disable-ADAccount -Identity $user.DistinguishedName `
            -ErrorAction Stop

        # Remove departmental security group memberships.
        foreach ($groupName in $groupsToRemove) {
            Remove-ADGroupMember `
                -Identity $groupName `
                -Members $SamAccountName `
                -Confirm:$false `
                -ErrorAction Stop
        }

        # Move the account into the DisabledUsers OU.
        Move-ADObject `
            -Identity $user.DistinguishedName `
            -TargetPath $disabledOU `
            -ErrorAction Stop

        Write-Host "SUCCESS: Employee offboarding completed."
    }
    catch {
        Write-Error "Offboarding incomplete. Review AD state: $($_.Exception.Message)"
        throw
    }
}
