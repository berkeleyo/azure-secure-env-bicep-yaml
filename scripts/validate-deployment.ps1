param(
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$TemplateFile,

    [Parameter(Mandatory = $true)]
    [string]$ParameterFile,

    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId
)

<#
.SYNOPSIS
    Performs a validation / what-if style check for the secure environment deployment.

.DESCRIPTION
    This script is designed to be lightweight and safe to run as part of change validation.
    It does not commit changes to production and is intended to be used in non-prod first.
#>

Write-Host "== Azure Secure Environment Validation ==" -ForegroundColor Cyan
Write-Host "Environment : $EnvironmentName"
Write-Host "Location    : $Location"
Write-Host "Template    : $TemplateFile"
Write-Host "Parameters  : $ParameterFile"
Write-Host ""

if ($SubscriptionId) {
    Write-Host "Setting subscription context..."
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
}

$resourceGroupName = "rg-sec-$EnvironmentName"

Write-Host "Validating deployment for resource group '$resourceGroupName'..."

New-AzResourceGroupDeployment `
    -Name "sec-validate-$EnvironmentName" `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $TemplateFile `
    -TemplateParameterFile $ParameterFile `
    -Mode Complete `
    -WhatIf
