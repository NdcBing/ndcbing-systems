[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string] $location = "eastus2"
)

$resourceGroupName = "ndcbing-$location-kv"
$keyVaultName = "ndcbing-$location-kv"

$dnsName = "$location.ndcbing.com"
$localCertPath = "$PSScriptRoot"
$newCertName = "$location-ndcbing-com"
$password = "Secret5!"

$azureRmContext = Get-AzureRmContext
$subscriptionId = $azureRmContext.Subscription.SubscriptionId

Import-Module "$PSScriptRoot\..\vendor\chackdan\Scripts\ServiceFabricRPHelpers\ServiceFabricRPHelpers.psm1"

Invoke-AddCertToKeyVault -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -Location $location -VaultName $keyVaultName -CertificateName $newCertName -CreateSelfSignedCertificate -DnsName $dnsName -OutputPath $localCertPath -Password $password
