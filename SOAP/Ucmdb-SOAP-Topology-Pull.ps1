$lastrun_timestamp = get-date -UFormat %s
$password = ConvertTo-SecureString “****UCMDB_PASSWORD****” -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential (“****UCMDB_USER****”, $password)
$uri = "http://****UCMDB_HOST****:****UCMDB_PORT****/axis2/services/UcmdbService?wsdl"
$initialresult = [xml](Invoke-WebRequest -Uri $uri -InFile 'C:\powershell\ucmdb SOAP\soap_request_wBusApp.xml' -ContentType "text/xml" -Method POST -Credential $Cred)
$chunkkey1 = $initialresult.Envelope.Body.executeTopologyQueryByNameResponse.chunkInfo.chunksKey | select -ExpandProperty key1
$chunkkey2 = $initialresult.Envelope.Body.executeTopologyQueryByNameResponse.chunkInfo.chunksKey | select -ExpandProperty key2
$numberofchunks = $($initialresult.Envelope.Body.executeTopologyQueryByNameResponse.chunkInfo | select -ExpandProperty numberOfChunks)
$chunklist = 1..$numberofchunks

foreach ($chunk in $chunklist) 
{
$chunk_request = (get-content -Path 'C:\powershell\ucmdb SOAP\chunk_request_template.xml').Replace("CURRENTCHUNK","$chunk").Replace("TOTALNUMBEROFCHUNKS","$numberofchunks").Replace("CHUNKKEYONE","$chunkkey1").Replace("CHUNKKEYTWO","$chunkkey2")
$chunkresult = [xml](Invoke-WebRequest -Uri $uri -Body $chunk_request -ContentType "text/xml" -Method POST -Credential $Cred)
$filename = "$lastrun_timestamp soapchunk$chunk"
$chunkresult.Save("C:\powershell\ucmdb SOAP\$filename.xml")
}