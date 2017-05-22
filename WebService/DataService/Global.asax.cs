using AutoMapper;
using DataService.App_Start;
using DataService.Controllers;
using DataService.Models;
using DataService.Repositories;
using DataService.Services;
using Microsoft.Azure;
using Microsoft.Practices.Unity;
using Microsoft.WindowsAzure.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Routing;

namespace DataService
{
    public class WebApiApplication : HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
        
            // Unity IoC setup
            var container = new UnityContainer();

            container.RegisterType<SanctionController>();
            container.RegisterType<ITableService, TableService>();
            container.RegisterType<ITableRepository, TableRepository>();     

            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"));
            container.RegisterInstance(storageAccount);

            var config = new MapperConfiguration(cfg => {
                cfg.CreateMap<SanctionedPerson, SanctionedPersonDto>();
            });

            IMapper mapper = config.CreateMapper();

            container.RegisterInstance(mapper);


            // Override default dependency resolver
            GlobalConfiguration.Configuration.DependencyResolver = new IoCContainer(container);

        }
    }
}
