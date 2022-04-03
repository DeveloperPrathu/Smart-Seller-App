

import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

class PageItemsRepository {

  final Dio dio = Dio();

  Future<Response> loadItems(categoryId) async {
    final response = await dio.get(BASE_URL + "/pageitems/",
    queryParameters: {
      'category':categoryId,
      'limit':PAGE_LIMIT
    });
    return response;
  }

  Future<Response> loadMoreItems({required String nextUrl}) async {
    final response = await dio.get(nextUrl);
    return response;
  }
}
