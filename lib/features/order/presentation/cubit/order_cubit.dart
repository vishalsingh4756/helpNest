import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/features/order/data/models/order_model.dart';
import 'package:helpnest/features/order/domain/repo/order_repo.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepo _orderRemoteRepo;
  StreamSubscription? _orderSubscription;
  OrderCubit({required OrderRepo orderRemoteRepo})
      : _orderRemoteRepo = orderRemoteRepo,
        super(const OrderState()) {
    initOrderSubscription();
  }
 
  Future<bool> addOrder({required OrderModel order}) async {
    try {
      emit(state.copyWith(addOrderStatus: StateStatus.loading));
      await _orderRemoteRepo.addOrder(order: order);
      emit(state.copyWith(addOrderStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(state.copyWith(
          addOrderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
      return false;
    }
  }

  Future<bool> updateOrder({required OrderModel order}) async {
    try {
      emit(state.copyWith(updateOrderStatus: StateStatus.loading));
      await _orderRemoteRepo.updateOrder(order: order);
      emit(state.copyWith(updateOrderStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(state.copyWith(
          updateOrderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
      return false;
    }
  }

  Future<void> initOrderSubscription() async {
    try {
      emit(state.copyWith(streamOrderStatus: StateStatus.loading));
      _orderSubscription = _orderRemoteRepo.streamOrders().listen((orders) {
        emit(state.copyWith(
            orders: orders, streamOrderStatus: StateStatus.success));
      });
    } catch (e) {
      log("STREAM_ORDER_ERROR: $e");
      emit(state.copyWith(
          streamOrderStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  @override
  Future<void> close() async {
    await _orderSubscription?.cancel();
    return super.close();
  }
}
