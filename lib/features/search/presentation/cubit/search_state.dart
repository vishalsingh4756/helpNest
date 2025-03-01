part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<FindServiceProviderParams> providers;
  final List<ServiceModel> services;
  final List<String> keywords;
  final StateStatus getSearchResultStatus;
  final StateStatus streamSearchResultStatus;
  final StateStatus addSearchKeywordsStatus;
  final StateStatus deleteSearchKeywordsStatus;
  final StateStatus getSearchKeywordsStatus;
  final CommonError error;

  const SearchState({
    this.providers = const [],
    this.services = const [],
    this.keywords = const [],
    this.getSearchResultStatus = StateStatus.initial,
    this.streamSearchResultStatus = StateStatus.initial,
    this.addSearchKeywordsStatus = StateStatus.initial,
    this.deleteSearchKeywordsStatus = StateStatus.initial,
    this.getSearchKeywordsStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  SearchState copyWith({
    List<FindServiceProviderParams>? providers,
    List<ServiceModel>? services,
    List<String>? keywords,
    StateStatus? getSearchResultStatus,
    StateStatus? streamSearchResultStatus,
    StateStatus? addSearchKeywordsStatus,
    StateStatus? deleteSearchKeywordsStatus,
    StateStatus? getSearchKeywordsStatus,
    CommonError? error,
  }) {
    return SearchState(
      providers: providers ?? this.providers,
      services: services ?? this.services,
      keywords: keywords ?? this.keywords,
      getSearchResultStatus:
          getSearchResultStatus ?? this.getSearchResultStatus,
      streamSearchResultStatus:
          streamSearchResultStatus ?? this.streamSearchResultStatus,
      addSearchKeywordsStatus:
          addSearchKeywordsStatus ?? this.addSearchKeywordsStatus,
      deleteSearchKeywordsStatus:
          deleteSearchKeywordsStatus ?? this.deleteSearchKeywordsStatus,
      getSearchKeywordsStatus:
          getSearchKeywordsStatus ?? this.getSearchKeywordsStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        providers,
        services,
        keywords,
        getSearchResultStatus,
        streamSearchResultStatus,
        addSearchKeywordsStatus,
        deleteSearchKeywordsStatus,
        getSearchKeywordsStatus,
        error,
      ];
}
