

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/viewall/viewall_repository.dart';
import 'package:my_smartstore/viewall/viewall_state.dart';

class ViewAllCubit extends Cubit<ViewAllState>{
  ViewAllCubit() : super(ViewAllInitial());

  ViewAllRepository _repository = ViewAllRepository();

  void viewall(id){
    emit(ViewAllLoading());
    _repository.viewall(id).then((response) {
      emit(ViewAllLoaded(List.from(response.data['results'].map((e)=>ProductOptions.fromJson(e))), response.data['next']));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ViewAllFailed(error.response!.data));
        } catch (e) {
          emit(ViewAllFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ViewAllFailed("Please check your internet connection!"));
        } else {
          emit(ViewAllFailed(error.message));
        }
      }
    });
  }

  void loadMoreItems(){
    var oldstate = state as ViewAllLoaded;
    emit(ViewAllLoading());
    _repository.loadMore(nextUrl: oldstate.nextUrl!).then((response){
      oldstate.products.addAll(List.from(response.data['results'].map((e)=>ProductOptions.fromJson(e))));
      emit(ViewAllLoaded(oldstate.products, response.data['next']));

    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ViewAllFailed(error.response!.data));
        } catch (e) {
          emit(ViewAllFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ViewAllFailed("Please check your internet connection!"));
        } else {
          emit(ViewAllFailed(error.message));
        }
      }
    });
  }

}