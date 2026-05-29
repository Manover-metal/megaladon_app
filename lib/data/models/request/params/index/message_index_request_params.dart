class MessageIndexRequestParams {
  MessageIndexRequestParams(this.startRow);
  final int startRow;
  final int rowsPerPage = 50;

  Map<String, Object> toData() => {
        'rowsPerPage': rowsPerPage,
        'startRow': startRow,
        'sortBy': 'id',
        'desc': 1
      };
}
