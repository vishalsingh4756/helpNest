import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';
import 'package:helpnest/features/service/domain/repo/service_remote_repo.dart';

part 'service_cubit.dart';

class ServiceState extends Equatable {
  final String serviceID;
  final List<ServiceModel> services;
  final List<FindServiceProviderParams> serviceProviders;
  final StateStatus getServicesStatus;
  final StateStatus findServiceProvidersStatus;
  final StateStatus addOrderStatus;
  final CommonError error;

  const ServiceState({
    this.serviceID = "",
    this.services = const [],
    this.serviceProviders = const [],
    this.getServicesStatus = StateStatus.initial,
    this.findServiceProvidersStatus = StateStatus.initial,
    this.addOrderStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  ServiceState copyWith({
    String? serviceID,
    List<ServiceModel>? services,
    List<FindServiceProviderParams>? serviceProviders,
    StateStatus? getServicesStatus,
    StateStatus? findServiceProvidersStatus,
    StateStatus? addOrderStatus,
    CommonError? error,
  }) {
    return ServiceState(
      serviceID: serviceID ?? this.serviceID,
      services: services ?? this.services,
      serviceProviders: serviceProviders ?? this.serviceProviders,
      getServicesStatus: getServicesStatus ?? this.getServicesStatus,
      findServiceProvidersStatus:
          findServiceProvidersStatus ?? this.findServiceProvidersStatus,
      addOrderStatus: addOrderStatus ?? this.addOrderStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        serviceID,
        services,
        serviceProviders,
        getServicesStatus,
        findServiceProvidersStatus,
        addOrderStatus,
        error,
      ];
}
