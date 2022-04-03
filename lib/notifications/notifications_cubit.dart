

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/notification_model.dart';

import 'notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState>{
  NotificationsCubit() : super(NotificationsInitial());

  NotificationsRepository _repository = NotificationsRepository();

  void notifications(){
    emit(NotificationsLoading());
    _repository.notifications().then((response) {
      emit(NotificationsLoaded(List.from(response.data['results'].map((e)=>NotificationModel.fromJson(e))), response.data['next']));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(NotificationsFailed(error.response!.data));
        } catch (e) {
          emit(NotificationsFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(NotificationsFailed("Please check your internet connection!"));
        } else {
          emit(NotificationsFailed(error.message));
        }
      }
    });
  }

  void loadMoreItems(){
    var oldstate = state as NotificationsLoaded;
    emit(NotificationsLoading());
    _repository.loadMore(nextUrl: oldstate.nextUrl!).then((response){
      oldstate.notifications.addAll(List.from(response.data['results'].map((e)=>NotificationModel.fromJson(e))));
      emit(NotificationsLoaded(oldstate.notifications, response.data['next']));

    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(NotificationsFailed(error.response!.data));
        } catch (e) {
          emit(NotificationsFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(NotificationsFailed("Please check your internet connection!"));
        } else {
          emit(NotificationsFailed(error.message));
        }
      }
    });
  }

}