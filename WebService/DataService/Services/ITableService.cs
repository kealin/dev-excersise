using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;
using DataService.Models;
using AutoMapper;

namespace DataService.Services
{
    public interface ITableService
    {
        List<SanctionedPersonDto> GetAll();
    }
}