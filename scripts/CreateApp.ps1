$tenantId = (Get-AzureRmContext).Subscription.TenantId
$locations = @("westus2", "eastus2")
$appName = "NDCBingProduction"

$ConfigObj = & "$PSScriptRoot\MicrosoftAzureServiceFabric-AADHelpers\SetupApplications.ps1" `
    -TenantId $tenantId `
    -WebApplicationReplyUrl ( $locations | %{"https://$_.ndcbing.com/"} ) `
    -WebApplicationName "$($appName)_Cluster" `
    -NativeClientApplicationName "$($appName)_Client" `
    -WebApplicationUri "https://$appName"

$locations | %{
    $KeyVaultName = "ndcbing-$_-kv"

    Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$appName-TenantId" -SecretValue (ConvertTo-SecureString -String $ConfigObj.TenantId -AsPlainText -Force)
    Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$appName-WebAppId" -SecretValue (ConvertTo-SecureString -String $ConfigObj.WebAppId -AsPlainText -Force)
    Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$appName-NativeClientAppId" -SecretValue (ConvertTo-SecureString -String $ConfigObj.NativeClientAppId -AsPlainText -Force)
}
