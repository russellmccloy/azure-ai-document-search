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
  "description": "Apply OCR, detect language, extract entities, and extract key-phrases.",
  "cognitiveServices": null,
  "skills":
  [
    {
      "@odata.type": "#Microsoft.Skills.Vision.OcrSkill",
      "context": "/document/normalized_images/*",
      "defaultLanguageCode": "en",
      "detectOrientation": true,
      "inputs": [
        {
          "name": "image",
          "source": "/document/normalized_images/*"
        }
      ],
      "outputs": [
        {
          "name": "text"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.MergeSkill",
      "description": "Create merged_text, which includes all the textual representation of each image inserted at the right location in the content field. This is useful for PDF and other file formats that supported embedded images.",
      "context": "/document",
      "insertPreTag": " ",
      "insertPostTag": " ",
      "inputs": [
        {
          "name":"text", 
          "source": "/document/content"
        },
        {
          "name": "itemsToInsert", 
          "source": "/document/normalized_images/*/text"
        },
        {
          "name":"offsets", 
          "source": "/document/normalized_images/*/contentOffset" 
        }
      ],
      "outputs": [
        {
          "name": "mergedText", 
          "targetName" : "merged_text"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.SplitSkill",
      "textSplitMode": "pages",
      "maximumPageLength": 4000,
      "defaultLanguageCode": "en",
      "context": "/document",
      "inputs": [
        {
          "name": "text",
          "source": "/document/merged_text"
        }
      ],
      "outputs": [
        {
          "name": "textItems",
          "targetName": "pages"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.LanguageDetectionSkill",
      "description": "If you have multilingual content, adding a language code is useful for filtering",
      "context": "/document",
      "inputs": [
        {
          "name": "text",
          "source": "/document/merged_text"
        }
      ],
      "outputs": [
        {
          "name": "languageName",
          "targetName": "language"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.KeyPhraseExtractionSkill",
      "context": "/document/pages/*",
      "inputs": [
        {
          "name": "text",
          "source": "/document/pages/*"
        }
      ],
      "outputs": [
        {
          "name": "keyPhrases",
          "targetName": "keyPhrases"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.V3.EntityRecognitionSkill",
      "categories": ["Organization"],
      "context": "/document",
      "inputs": [
        {
          "name": "text",
          "source": "/document/merged_text"
        }
      ],
      "outputs": [
        {
          "name": "organizations",
          "targetName": "organizations"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.V3.EntityRecognitionSkill",
      "categories": ["Location"],
      "context": "/document",
      "inputs": [
        {
          "name": "text",
          "source": "/document/merged_text"
        }
      ],
      "outputs": [
        {
          "name": "locations",
          "targetName": "locations"
        }
      ]
    },
    {
      "@odata.type": "#Microsoft.Skills.Text.V3.EntityRecognitionSkill",
      "categories": ["Person"],
      "context": "/document",
      "inputs": [
        {
          "name": "text",
          "source": "/document/merged_text"
        }
      ],
      "outputs": [
        {
          "name": "persons",
          "targetName": "persons"
        }
      ]
    }
  ]
}
"@

$response = Invoke-RestMethod "$($searchServiceUrl)/skillsets/$($indexName)-skillset?api-version=2023-11-01" -Method 'PUT' -Headers $headers -Body $body
$response | ConvertTo-Json