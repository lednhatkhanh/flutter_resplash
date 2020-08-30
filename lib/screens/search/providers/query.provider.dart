class QueryProvider {
  String _query;

  QueryProvider(String query) {
    _query = query;
  }

  String get query {
    return _query;
  }

  set query(String query) {
    _query = query;
  }
}
