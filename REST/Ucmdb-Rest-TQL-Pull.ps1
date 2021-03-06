﻿#<Variables>#
$outputlocation = "****FILE_OUTPUT_LOCATION****"
$tql_query = '****UCMDB_TQL_QUERY****'
$ucmdb_protocol = '****UCMDB_PROTOCOL****'
$ucmdb_host = '****UCMDB_HOST****'
$ucmdb_port = '****UCMDB_PORT****'

$body = @{
    username = "****UCMDB_USER****"
    password = "****UCMDB_PASSWORD****"
    clientContext = "1"
}
<# this stuff is to ignore ssl errors#>

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

<#API stuff#>

$authtoken = Invoke-RestMethod -Uri ${ucmdb_protocol}://${ucmdb_host}:${ucmdb_port}/rest-api/authenticate -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json'

$results = Invoke-RestMethod -Uri ${ucmdb_protocol}://${ucmdb_host}:${ucmdb_port}/rest-api/topology -Method Post -Headers @{"Authorization" = "Bearer " + $authtoken.token} -Body $tql_query

ConvertTo-Json -InputObject $results.cis -Depth 100 | Out-File $outputlocation\powershell-tql-cis.json -Encoding utf8

ConvertTo-Json -InputObject $results.relations -Depth 100 | Out-File $outputlocation\powershell-tql-relations.json -Encoding utf8