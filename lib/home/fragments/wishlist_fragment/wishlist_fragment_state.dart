import '../../../models/page_item_model.dart';

abstract class WishlistFragmentState {}

class WishlistInitial extends WishlistFragmentState {}

class WishlistLoading extends WishlistFragmentState {}

class WishlistLoaded extends WishlistFragmentState {
  List<ProductOptions> products;

  WishlistLoaded(this.products);
}

class WishlistFailed extends WishlistFragmentState {
  String message;

  WishlistFailed(this.message);
}
