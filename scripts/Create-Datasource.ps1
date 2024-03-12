$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

# If this script was run from a GitHub action these values could be stored in the action secrets
$resourceGroup = "russ-dev-azure-ai-document-search-rg"
$storageAccountName = "russdevazuresearchsa"
$dataSourceName = "russ-search-datasource"
$storageAccountContainerName = "russ-dev-docs"
$indexName = "azureblob-index"

$searchServiceName = $(Get-AzSearchService -ResourceGroupName $resourceGroup).Name
$primaryKey = $(Get-AzSearchAdminKeyPair -ResourceGroupName $resourceGroup -ServiceName $searchServiceName).Primary
$headers.Add("api-key", $primaryKey)

$storageAccountId = $(Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).id
$searchServiceUrl =  "https://$($searchServiceName).search.windows.net"

$body = @"
{
    `"description`": "$($dataSourceName)-datasource",
    `"type`": `"azureblob`",
    `"credentials`": {
        `"connectionString`": `"ResourceId=$($storageAccountId);`"
    },
    `"container`": {
        `"name`": `"$($storageAccountContainerName)`"
    }
}
"@

$response = Invoke-RestMethod "$($searchServiceUrl)/datasources/$($indexName)-datasource?api-version=2023-11-01" -Method 'PUT' -Headers $headers -Body $body
$response | ConvertTo-Json

