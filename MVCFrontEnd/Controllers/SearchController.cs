using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.Text.Encodings.Web;
using Newtonsoft.Json;
using MvcAzureAISearch.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.WebUtilities;

namespace MvcAzureAISearch.Controllers
{
    public class SearchController : Controller
    {
        private readonly IConfiguration Configuration;
        private readonly ILogger<HomeController> _logger;

        string indexName = "azureblob-index";

        public SearchController(IConfiguration configuration, ILogger<HomeController> logger)
        {
            Configuration = configuration;
            _logger = logger;
        }
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public async Task<ActionResult> SearchResults(string searchTerm)
        {
            // Get these two values from config
            string? searchService = Configuration["AzureAISearchService"];
            string? apiKey = Configuration["AzureAISearchApiKey"];

            string Baseurl = "https://" + searchService + ".search.windows.net/";

            SearchResult searchResult = new SearchResult();

            using (var client = new HttpClient())
            {
                //Passing service base url
                client.BaseAddress = new Uri(Baseurl);
                client.DefaultRequestHeaders.Clear();

                //Define request data format
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                // Set the Azure AI search API key into request headers
                client.DefaultRequestHeaders.Add("api-key", apiKey);

                //Sending request to find web api REST service resource 'searchTerm' using HttpClient
                HttpResponseMessage Res = await client.GetAsync("/indexes/" + indexName + "/docs?search=" + searchTerm + "&$select=metadata_storage_name,metadata_storage_path,language,organizations&$count=true&api-version=2020-06-30");

                if (Res.IsSuccessStatusCode)
                {
                    var searchResponse = Res.Content.ReadAsStringAsync().Result;

                    //Deserializing the response received from web api and storing into the Employee list
                    searchResult = JsonConvert.DeserializeObject<SearchResult>(searchResponse);
                    //returning the employee list to view

                }

                List<Details> modifiedSearchResultDetails = new List<Details>();
                SearchResult modifiedSearchResult = new SearchResult();
                modifiedSearchResult.OdataCount = searchResult.OdataCount;
                modifiedSearchResult.OdataContext = searchResult.OdataContext;
                modifiedSearchResult.Details = new List<Details>();

                var str1 = new string[3]{ "https://rdmc01devazuresearchsa.blob.core.windows.net/rdmc01-dev-docs/16.docx",
                    "https://rdmc01devazuresearchsa.blob.core.windows.net/rdmc01-dev-docs/10.png",
                    "https://rdmc01devazuresearchsa.blob.core.windows.net/rdmc01-dev-docs/14.jpg"
                };

                int counter = 0;
                foreach (var result in searchResult.Details)
                {
                    // This is ugly but not the focus of what I am trying to achieve so please forgiver me.
                    //string actualStoragePath = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(result.MetadataStoragePath));
                    // string actualStoragePath = result.MetadataStoragePath // str1[counter];

                    byte[] data = Convert.FromBase64String(result.MetadataStoragePath);
                    string decodedString = System.Text.Encoding.UTF8.GetString(data);

                    Details newDetails = new Details();

                    newDetails.MetadataStorageName = result.MetadataStorageName;
                    newDetails.MetadataStoragePath = decodedString; //actualStoragePath;

                    modifiedSearchResult.Details.Add(newDetails);

                    counter++;
                }

                return View("SearchResults", modifiedSearchResult);
            }
        }
    }
}
