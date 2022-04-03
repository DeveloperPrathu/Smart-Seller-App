

import 'package:my_smartstore/models/orders_item_model.dart';

import '../models/page_item_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  List<ProductOptions> products;
  String? nextUrl;

  SearchLoaded(this.products,this.nextUrl);
}

class SearchFailed extends SearchState {
  String message;

  SearchFailed(this.message);
}
