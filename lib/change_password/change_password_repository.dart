import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class ChangePasswordRepository {
  final Dio dio = Dio();

  Future<Response> changePassword(oldPassword,newPassword) async {
    final response = await dio.post(BASE_URL + "/changepassword/",
        data: {
          "old_password": oldPassword,
          "new_password": newPassword,
        },
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }


}
