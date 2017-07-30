


$location = 'eastus2'
$resourceGroupName = "$location-fabric-keyvault"
$keyVaultName = "$location-fabric-keyvault"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -Location $location -EnabledForDeployment
