import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/order_details_model.dart';
import 'order_details_repository.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this.orderId) : super(OrderDetailsInitial()) {
    loadDetails();
  }

  String orderId;

  OrderDetailsRepository _repository = OrderDetailsRepository();

  void loadDetails() {
    emit(OrderDetailsLoading());
    _repository.loadDetails(orderId).then((response) {
      emit(OrderDetailsLoaded(OrderDetailsModel.fromJson(response.data)));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(OrderDetailsFailed(error.response!.data));
        } catch (e) {
          emit(OrderDetailsFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(OrderDetailsFailed("Please check your internet connection!"));
        } else {
          emit(OrderDetailsFailed(error.message));
        }
      }
    });
  }

  void updateRating(rating) {
    _repository.updateRating(orderId, rating).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(OrderDetailsFailed(error.response!.data));
        } catch (e) {
          emit(OrderDetailsFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(OrderDetailsFailed("Please check your internet connection!"));
        } else {
          emit(OrderDetailsFailed(error.message));
        }
      }
    });
  }
}
