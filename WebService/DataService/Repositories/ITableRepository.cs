using DataService.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DataService.Repositories
{
    public interface ITableRepository
    {
        IEnumerable<SanctionedPerson> GetAll();
    }
}