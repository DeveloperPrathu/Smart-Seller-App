import 'package:my_smartstore/models/cart_model.dart';


abstract class CartFragmentState {}

class CartInitial extends CartFragmentState {}

class CartLoading extends CartFragmentState {}

class CartLoaded extends CartFragmentState {
  List<CartModel> products;

  CartLoaded(this.products);
}

class CartFailed extends CartFragmentState {
  String message;

  CartFailed(this.message);
}
