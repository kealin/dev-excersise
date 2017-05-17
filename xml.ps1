# Excersise:
# With a script of your preference, download the EU Sanction list from:
# http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml
# Store the downloaded data using a storage option of your choice and include the following fields:
# lastname, firstname, middlename, wholename

# Handle file download and store into variable 
# using Invoke-WebRequest cmdlet 
# (https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.utility/invoke-webrequest)

# Module for Table Storage (https://blogs.technet.microsoft.com/paulomarques/2017/01/17/working-with-azure-storage-tables-from-powershell/)
# Requires following dependencies:
# - AzureRm.profile
# - AzureRm.Profile
# - Azure.Storage
# - AzureRM.Storage

Import-Module AzureRmStorageTable

function initTableStorage
{
	Write-Host "Configuring Azure subscription"

	# Setup Azure sub and table storage
	$subscription = ""
	$resourceGroup = ""
	$storageAccount = ""
	$tableName = "persons"

	Add-AzureRmAccount
	Select-AzureRmSubscription -SubscriptionName $subscription 

	$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context

	# TODO: Try avoiding try catch for flow control
	Try {
		# Seems we have to manually make errors terminating
		$ErrorActionPreference = "Stop";
		$table = Get-AzureStorageTable -Name $tableName -Context $saContext
	}
	Catch [Microsoft.WindowsAzure.Commands.Storage.Common.ResourceNotFoundException]
	{
	   Write-Host "Storage table $tableName doesn't exist, creating it";
	   New-AzureStorageTable –Name $tableName –Context $saContext
	}
	finally
	{
	   # Reset error action to carry on with our flow
	   $ErrorActionPreference = "Continue"; 
	}
}

function fetchXML {
	$url = "http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml"
	Write-Host "Fetching XML from $url"
	Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty content | Out-File sanctions.xml
	[xml]$xml = Get-Content sanctions.xml

	#foreach($person in $xml.WHOLE.ENTITY.NAME) {
	#	Write-Host ---------------------
	#	Write-Host $person.LASTNAME `r`n
	#	Write-Host $person.FIRSTNAME `r`n
	#	Write-Host $person.MIDDLENAME `r`n
	#	Write-Host $person.WHOLENAME `r`n
	#	Write-Host ---------------------
	#}
}

initTableStorage
fetchXML
