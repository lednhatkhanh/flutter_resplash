class QueryProvider {
  String _query;

  QueryProvider() {
    _query = null;
  }

  String get query {
    return _query;
  }

  set query(String query) {
    _query = query;
  }
}
