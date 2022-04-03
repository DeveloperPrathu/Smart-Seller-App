

import 'dart:io';

import 'package:dio/dio.dart';

import '../../constants.dart';
import 'auth_cubit.dart';

class AuthRepository {

  final Dio dio = Dio();

  Future<Response> getUserData({required String token}) async {
    final response = await dio.get(BASE_URL+"/userdata/",options: Options(headers: {HttpHeaders.authorizationHeader:token}));
    return response;
  }

  Future<Response> updateWishlist({required String id,required String action}) async {
    final response = await dio.get(BASE_URL+"/updatewishlist/",
        queryParameters: {
      "id":id,
          "action":action,
        },
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> updateCart({required String id,required String action}) async {
    final response = await dio.get(BASE_URL+"/updatecart/",
        queryParameters: {
          "id":id,
          "action":action,
        },
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> logout(logoutAll) async {
    final response = await dio.get(BASE_URL+"/logout/",
        queryParameters: {
          "logout_all":logoutAll,
        },
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

}