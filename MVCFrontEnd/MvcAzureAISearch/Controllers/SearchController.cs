using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.Text.Encodings.Web;
using Newtonsoft.Json;
using MvcAzureAISearch.Models;

namespace MvcAzureAISearch.Controllers
{
    public class SearchController : Controller
    {

        //Hosted web API REST Service base url
        string searchService = "russ-dev-azure-search-service";
        string indexName = "azureblob-index";
        public async Task<ActionResult> Index()
        {
            string Baseurl = "https://" + searchService + ".search.windows.net/";

            SearchResult searchResult = new SearchResult();
            using (var client = new HttpClient())
            {
                //Passing service base url
                client.BaseAddress = new Uri(Baseurl);
                client.DefaultRequestHeaders.Clear();
                //Define request data format
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Add("api-key", "VMpGCDlYYguqfivKZsEsNkmb3brqn7eeVRAo7sNR6kAzSeCmNUic");
                //Sending request to find web api REST service resource GetAllEmployees using HttpClient
                HttpResponseMessage Res = await client.GetAsync("/indexes/" + indexName + "/docs?search=linux&$select=metadata_storage_name,language,organizations&$count=true&api-version=2020-06-30");
                //Checking the response is successful or not which is sent using HttpClient
                if (Res.IsSuccessStatusCode)
                {
                    // un-comment the following line to get real search data from the Azure AI Search REST API. 
                    // var EmpResponse = Res.Content.ReadAsStringAsync().Result;

                    // The following Json is for debugging the MVC front end without needing to have an instance of Azure AI Search API as this can cost money.
                    var searchResponse = @"{
    ""@odata.context"": ""https://russ-dev-azure-search-service.search.windows.net/indexes('azureblob-index')/$metadata#docs(*)"",
    ""@odata.count"": 1,
    ""value"": [
        {
            ""@search.score"": 4.883404,
            ""language"": ""English"",
            ""organizations"": [],
            ""metadata_storage_name"": ""satyanadellalinux.jpg""
        }
    ]
}
";
                    //Deserializing the response recieved from web api and storing into the Employee list
                    searchResult = JsonConvert.DeserializeObject<SearchResult>(searchResponse);
                }
                //returning the employee list to view
                return View(searchResult);
            }
        }
    }
}