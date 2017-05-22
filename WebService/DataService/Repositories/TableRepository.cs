using DataService.Models;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DataService.Repositories
{
    public class TableRepository : ITableRepository
    {
        private CloudStorageAccount _storageAccount;
        private CloudTableClient tableClient;
        private CloudTable table;

        private readonly String tableName = "SanctionedPeople";
        private readonly String partitionKey = "sanctioned";

        public TableRepository(CloudStorageAccount storageAccount)
        {
            _storageAccount = storageAccount;
            tableClient = _storageAccount.CreateCloudTableClient();
            table = tableClient.GetTableReference(tableName);
            table.CreateIfNotExists();
        }

        // TODO: Implement paging
        public IEnumerable<SanctionedPerson> GetAll()
        {
            TableQuery<SanctionedPerson> query = new TableQuery<SanctionedPerson>()
          .Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey));
            return table.ExecuteQuery(query);
        }
    }
}