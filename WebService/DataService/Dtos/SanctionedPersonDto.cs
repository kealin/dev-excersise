using Microsoft.WindowsAzure.Storage.Table;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DataService.Models
{
    public class SanctionedPersonDto
    { 
        public SanctionedPersonDto()
        {
        }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string MiddleName { get; set; }

        public string WholeName { get; set; }
    }
}