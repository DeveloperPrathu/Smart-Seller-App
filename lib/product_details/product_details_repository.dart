

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

class ProductDetailsRepository {

  final Dio dio = Dio();

  Future<Response> loadDetails(productId) async {
    final response = await dio.get(BASE_URL + "/productdetails/",
        queryParameters: {
          'productId':productId,
        });
    return response;
  }

}
