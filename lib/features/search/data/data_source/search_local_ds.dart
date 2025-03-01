import 'package:helpnest/features/search/domain/repo/search_local_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocalDs implements SearchLocalRepo {
  static const String _searchKeywordsKey = 'search_keywords';

  @override
  Future<void> addSearchKeywords({required String input}) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> keywords = prefs.getStringList(_searchKeywordsKey) ?? [];

    if (!keywords.contains(input)) {
      keywords.add(input);
      await prefs.setStringList(_searchKeywordsKey, keywords);
    }
  }

  @override
  Future<void> deleteSearchKeywords({required String input}) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> keywords = prefs.getStringList(_searchKeywordsKey) ?? [];

    if (keywords.contains(input)) {
      keywords.remove(input);
      await prefs.setStringList(_searchKeywordsKey, keywords);
    }
  }

  @override
  Future<List<String>> getSearchKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchKeywordsKey) ?? [];
  }
}
