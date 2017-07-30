[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string] $Location = "eastus2"
)

$ResourceGroupName = "ndcbing-$location-kv"
$KeyVaultName = "ndcbing-$location-kv"

$DnsName = "$location.ndcbing.com"
$LocalCertPath = "$PSScriptRoot"
$NewCertName = "$location-ndcbing-com"
$Password = "Secret5!"

$AzureRmContext = Get-AzureRmContext
$SubscriptionId = $azureRmContext.Subscription.SubscriptionId

Write-Host "Ensuring ResourceGroup $ResourceGroupName in $Location"
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Force | Out-Null

try
{
    $existingKeyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName
    $resourceId = $existingKeyVault.ResourceId
    Write-Host "Using existing vault $VaultName in $($existingKeyVault.Location)"
}
catch
{
}

if(!$existingKeyVault)
{
    Write-Host "Creating new vault $VaultName in $location"
    $newKeyVault = New-AzureRmKeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroupName -Location $Location -EnabledForDeployment
    $resourceId = $newKeyVault.ResourceId
}

Set-AzureRmKeyVaultAccessPolicy -VaultName $VaultName -ObjectId "d64ab969-c499-48fe-8919-1b537990d064" -PermissionsToKeys all -PermissionsToSecrets all -PermissionsToCertificates all

Import-Module "$PSScriptRoot\..\vendor\chackdan\Scripts\ServiceFabricRPHelpers\ServiceFabricRPHelpers.psm1"

Invoke-AddCertToKeyVault -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -Location $Location -VaultName $KeyVaultName -CertificateName $NewCertName -CreateSelfSignedCertificate -DnsName $DnsName -OutputPath $LocalCertPath -Password $Password
