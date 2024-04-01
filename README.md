# Azure AI Search

Please see the related blog post here for all the information you need: [https://russellmccloy.github.io/2024-04-01-azure-ai-search](https://russellmccloy.github.io/2024-04-01-azure-ai-search/)

## Things to note

- Remember to update the `appsettings.Development.json` file with your search API key and service name
  
```json
{
  "AzureAISearchApiKey": "<SET_YOUR_SEARCH_SERVICE_API_KEY_HERE>",
  "AzureAISearchService": "<SET_YOUR_SEARCH_SERVICE_NAME_HERE>",
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

- The MVC code is just thrown together and I didn't put much effort into it as it's just used to display text and images.
