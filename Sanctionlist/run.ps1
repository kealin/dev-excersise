# Excersise:
# With a script of your preference, download the EU Sanction list from:
# http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml
# Store the downloaded data using a storage option of your choice and include the following fields:
# lastname, firstname, middlename, wholename

function Init-Table
{
    param($storageContext, $tableName, $createIfNotExists)

    $table = Get-AzureStorageTable $tableName -Context $storageContext -ErrorAction Ignore
    if ($table -eq $null)
    {   
        $table = New-AzureStorageTable $tablename -Context $storageContext
    }
    
    return $table.CloudTable
}

function Init-Table-Storage
{
	$ConnectionString = "$($env:ConnectionString)"
	$Ctx = New-AzureStorageContext -ConnectionString $ConnectionString
	$TableName = "SanctionedPeople"
	
	return Init-Table $Ctx $TableName
}

function Fetch-XML {
	
	$url = "http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml"
	[Net.HttpWebRequest]$WebRequest = [Net.WebRequest]::Create($url)
    [Net.HttpWebResponse]$WebResponse = $WebRequest.GetResponse()
    $Reader = New-Object IO.StreamReader($WebResponse.GetResponseStream())
    [xml]$xml = $Reader.ReadToEnd()
    $Reader.Close()
	return $xml
}

function Insert-XML 
{
	param($table, $xml)
	# PartitionKey and RowKey form clustered index
	# => Faster lookups
	$PartitionKey = "sanctioned"

	$batches = @{}

	foreach($person in $xml.WHOLE.ENTITY.NAME) {
	
		$rowKey = ([guid]::NewGuid().tostring())
		$entity = New-Object -TypeName Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity -ArgumentList $partitionKey, $rowKey
		$entity.Properties.Add("LastName", $person.LASTNAME)
		$entity.Properties.Add("FirstName", $person.FIRSTNAME)
		$entity.Properties.Add("MiddleName", $person.MIDDLENAME)
		$entity.Properties.Add("WholeName", $person.WHOLENAME)
		
	   if ($batches.ContainsKey($partitionKey) -eq $false)
       {
           $batches.Add($partitionKey, (New-Object Microsoft.WindowsAzure.Storage.Table.TableBatchOperation))
       }

       $batch = $batches[$partitionKey]
       $batch.Add([Microsoft.WindowsAzure.Storage.Table.TableOperation]::InsertOrReplace($entity));

       if ($batch.Count -eq 100)
       {
           $table.ExecuteBatch($batch);
           $batches[$partitionKey] = (New-Object Microsoft.WindowsAzure.Storage.Table.TableBatchOperation)
       }			 
	}
}

$table = Init-Table-Storage
$xml = Fetch-XML
Insert-XML $table $xml