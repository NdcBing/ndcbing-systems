[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string]$location = "eastus2"
)

$resourceGroupLocation = "eastus2"
$resourceGroupName = "fabric-keyvaults"
$keyVaultName = "ndcbing-$location-kv"
$dnsName = "$location.ndcbing.com"
$localCertPath = "."
$newCertName = "$dnsName"

$azureRmContext = Get-AzureRmContext
$subscriptionId = $azureRmContext.Subscription.SubscriptionId

Import-Module "$PSScriptRoot\..\vendor\chackdan\Scripts\ServiceFabricRPHelpers\ServiceFabricRPHelpers.psm1"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Force

New-AzureRmKeyVault -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -Location $location -EnabledForDeployment -Force

Invoke-AddCertToKeyVault -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -Location $location -VaultName $keyVaultName -CertificateName $newCertName -CreateSelfSignedCertificate -DnsName $dnsName -OutputPath $localCertPath
