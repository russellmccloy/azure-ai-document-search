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

                foreach (var result in searchResult.Details)
                {
                    // This is ugly but not the focus of what I am trying to achieve so please forgiver me.
                    string actualStoragePath = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(result.MetadataStoragePath));

                    actualStoragePath = actualStoragePath.Replace("jpg5", "jpg"); // #HACK: cant work out why the Base64Decode doesn't work on these url strings

                    Details newDetails = new Details();

                    newDetails.MetadataStorageName = result.MetadataStorageName;
                    newDetails.MetadataStoragePath = actualStoragePath;

                    modifiedSearchResult.Details.Add(newDetails);
                }

                return View("SearchResults", modifiedSearchResult);
            }
        }
    }
}
