


import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../registration/authentication/auth_cubit.dart';

class OrderDetailsRepository {

  final Dio dio = Dio();

  Future<Response> loadDetails(orderId) async {
    final response = await dio.get(BASE_URL + "/orderdetails/",
        queryParameters: {
          'id':orderId,
        },
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> updateRating(orderId,rating) async {
    final response = await dio.get(BASE_URL + "/updaterating/",
        queryParameters: {
          'id':orderId,
          'rating':rating,
        },
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

}
