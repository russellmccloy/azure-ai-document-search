$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("api-key", "hQCGFYYIBrOPBrJh2LQuke6dURKNqJbt89KnWjycB4AzSeBdOEtJ")

$body = @"
{
    `"description`": `"My datasource 2`",
    `"type`": `"azureblob`",
    `"credentials`": {
        `"connectionString`": `"ResourceId=/subscriptions/7c3aee63-0f3a-404b-a9de-f784bb35db35/resourceGroups/rg-russ-azure-ai-document-search/providers/Microsoft.Storage/storageAccounts/russazuresearchsa;`"
    },
    `"container`": {
        `"name`": `"russ-docs`",
        `"query`": null
    }
}
"@

$response = Invoke-RestMethod 'https://russ-azure-search-service.search.windows.net/datasources/russ-azure-search-datasource2?api-version=2020-06-30' -Method 'PUT' -Headers $headers -Body $body
$response | ConvertTo-Json
