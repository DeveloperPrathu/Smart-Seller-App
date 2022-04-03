import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class OrdersFragmentRepository {
  final Dio dio = Dio();

  Future<Response> loadOrders() async {
    final response = await dio.get(BASE_URL + "/orders/",
        queryParameters: {'limit': PAGE_LIMIT},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> loadMoreOrders({required String nextUrl}) async {
    final response = await dio.get(nextUrl,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }
}
