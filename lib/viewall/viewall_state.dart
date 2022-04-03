


import '../models/page_item_model.dart';

abstract class ViewAllState {}

class ViewAllInitial extends ViewAllState {}

class ViewAllLoading extends ViewAllState {}

class ViewAllLoaded extends ViewAllState {
  List<ProductOptions> products;
  String? nextUrl;

  ViewAllLoaded(this.products,this.nextUrl);
}

class ViewAllFailed extends ViewAllState {
  String message;

  ViewAllFailed(this.message);
}
