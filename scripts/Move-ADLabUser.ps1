
# Enterprise Windows Domain & IAM Lifecycle Automation Lab
# MOVER: Transfer a fictional employee between departments.
# Default behavior: Preview only.
# Use -Apply to execute or -Apply -WhatIf to simulate.

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$SamAccountName,

    [Parameter(Mandatory = $true)]
    [ValidateSet("IT", "Finance", "HR", "Sales")]
    [string]$NewDepartment,

    [switch]$Apply
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

# Restrict execution to the training domain.
$domain = Get-ADDomain

if ($domain.DNSRoot -ne "corp.tetsalab.test") {
    throw "Incorrect domain. This script is for the lab only."
}

# Retrieve the existing employee.
$user = Get-ADUser -Identity $SamAccountName `
    -Properties Department, MemberOf, Enabled

# Resolve and verify the target OU and group.
$targetOU = "OU=$NewDepartment,OU=Users,OU=TetsaLab,$($domain.DistinguishedName)"
$targetGroup = "GG_${NewDepartment}_Users"

Get-ADOrganizationalUnit -Identity $targetOU | Out-Null
$newGroup = Get-ADGroup -Identity $targetGroup

# Identify existing departmental group memberships.
$departments = @("IT", "Finance", "HR", "Sales")
$groupsToRemove = @()

foreach ($dept in $departments) {
    if ($dept -eq $NewDepartment) {
        continue
    }

    $groupName = "GG_${dept}_Users"
    $group = Get-ADGroup -Identity $groupName

    if ($user.MemberOf -contains $group.DistinguishedName) {
        $groupsToRemove += $groupName
    }
}

$needsGroupAdd = $user.MemberOf -notcontains $newGroup.DistinguishedName
$needsMove = $user.DistinguishedName -notlike "*,$targetOU"
$needsDepartmentUpdate = $user.Department -ne $NewDepartment

# Display planned actions.
Write-Host "`nEMPLOYEE TRANSFER PLAN" -ForegroundColor Cyan
Write-Host "Username: $SamAccountName"
Write-Host "Current department: $($user.Department)"
Write-Host "New department: $NewDepartment"
Write-Host "Target OU: $targetOU"
Write-Host "Remove groups: $($groupsToRemove -join ', ')"
Write-Host "Add group: $(if ($needsGroupAdd) { $targetGroup } else { 'Already assigned' })"
Write-Host "OU move required: $needsMove"
Write-Host "Department update required: $needsDepartmentUpdate"

if (-not $Apply) {
    Write-Host "`nPREVIEW ONLY: No AD changes made."
    return
}

# Execute only when explicitly approved.
if ($PSCmdlet.ShouldProcess(
    $SamAccountName,
    "Revoke old department access, assign $targetGroup, update OU and Department"
)) {
    try {
        # Revoke old departmental access.
        foreach ($groupName in $groupsToRemove) {
            Remove-ADGroupMember -Identity $groupName `
                -Members $SamAccountName `
                -Confirm:$false -ErrorAction Stop
        }

        # Assign new departmental access.
        if ($needsGroupAdd) {
            Add-ADGroupMember -Identity $targetGroup `
                -Members $SamAccountName -ErrorAction Stop
        }

        # Move user to the correct department OU.
        if ($needsMove) {
            Move-ADObject -Identity $user.DistinguishedName `
                -TargetPath $targetOU -ErrorAction Stop
        }

        # Update department attribute.
        if ($needsDepartmentUpdate) {
            Set-ADUser -Identity $SamAccountName `
                -Department $NewDepartment -ErrorAction Stop
        }

        Write-Host "SUCCESS: Employee transfer completed."
    }
    catch {
        Write-Error "Transfer incomplete. Review AD state: $($_.Exception.Message)"
        throw
    }
}
