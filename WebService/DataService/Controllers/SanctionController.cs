using DataService.Models;
using DataService.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace DataService.Controllers
{
    public class SanctionController : ApiController
    {
        private ITableService _tableService;

        public SanctionController(ITableService tableService)
        {
            _tableService = tableService;
        }

        public List<SanctionedPersonDto> Get()
        {
            return _tableService.GetAll();
        }
    }
}
