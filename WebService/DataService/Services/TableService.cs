using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;
using DataService.Models;
using AutoMapper;
using DataService.Repositories;

namespace DataService.Services
{
    public class TableService : ITableService
    {
        private readonly ITableRepository _tableRepository;
        private readonly IMapper _mapper;

        public TableService(ITableRepository tableRepository, IMapper mapper)
        {
            _tableRepository = tableRepository;
            _mapper = mapper;
        }

        public List<SanctionedPersonDto> GetAll()
        {
            var data = _tableRepository.GetAll();
            return _mapper.Map<List<SanctionedPersonDto>>(data);
        }
    }
}