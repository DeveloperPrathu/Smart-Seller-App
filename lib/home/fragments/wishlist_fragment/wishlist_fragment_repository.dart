

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

import '../../../registration/authentication/auth_cubit.dart';

class WishlistFragmentRepository {

  final Dio dio = Dio();

  Future<Response> loadWishlist() async {
    final response = await dio.get(BASE_URL + "/wishlist/",
        options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }


}