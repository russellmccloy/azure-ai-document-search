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
  "dataSourceName" : "$($indexName)-datasource",
  "targetIndexName" : "$($indexName)",
  "skillsetName" : "$($indexName)-skillset",
  "fieldMappings" : [
        {
          "sourceFieldName" : "metadata_storage_path",
          "targetFieldName" : "metadata_storage_path",
          "mappingFunction" : { "name" : "base64Encode" }
        },
        {
        	"sourceFieldName": "metadata_storage_name",
        	"targetFieldName": "metadata_storage_name"
        }
   ],
  "outputFieldMappings" : 
	[
		{
        	"sourceFieldName": "/document/merged_text",
        	"targetFieldName": "content"
        },
        {
            "sourceFieldName" : "/document/normalized_images/*/text",
            "targetFieldName" : "text"
        },
  		{
          "sourceFieldName" : "/document/organizations", 
          "targetFieldName" : "organizations"
        },
        {
        	"sourceFieldName": "/document/language",
        	"targetFieldName": "language"
        },
  		{
          "sourceFieldName" : "/document/persons", 
          "targetFieldName" : "persons"
        },
  		{
          "sourceFieldName" : "/document/locations", 
          "targetFieldName" : "locations"
        },
        {
          "sourceFieldName" : "/document/pages/*/keyPhrases/*", 
          "targetFieldName" : "keyPhrases"
        }
    ],
  "parameters":
  {
	"batchSize": 1,
  	"maxFailedItems":-1,
  	"maxFailedItemsPerBatch":-1,
  	"configuration": 
	{
    	"dataToExtract": "contentAndMetadata",
    	"imageAction": "generateNormalizedImages"
	}
  }
}
"@

$response = Invoke-RestMethod "$($searchServiceUrl)/indexers/$($indexName)-indexer?api-version=2023-11-01" -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json