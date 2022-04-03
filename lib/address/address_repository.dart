import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class AddressRepository {
  final Dio dio = Dio();

  Future<Response> updateAddress(name, address, pincode, contact_no) async {
    final response = await dio.post(BASE_URL + "/updateaddress/",
        data: {
          "name": name,
          "address": address,
          "pincode": pincode,
          "contact_no": contact_no,
        },
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> initiatePayment(
      items, from_cart, tx_amount, payment_mode) async {
    final response = await dio.post(BASE_URL + "/initiate_payment/",
        data: {
          "items": items,
          "from_cart": from_cart,
          "tx_amount": tx_amount,
          "payment_mode": payment_mode,
        },
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> notifyUrl(data) async {
    final response = await dio.post(BASE_URL + "/notify_url/",
        data:data,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }
}
