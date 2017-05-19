using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;
using DataService.Models;

namespace DataService.Services
{
    public class TableService
    {
        public readonly String tableName = "SanctionedPeople";
        public readonly String partitionKey = "sanctioned";
        public CloudTable table;
        public CloudTableClient tableClient;
        public CloudStorageAccount storageAccount;

        public TableService()
        {
            storageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"));
            tableClient = storageAccount.CreateCloudTableClient();
            table = tableClient.GetTableReference(tableName);
            table.CreateIfNotExists();
        }

        public IEnumerable<SanctionedEntity> GetAll()
        {
            TableQuery<SanctionedEntity> query = new TableQuery<SanctionedEntity>()
                .Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey));
            return table.ExecuteQuery(query);
        }
        
    }
}