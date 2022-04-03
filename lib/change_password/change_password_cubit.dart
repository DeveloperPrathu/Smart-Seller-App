import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/change_password/change_password_repository.dart';
import 'package:my_smartstore/change_password/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState>{
  ChangePasswordCubit() : super(ChangePasswordInitial());

  ChangePasswordRepository _repository = ChangePasswordRepository();

  void changePassword(oldPassword,newPassword){
    emit(ChangePasswordUpdating());
    _repository.changePassword(oldPassword, newPassword)
    .then((response){
      emit(ChangePasswordUpdated());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ChangePasswordFailed(error.response!.data));
        } catch (e) {
          emit(ChangePasswordFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ChangePasswordFailed("Please check your internet connection!"));
        } else {
          emit(ChangePasswordFailed(error.message));
        }
      }
    });
  }



}