part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int bottomNavIndex;
  final bool providerMode;
  final List<AdBannerModel> adBanners;
  final Position? position;
  final List<UserLocationModel> lastLocation;
  final bool locationEnabled;
  final StateStatus getAdBannerStatus;
  final StateStatus getLocationStatus;
  final StateStatus getLocationFromDatabaseStatus;
  final StateStatus updateLocationToDatabaseStatus;
  final StateStatus detectActiveOrderStatus;
  final StateStatus updatePointsToActiveOrderStatus;
  final CommonError error;

  const HomeState({
    this.bottomNavIndex = 0,
    this.providerMode = false,
    this.adBanners = const [],
    this.position,
    this.lastLocation = const [],
    this.locationEnabled = false,
    this.getAdBannerStatus = StateStatus.initial,
    this.getLocationStatus = StateStatus.initial,
    this.getLocationFromDatabaseStatus = StateStatus.initial,
    this.updateLocationToDatabaseStatus = StateStatus.initial,
    this.detectActiveOrderStatus = StateStatus.initial,
    this.updatePointsToActiveOrderStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  HomeState copyWith({
    int? bottomNavIndex,
    bool? providerMode,
    List<AdBannerModel>? adBanners,
    Position? position,
    List<UserLocationModel>? lastLocation,
    bool? locationEnabled,
    StateStatus? getAdBannerStatus,
    StateStatus? getLocationStatus,
    StateStatus? getLocationFromDatabaseStatus,
    StateStatus? updateLocationToDatabaseStatus,
    StateStatus? detectActiveOrderStatus,
    StateStatus? updatePointsToActiveOrderStatus,
    CommonError? error,
  }) {
    return HomeState(
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      providerMode: providerMode ?? this.providerMode,
      adBanners: adBanners ?? this.adBanners,
      position: position ?? this.position,
      lastLocation: lastLocation ?? this.lastLocation,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      getAdBannerStatus: getAdBannerStatus ?? this.getAdBannerStatus,
      getLocationStatus: getLocationStatus ?? this.getLocationStatus,
      getLocationFromDatabaseStatus:
          getLocationFromDatabaseStatus ?? this.getLocationFromDatabaseStatus,
      updateLocationToDatabaseStatus:
          updateLocationToDatabaseStatus ?? this.updateLocationToDatabaseStatus,
      detectActiveOrderStatus:
          detectActiveOrderStatus ?? this.detectActiveOrderStatus,
      updatePointsToActiveOrderStatus: updatePointsToActiveOrderStatus ??
          this.updatePointsToActiveOrderStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        bottomNavIndex,
        providerMode,
        adBanners,
        position,
        lastLocation,
        locationEnabled,
        getAdBannerStatus,
        getLocationStatus,
        getLocationFromDatabaseStatus,
        updateLocationToDatabaseStatus,
        detectActiveOrderStatus,
        updatePointsToActiveOrderStatus,
        error
      ];
}
