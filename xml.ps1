# Excersise:
# With a script of your preference, download the EU Sanction list from:
# http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml
# Store the downloaded data using a storage option of your choice and include the following fields:
# lastname, firstname, middlename, wholename

$url = "http://ec.europa.eu/external_relations/cfsp/sanctions/list/version4/global/global.xml"
Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty content | Out-File sanctions.xml
[xml]$xml = Get-Content sanctions.xml

foreach($person in $xml.WHOLE.ENTITY.NAME) {
	Write-Host ---------------------
	Write-Host $person.LASTNAME `r`n
	Write-Host $person.FIRSTNAME `r`n
	Write-Host $person.MIDDLENAME `r`n
	Write-Host $person.WHOLENAME `r`n
	Write-Host ---------------------
}