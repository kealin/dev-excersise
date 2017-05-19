
using System.Collections.Generic;
using System.Web.Http;
using Swashbuckle.Swagger.Annotations;
using DataService.Services;
using Newtonsoft.Json;
using DataService.Models;

namespace DataService.Controllers
{
    public class SanctionsController : ApiController
    {
        private static TableService InitTableService()
        {
            var client = new TableService();
            return client;
        }

        // GET api/values
        [SwaggerOperation("GetAll")]
        public IEnumerable<SanctionedEntity> Get()
        {
            var client = InitTableService();
            return client.GetAll();
        }
    }
}
