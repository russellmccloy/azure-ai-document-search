// Root myDeserializedClass = JsonConvert.DeserializeObject<Root>(myJsonResponse);
using Newtonsoft.Json;

public class Root
    {
        public List<Value> value { get; set; }
    }

    public class Value
    {
        [JsonProperty("@search.score")]
        public double searchscore { get; set; }
        public string language { get; set; }
        public List<object> organizations { get; set; }
        public string metadata_storage_name { get; set; }
    }

