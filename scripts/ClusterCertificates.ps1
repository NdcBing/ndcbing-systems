
$location = 'eastus2'
$resourceGroupLocation = "eastus2"

$resourceGroupName = "fabric-keyvaults"

$keyVaultName = "ndcbing-$location-kv"

$dnsName = "$location.ndcbing.com"
$localCertPath = "."
$newCertName = "$dnsName"

$azureContext = Get-AzureRmContext

Import-Module "..\vendor\chackdan\Scripts\ServiceFabricRPHelpers\ServiceFabricRPHelpers.psm1"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

New-AzureRmKeyVault -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -Location $location -EnabledForDeployment

Invoke-AddCertToKeyVault -SubscriptionId $azureContext.SubscriptionId -ResourceGroupName $resourceGroupName -Location $location -VaultName $keyVaultName -CertificateName $newCertName -CreateSelfSignedCertificate -DnsName $dnsName -OutputPath $localCertPath
