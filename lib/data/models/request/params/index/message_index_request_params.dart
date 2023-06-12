class MessageIndexRequestParams {
  final int startRow;
  final int rowsPerPage = 50;
  MessageIndexRequestParams(this.startRow);


  toData() {
    return {
      'rowsPerPage': rowsPerPage,
      'startRow': startRow,
      'sortBy': 'id',
      'desc': 1
    };
  }
}