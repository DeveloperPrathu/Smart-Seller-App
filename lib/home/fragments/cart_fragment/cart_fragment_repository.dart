

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class CartFragmentRepository {

  final Dio dio = Dio();

  Future<Response> loadCart(id) async {
    final response = await dio.get(BASE_URL + "/cart/",
        queryParameters: {
      "id":id
        },
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }


}