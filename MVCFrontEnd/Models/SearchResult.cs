    using System.Text.Json.Serialization;
namespace MvcAzureAISearch.Models;

using Newtonsoft.Json;

// A model that represents the search data that is returned
public class SearchResult
    {
        [JsonProperty("@odata.context")]
        public string? OdataContext { get; set; }

        [JsonProperty("@odata.count")]
        public int? OdataCount { get; set; }

        [JsonProperty("value")]
        public List<Details>? Details { get; set; }
    }

    public class Details
    {
        [JsonProperty("@search.score")]
        public double? SearchScore { get; set; }

        [JsonProperty("language")]
        public string? Language { get; set; }

        [JsonProperty("organizations")]
        public List<object>? Organizations { get; set; }

        [JsonProperty("metadata_storage_name")]
        public string? MetadataStorageName { get; set; }

        [JsonProperty("metadata_storage_path")]
        public string MetadataStoragePath { get; set; }
    }

