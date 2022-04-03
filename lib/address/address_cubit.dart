import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/cart_model.dart';

import 'address_repository.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  AddressRepository _repository = AddressRepository();

  void updateAddress(name, address, pincode, contact_no) {
    emit(AddressUpdating());
    _repository
        .updateAddress(name, address, pincode, contact_no)
        .then((response) {
      emit(AddressUpdated(
        response.data['name'],
        response.data['address'],
        response.data['contact_no'],
        response.data['district'],
        response.data['state'],
        response.data['pincode'],
      ));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(AddressFailed(error.response!.data));
        } catch (e) {
          emit(AddressFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(AddressFailed("Please check your internet connection!"));
        } else {
          emit(AddressFailed(error.message));
        }
      }
    });
  }

  void initiatePayment(
      List<CartModel> products, from_cart, tx_amount, payment_mode) {
    var items = products
        .map((e) => {
              "id": e.id,
              "quantity": e.selected_qty,
            })
        .toList();
    emit(InitiatingPayment());
    _repository
        .initiatePayment(items, from_cart, tx_amount, payment_mode)
        .then((response) {
      emit(PaymentInitiated(
          response.data['token'],
          response.data['orderCurrency'],
          response.data['orderId'],
          response.data['tx_amount'].toString(),
          response.data['appId']));
    }).catchError((value) {
      print(value);
      DioError error = value;
      if (error.response != null) {
        try {
          emit(AddressFailed(error.response!.data));
        } catch (e) {
          emit(AddressFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(AddressFailed("Please check your internet connection!"));
        } else {
          emit(AddressFailed(error.message));
        }
      }
    });
  }

  void notifyUrl(data){
    emit(ProcessingPayment());
    _repository.notifyUrl(data)
    .then((response) {
      if(data['txStatus']=='SUCCESS') {
        emit(PaymentProcessed());
      }else{
        emit(PaymentFailed(data['txMsg']));
      }
    })
        .catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(AddressFailed(error.response!.data));
        } catch (e) {
          emit(AddressFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(AddressFailed("Please check your internet connection!"));
        } else {
          emit(AddressFailed(error.message));
        }
      }
    });
  }
}
