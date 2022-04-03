import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/cart_model.dart';

import 'cart_fragment_repository.dart';
import 'cart_fragment_state.dart';

class CartFragmentCubit extends Cubit<CartFragmentState>{
  CartFragmentCubit() : super(CartInitial());

  CartFragmentRepository _repository = CartFragmentRepository();

  void loadCart(id){
    emit(CartLoading());
    _repository.loadCart(id)
        .then((response){
      emit(CartLoaded(List.from(response.data.map((json)=>CartModel.fromJson(json)))));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(CartFailed(error.response!.data));
        } catch (e) {
          emit(CartFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(CartFailed("Please check your internet connection!"));
        } else {
          emit(CartFailed(error.message));
        }
      }
    });
  }

  void removeItem(id){
    CartLoaded oldstate = state as CartLoaded;

    oldstate.products.removeWhere((element) => element.id==id);
    emit(CartLoaded(oldstate.products));

  }

}