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
    Deploys a secure environment using a Bicep template.

.DESCRIPTION
    Thin wrapper over Azure PowerShell to make deployments repeatable and easy
    to align with the patterns used in YAML pipelines.

.NOTES
    This script contains no subscription IDs, tenant IDs, or secrets.
#>

Write-Host "== Azure Secure Environment Deployment ==" -ForegroundColor Cyan
Write-Host "Environment : $EnvironmentName"
Write-Host "Location    : $Location"
Write-Host "Template    : $TemplateFile"
Write-Host "Parameters  : $ParameterFile"
Write-Host ""

if ($SubscriptionId) {
    Write-Host "Setting subscription context..."
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
}

# In a real implementation you would likely parameterise resource group as well.
$resourceGroupName = "rg-sec-$EnvironmentName"

Write-Host "Ensuring resource group '$resourceGroupName' exists..."

$rg = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Host "Creating resource group '$resourceGroupName' in '$Location'..."
    $rg = New-AzResourceGroup -Name $resourceGroupName -Location $Location
}

Write-Host "Starting deployment..."

$deploymentName = "sec-$EnvironmentName-{0:yyyyMMddHHmmss}" -f (Get-Date)

New-AzResourceGroupDeployment `
    -Name $deploymentName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $TemplateFile `
    -TemplateParameterFile $ParameterFile `
    -Verbose

Write-Host "Deployment complete. Check the Azure portal and activity logs for details."
