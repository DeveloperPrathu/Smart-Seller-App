

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/search/search_repository.dart';
import 'package:my_smartstore/search/search_state.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit() : super(SearchInitial());

  SearchRepository _repository = SearchRepository();

  void search(query){
    emit(SearchLoading());
    _repository.search(query).then((response) {
     emit(SearchLoaded(List.from(response.data['results'].map((e)=>ProductOptions.fromJson(e))), response.data['next']));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(SearchFailed(error.response!.data));
        } catch (e) {
          emit(SearchFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(SearchFailed("Please check your internet connection!"));
        } else {
          emit(SearchFailed(error.message));
        }
      }
    });
  }

  void loadMoreItems(){
    var oldstate = state as SearchLoaded;
    emit(SearchLoading());
    _repository.loadMore(nextUrl: oldstate.nextUrl!).then((response){
      oldstate.products.addAll(List.from(response.data['results'].map((e)=>ProductOptions.fromJson(e))));
      emit(SearchLoaded(oldstate.products, response.data['next']));

    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(SearchFailed(error.response!.data));
        } catch (e) {
          emit(SearchFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(SearchFailed("Please check your internet connection!"));
        } else {
          emit(SearchFailed(error.message));
        }
      }
    });
  }

}