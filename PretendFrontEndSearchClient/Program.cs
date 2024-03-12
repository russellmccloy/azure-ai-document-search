using System.Net.Http.Headers;
// using Newtonsoft.Json;
using System.Text.Json;

using HttpClient client = new();
client.DefaultRequestHeaders.Accept.Clear();
client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
client.DefaultRequestHeaders.Add("api-key", "pPLVlYdRfDIrzy55WWID0nCbiWXu7tPrW4gHMUHvhoAzSeBdRp3I");
// client.DefaultRequestHeaders.Add("User-Agent", ".NET Foundation Repository Reporter");

await SearchForKeyWordAsync(client);

static async Task SearchForKeyWordAsync(HttpClient client)
{
    var search_service = "russ-dev-azure-search-service";
    var index_name = "azureblob-index";
    var keyword_to_search_for = "linux";

    var json = await client.GetStringAsync(
         "https://" + search_service+ ".search.windows.net/indexes/" + index_name + "/docs?search=" + keyword_to_search_for + "&$select=metadata_storage_name,language,organizations&$count=true&api-version=2020-06-30");

     Console.Write(json);

     Value? theData = 
                JsonSerializer.Deserialize<Value>(json);

    Console.WriteLine(theData.metadata_storage_name);
}