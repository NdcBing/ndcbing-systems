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
    Write-Host "Using existing vault $KeyVaultName in $($existingKeyVault.Location)"
}
catch
{
}

if(!$existingKeyVault)
{
    Write-Host "Creating new vault $VaultName in $location"
    $newKeyVault = New-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $Location -EnabledForDeployment -EnabledForTemplateDeployment
    $resourceId = $newKeyVault.ResourceId
}

Write-Host "Setting permissions for VSTS service principal"
Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyVaultName -ServicePrincipalName "d64ab969-c499-48fe-8919-1b537990d064" -PermissionsToKeys all -PermissionsToSecrets all -PermissionsToCertificates all

Import-Module "$PSScriptRoot\..\vendor\chackdan\Scripts\ServiceFabricRPHelpers\ServiceFabricRPHelpers.psm1"

$ClusterCert = Invoke-AddCertToKeyVault -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -Location $Location -VaultName $KeyVaultName -CertificateName $NewCertName -CreateSelfSignedCertificate -DnsName $DnsName -OutputPath $LocalCertPath -Password $Password

$ClusterCert

Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "ClusterCert-CertificateThumbprint" -SecretValue (ConvertTo-SecureString -String $ClusterCert.CertificateThumbprint -AsPlainText -Force)
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "ClusterCert-SourceVault" -SecretValue (ConvertTo-SecureString -String $ClusterCert.SourceVault -AsPlainText -Force)
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "ClusterCert-CertificateURL" -SecretValue (ConvertTo-SecureString -String $ClusterCert.CertificateURL -AsPlainText -Force)
