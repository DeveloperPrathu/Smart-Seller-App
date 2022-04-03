import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class NotificationsRepository {
  final Dio dio = Dio();

  Future<Response> notifications() async {
    final response = await dio.get(BASE_URL + "/notifications/",
      queryParameters: {'limit': PAGE_LIMIT},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token})
    );
    return response;
  }

  Future<Response> loadMore({required String nextUrl}) async {
    final response = await dio.get(nextUrl,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }
}
