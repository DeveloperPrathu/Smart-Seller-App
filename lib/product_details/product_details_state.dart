import '../models/product_details_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  ProductDetailsModel model;

  ProductDetailsLoaded(this.model);
}

class ProductDetailsFailed extends ProductDetailsState {
  String message;

  ProductDetailsFailed(this.message);
}
