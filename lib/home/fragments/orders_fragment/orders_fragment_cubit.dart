import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment_repository.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment_state.dart';
import 'package:my_smartstore/models/orders_item_model.dart';

class OrdersFragmentCubit extends Cubit<OrdersFragmentState>{
  OrdersFragmentCubit() : super(OrdersInitial());

  OrdersFragmentRepository _repository = OrdersFragmentRepository();

  void loadOrders(){
    emit(OrdersLoading());
    _repository.loadOrders().then((response) {
      emit(OrdersLoaded(OrdersItemModel.fromJson(response.data)));

    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(OrdersFailed(error.response!.data));
        } catch (e) {
          emit(OrdersFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(OrdersFailed("Please check your internet connection!"));
        } else {
          emit(OrdersFailed(error.message));
        }
      }
    });
  }

  void loadMoreItems(){
    var oldstate = state as OrdersLoaded;
    emit(OrdersLoading());
    _repository.loadMoreOrders(nextUrl: oldstate.ordersItemModel.next!).then((response){
      OrdersItemModel newData = OrdersItemModel.fromJson(response.data);
      oldstate.ordersItemModel.results?.addAll(newData.results!);
      newData.results = oldstate.ordersItemModel.results!;
      emit(OrdersLoaded(newData));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(OrdersFailed(error.response!.data));
        } catch (e) {
          emit(OrdersFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(OrdersFailed("Please check your internet connection!"));
        } else {
          emit(OrdersFailed(error.message));
        }
      }
    });
  }

}