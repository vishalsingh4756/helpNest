part of 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRemoteRepo _remoteRepo;

  ServiceCubit({required ServiceRemoteRepo remoteRepo})
      : _remoteRepo = remoteRepo,
        super(const ServiceState());

  Future<void> getServices() async {
    try {
      emit(state.copyWith(getServicesStatus: StateStatus.loading));
      final services = await _remoteRepo.getServices();
      emit(state.copyWith(
          services: services, getServicesStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          getServicesStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> findServiceProviders(
      {required String serviceID, required Position? position}) async {
    try {
      emit(state.copyWith(findServiceProvidersStatus: StateStatus.loading));
      final serviceProviders =
          await _remoteRepo.findServiceProvider(
          serviceID: serviceID, position: position);
      emit(state.copyWith(
          serviceProviders: serviceProviders,
          findServiceProvidersStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          findServiceProvidersStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> addOrder({required OrderModel order}) async {
    try {
      emit(state.copyWith(addOrderStatus: StateStatus.loading));
      await _remoteRepo.addOrder(order: order);
      emit(state.copyWith(addOrderStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          addOrderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  Future<void> updateServiceID({required String serviceID}) async =>
      emit(state.copyWith(serviceID: serviceID));
}
