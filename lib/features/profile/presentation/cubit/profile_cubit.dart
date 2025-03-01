part of "profile_state.dart";

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;
  StreamSubscription? _userSubscription;
  StreamSubscription? _providerSubscription;
  StreamSubscription? _appFeedbackSubscription;
  StreamSubscription? _emergencySubscription;

  ProfileCubit({required ProfileRepo repo})
      : _repo = repo,
        super(const ProfileState()) {
    getUser();
    getProvider();
    getAppFeedback();
    getEmergency();
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    await _providerSubscription?.cancel();
    await _appFeedbackSubscription?.cancel();
    await _emergencySubscription?.cancel();
    super.close();
  }

  Future<void> getUser() async {
    try {
      emit(state.copyWith(getUserStatus: StateStatus.loading));

      _userSubscription = _repo.getUser().listen((user) {
        emit(state.copyWith(user: [user], getUserStatus: StateStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
          getUserStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> getProvider() async {
    try {
      emit(state.copyWith(getProviderStatus: StateStatus.loading));

      _providerSubscription = _repo.getProvider().listen((provider) {
        emit(state.copyWith(
            provider: provider, getProviderStatus: StateStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
          getProviderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> getAppFeedback() async {
    try {
      emit(state.copyWith(getAppFeedbackStatus: StateStatus.loading));

      _appFeedbackSubscription = _repo.getAppFeedback().listen((feedbacks) {
        emit(state.copyWith(
            appFeedbacks: feedbacks,
            getAppFeedbackStatus: StateStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
          getAppFeedbackStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> getEmergency() async {
    try {
      emit(state.copyWith(getEmergencyStatus: StateStatus.loading));

      _emergencySubscription = _repo.getEmergency().listen((emergency) {
        emit(state.copyWith(
            emergency: emergency, getEmergencyStatus: StateStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
          getEmergencyStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> addFeedback(FeedbackModel feedback) async {
    try {
      emit(state.copyWith(addFeedbackStatus: StateStatus.loading));

      await _repo.addFeedback(feedback: feedback);
      emit(state.copyWith(addFeedbackStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          addFeedbackStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> reportSafetyEmergency(EmergencyModel emergency) async {
    try {
      emit(state.copyWith(reportSafetyEmergencyStatus: StateStatus.loading));

      await _repo.reportSafetyEmergency(emergency: emergency);
      emit(state.copyWith(reportSafetyEmergencyStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          reportSafetyEmergencyStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> updateUser(UserModel user, File? image) async {
    try {
      emit(state.copyWith(updateUserStatus: StateStatus.loading));
      await _repo.updateUser(user: user, image: image);
      emit(state.copyWith(updateUserStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          updateUserStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> updateProvider(ServiceProviderModel provider) async {
    try {
      emit(state.copyWith(updateProviderStatus: StateStatus.loading));

      await _repo.updateProvider(provider: provider);
      emit(state.copyWith(updateProviderStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          updateProviderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> logOut() async {
    try {
      emit(state.copyWith(logOutStatus: StateStatus.loading));

      await _repo.logOut();
      emit(state.copyWith(logOutStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          logOutStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> requestServiceProviderAccess(
      ServiceProviderModel provider,
      File? aadhar, File? pan, File? experience) async {
    try {
      emit(state.copyWith(
          requestServiceProviderAccessStatus: StateStatus.loading));

      await _repo.requestServiceProviderAccess(
          provider: provider, aadhar: aadhar, pan: pan, experience: experience);
      emit(state.copyWith(
          requestServiceProviderAccessStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          requestServiceProviderAccessStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }
}
