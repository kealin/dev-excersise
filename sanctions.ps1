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

function Init-Table-Storage
{
	Write-Host "Configuring Azure subscription"

	# Setup Azure sub and table storage
	$subscription = "Pay-As-You-Go"
	$resourceGroup = "if-exercise"
	$storageAccount = "iftablestorage"
	$tableName = "persons"
	
	# PartitionKey and RowKey are indexed for a clustered index 
	# => Faster lookups
	$partitionKey = "sanctioned"
	
	Add-AzureRmAccount
	Select-AzureRmSubscription -SubscriptionName $subscription 

	$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context

	# TODO: Try avoiding try catch for flow control
	Try {
		# Seems we have to manually make errors terminating
		$ErrorActionPreference = "Stop";
		Write-Host "Fetching table $tableName"
		$global:table = Get-AzureStorageTable -Name $tableName -Context $saContext
		Fetch-XML
	}
	Catch [Microsoft.WindowsAzure.Commands.Storage.Common.ResourceNotFoundException]
	{
	   Write-Host "Storage table $tableName doesn't exist, creating it";
	   New-AzureStorageTable –Name $tableName –Context $saContext
	   $global:table = Get-AzureStorageTable -Name $tableName -Context $saContext
	   Fetch-XML
	}
	finally
	{
	   # Reset error action to carry on with our flow
	   $ErrorActionPreference = "Continue"; 
	}
}

function Fetch-XML {
	$url = "http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml"
	Write-Host "Fetching XML from $url"
	[Net.HttpWebRequest]$WebRequest = [Net.WebRequest]::Create($url)
    [Net.HttpWebResponse]$WebResponse = $WebRequest.GetResponse()
    $Reader = New-Object IO.StreamReader($WebResponse.GetResponseStream())
    [xml]$xml = $Reader.ReadToEnd()
    $Reader.Close()

	foreach($person in $xml.WHOLE.ENTITY.NAME) {
		Add-StorageTableRow -table $table -partitionKey $partitionKey -rowKey ([guid]::NewGuid().tostring()) -property @{"lastName"=$person.LASTNAME;"firstName"=$person.FIRSTNAME;"middleName"=$person.MIDDLENAME;"wholeName"=$person.WHOLENAME}
	}
}

Init-Table-Storage

