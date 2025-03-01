import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';

abstract class SearchRemoteRepo {
  Stream<SearchParam> streamSearchResult({required String input});
  Future<SearchParam> getSearchResult(
      {required String input, required List<ServiceModel> services});
}

class SearchParam {
  final List<FindServiceProviderParams> providers;
  final List<ServiceModel> services;

  SearchParam({required this.providers, required this.services});
}

