$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

# If this script was run from a GitHub action these values could be stored in the action secrets
$resourceGroup = "russ-dev-azure-ai-document-search-rg"
$indexName = "azureblob-index"

$searchServiceName = $(Get-AzSearchService -ResourceGroupName $resourceGroup).Name
$primaryKey = $(Get-AzSearchAdminKeyPair -ResourceGroupName $resourceGroup -ServiceName $searchServiceName).Primary
$headers.Add("api-key", $primaryKey)

$searchServiceUrl =  "https://$($searchServiceName).search.windows.net"

$body = @"
{
  "fields": [
    {
      "name": "content",
      "type": "Edm.String",
      "searchable": true,
      "sortable": false,
      "filterable": false,
      "facetable": false
    },
    {
      "name": "text",
      "type": "Collection(Edm.String)",
      "facetable": false,
      "filterable": true,
      "searchable": true,
      "sortable": false
    },
    {
      "name": "language",
      "type": "Edm.String",
      "searchable": false,
      "sortable": true,
      "filterable": true,
      "facetable": false
    },
    {
      "name": "keyPhrases",
      "type": "Collection(Edm.String)",
      "searchable": true,
      "sortable": false,
      "filterable": true,
      "facetable": true
    },
    {
      "name": "organizations",
      "type": "Collection(Edm.String)",
      "searchable": true,
      "sortable": false,
      "filterable": true,
      "facetable": true
    },
    {
      "name": "persons",
      "type": "Collection(Edm.String)",
      "searchable": true,
      "sortable": false,
      "filterable": true,
      "facetable": true
    },
    {
      "name": "locations",
      "type": "Collection(Edm.String)",
      "searchable": true,
      "sortable": false,
      "filterable": true,
      "facetable": true
    },
    {
      "name": "metadata_storage_path",
      "type": "Edm.String",
      "key": true,
      "searchable": true,
      "sortable": false,
      "filterable": false,
      "facetable": false
    },
    {
      "name": "metadata_storage_name",
      "type": "Edm.String",
      "searchable": true,
      "sortable": false,
      "filterable": false,
      "facetable": false
    }
  ]
}
"@

$response = Invoke-RestMethod "$($searchServiceUrl)/indexes/$($indexName)?api-version=2023-11-01" -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json