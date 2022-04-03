

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class UpdateInfoRepository {

  final Dio dio = Dio();

  Future<Response> updateInfo(email,phone,fullname,password) async {
    final response = await dio.post(BASE_URL + "/updateinfo/",
        data: {
          "email":email,
          "phone":phone,
          "fullname":fullname,
          "password":password,
        },
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> updatePhoneOtp(phone,password) async {
    final response = await dio.post(BASE_URL + "/updatephone_otp/",
        data: {
          "phone":phone,
          "password":password,
        },
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }


}