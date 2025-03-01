abstract class SearchLocalRepo {
  Future<void> addSearchKeywords({required String input});
  Future<void> deleteSearchKeywords({required String input});
  Future<List<String>> getSearchKeywords();
}
