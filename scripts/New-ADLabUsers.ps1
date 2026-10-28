
# Enterprise Windows Domain & IAM Lifecycle Automation Lab
# Purpose: Provision fictional employees from a CSV.
# Default: Preview only. Use -Apply to create accounts.

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$CsvPath = "C:\Lab\IAM\employees.csv",
    [switch]$Apply
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

# Safety check: Only run against our lab domain.
$domain = Get-ADDomain
if ($domain.DNSRoot -ne "corp.tetsalab.test") {
    throw "Incorrect domain. This script is for corp.tetsalab.test only."
}

$groups = @{
    IT      = "GG_IT_Users"
    Finance = "GG_Finance_Users"
    HR      = "GG_HR_Users"
    Sales   = "GG_Sales_Users"
}

$employees = @(Import-Csv -Path $CsvPath)
if ($employees.Count -eq 0) {
    throw "The employee CSV contains no records."
}

$plan = @()
$seen = @{}

foreach ($employee in $employees) {
    $first = ([string]$employee.FirstName).Trim()
    $last  = ([string]$employee.LastName).Trim()
    $sam   = ([string]$employee.SamAccountName).Trim()
    $dept  = ([string]$employee.Department).Trim()

    if (-not $first -or -not $last -or
        $sam -notmatch '^[a-zA-Z][a-zA-Z0-9._-]{0,19}$') {
        throw "Invalid employee record or username: $sam"
    }

    if (-not $groups.ContainsKey($dept)) {
        throw "Unsupported department: $dept"
    }

    if ($seen.ContainsKey($sam.ToLowerInvariant())) {
        throw "Duplicate username in CSV: $sam"
    }
    $seen[$sam.ToLowerInvariant()] = $true

    $ou = "OU=$dept,OU=Users,OU=TetsaLab,$($domain.DistinguishedName)"
    $group = $groups[$dept]

    # Verify target OU and group exist.
    Get-ADOrganizationalUnit -Identity $ou | Out-Null
    Get-ADGroup -Identity $group | Out-Null

    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'"

    $plan += [pscustomobject]@{
        FirstName  = $first
        LastName   = $last
        Username   = $sam
        Department = $dept
        OU         = $ou
        Group      = $group
        Status     = if ($existing) { "EXISTS - SKIP" } else { "NEW" }
    }
}

Write-Host "`nEmployee provisioning plan:"
$plan | Select-Object Username,Department,Group,Status |
    Format-Table -AutoSize

if (-not $Apply) {
    Write-Host "PREVIEW ONLY: No Active Directory changes made."
    return
}

# One temporary password for fictional lab accounts only.
# Production onboarding requires stronger credential controls.
if (-not $WhatIfPreference) {
    $password = Read-Host "Enter a strong temporary LAB password" -AsSecureString
}

foreach ($person in $plan) {
    if ($person.Status -ne "NEW") {
        Write-Warning "Skipping existing user: $($person.Username)"
        continue
    }

    $sam = $person.Username

    if ($PSCmdlet.ShouldProcess(
        $sam,
        "Create AD account and assign $($person.Group)"
    )) {
        try {
            New-ADUser `
                -Name "$($person.FirstName) $($person.LastName)" `
                -GivenName $person.FirstName `
                -Surname $person.LastName `
                -SamAccountName $sam `
                -UserPrincipalName "$sam@$($domain.DNSRoot)" `
                -Department $person.Department `
                -Path $person.OU `
                -AccountPassword $password `
                -Enabled $true `
                -ChangePasswordAtLogon $true `
                -ErrorAction Stop

            Add-ADGroupMember `
                -Identity $person.Group `
                -Members $sam `
                -ErrorAction Stop

            Write-Host "SUCCESS: Created $sam and assigned $($person.Group)"
        }
        catch {
            Write-Warning "FAILED: $sam - $($_.Exception.Message)"
        }
    }
}
