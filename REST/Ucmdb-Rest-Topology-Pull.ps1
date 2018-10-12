#<Variables>#
$outputlocation = "****FILE_OUTPUT_LOCATION****"

$body = @{
    username = "****UCMDB_USER****"
    password = "****UCMDB_PASSWORD****"
    clientContext = "1"
}

$topology_query = Get-Content -Raw -Path '.\REST\TopologyQuery.json'

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

$authtoken = Invoke-RestMethod -Uri  https://****UCMDB_HOST****:****UCMDB_PORT****/rest-api/authenticate -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json'

$results = Invoke-RestMethod -Uri  https://****UCMDB_HOST****:****UCMDB_PORT****/rest-api/topologyQuery -Method Post -Headers @{"Authorization" = "Bearer " + $authtoken.token} -Body $topology_query -ContentType 'application/json'

ConvertTo-Json -InputObject $results -Depth 100 | Out-File $outputlocation\powershell-topology.json