import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/features/search/domain/repo/search_local_repo.dart';
import 'package:helpnest/features/search/domain/repo/search_remote_repo.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRemoteRepo _remoteRepo;
  final SearchLocalRepo _localRepo;

  SearchCubit({
    required SearchRemoteRepo remoteRepo,
    required SearchLocalRepo localRepo,
  })  : _remoteRepo = remoteRepo,
        _localRepo = localRepo,
        super(const SearchState());

  Future<void> getSearchResult(
      {required String input, required List<ServiceModel> services}) async {
    try {
      emit(state.copyWith(getSearchResultStatus: StateStatus.loading));
      final result =
          await _remoteRepo.getSearchResult(input: input, services: services);
      emit(state.copyWith(
        services: result.services,
        providers: result.providers,
        getSearchResultStatus: StateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        getSearchResultStatus: StateStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      ));
    }
  }

  Future<void> addSearchKeyword({required String input}) async {
    try {
      emit(state.copyWith(addSearchKeywordsStatus: StateStatus.loading));
      await _localRepo.addSearchKeywords(input: input);
      final updatedKeywords = await _localRepo.getSearchKeywords();
      emit(state.copyWith(
        keywords: updatedKeywords,
        addSearchKeywordsStatus: StateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        addSearchKeywordsStatus: StateStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      ));
    }
  }

  Future<void> deleteSearchKeyword({required String input}) async {
    try {
      emit(state.copyWith(deleteSearchKeywordsStatus: StateStatus.loading));
      await _localRepo.deleteSearchKeywords(input: input);
      final updatedKeywords = await _localRepo.getSearchKeywords();
      emit(state.copyWith(
        keywords: updatedKeywords,
        deleteSearchKeywordsStatus: StateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        deleteSearchKeywordsStatus: StateStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      ));
    }
  }

  Future<void> getSearchKeywords() async {
    try {
      emit(state.copyWith(getSearchKeywordsStatus: StateStatus.loading));
      final keywords = await _localRepo.getSearchKeywords();
      emit(state.copyWith(
        keywords: keywords,
        getSearchKeywordsStatus: StateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        getSearchKeywordsStatus: StateStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      ));
    }
  }
}
