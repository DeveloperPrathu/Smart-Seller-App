import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class ViewAllRepository {
  final Dio dio = Dio();

  Future<Response> viewall(id) async {
    final response = await dio.get(BASE_URL + "/viewall/",
        queryParameters: {'id': id, 'limit': PAGE_LIMIT},
       );
    return response;
  }

  Future<Response> loadMore({required String nextUrl}) async {
    final response = await dio.get(nextUrl);
    return response;
  }
}
