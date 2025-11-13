param(
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId
)

<#
.SYNOPSIS
    Removes a non-production secure environment.

.DESCRIPTION
    This script will remove the resource group used by the specified environment.
    Use with care and only for non-production environments.
#>

Write-Host "== Azure Secure Environment Removal ==" -ForegroundColor Yellow
Write-Host "Environment : $EnvironmentName"
Write-Host "Location    : $Location"
Write-Host ""

if ($SubscriptionId) {
    Write-Host "Setting subscription context..."
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
}

$resourceGroupName = "rg-sec-$EnvironmentName"

Write-Warning "You are about to delete resource group '$resourceGroupName'."
$confirmation = Read-Host "Type the resource group name to confirm"

if ($confirmation -ne $resourceGroupName) {
    Write-Host "Confirmation did not match. Aborting." -ForegroundColor Red
    exit 1
}

Remove-AzResourceGroup -Name $resourceGroupName -Force

Write-Host "Deletion requested. Monitor the Azure portal for progress."
