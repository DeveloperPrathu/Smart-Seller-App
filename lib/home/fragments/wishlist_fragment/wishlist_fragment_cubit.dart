import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment_repository.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment_state.dart';
import 'package:my_smartstore/models/page_item_model.dart';

class WishlistFragmentCubit extends Cubit<WishlistFragmentState>{
  WishlistFragmentCubit() : super(WishlistInitial());

  WishlistFragmentRepository _repository = WishlistFragmentRepository();

  void loadWishlist(){
    emit(WishlistLoading());
    _repository.loadWishlist()
    .then((response){
      emit(WishlistLoaded(List.from(response.data.map((json)=>ProductOptions.fromJson(json)))));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(WishlistFailed(error.response!.data));
        } catch (e) {
          emit(WishlistFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(WishlistFailed("Please check your internet connection!"));
        } else {
          emit(WishlistFailed(error.message));
        }
      }
    });
  }

  void removeItem(id){
    WishlistLoaded oldstate = state as WishlistLoaded;

    oldstate.products.removeWhere((element) => element.id==id);
    emit(WishlistLoaded(oldstate.products));

  }

}