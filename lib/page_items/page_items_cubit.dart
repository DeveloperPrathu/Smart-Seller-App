import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/page_items/page_items_repository.dart';
import 'package:my_smartstore/page_items/page_items_state.dart';

class PageItemsCubit extends Cubit<PageItemsState>{
  PageItemsCubit() : super(PageItemsInitial());

  PageItemsRepository _repository = PageItemsRepository();

  void loadItems(categoryId){
    emit(PageItemsLoading());
    _repository.loadItems(categoryId).then((response){
      emit(PageItemsLoaded(PageItemModel.fromJson(response.data)));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(PageItemsFailed(error.response!.data));
        } catch (e) {
          emit(PageItemsFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(PageItemsFailed("Please check your internet connection!"));
        } else {
          emit(PageItemsFailed(error.message));
        }
      }
    });
  }


  void loadMoreItems(){
    var oldstate = state as PageItemsLoaded;
    emit(PageItemsLoading());
    _repository.loadMoreItems(nextUrl: oldstate.pageItemModel.next).then((response){
      PageItemModel newData = PageItemModel.fromJson(response.data);
      oldstate.pageItemModel.results?.addAll(newData.results!);
      newData.results = oldstate.pageItemModel.results!;
      emit(PageItemsLoaded(newData));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(PageItemsFailed(error.response!.data));
        } catch (e) {
          emit(PageItemsFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(PageItemsFailed("Please check your internet connection!"));
        } else {
          emit(PageItemsFailed(error.message));
        }
      }
    });
  }

}