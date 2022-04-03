
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/registration/forgot_password/forgot_password_repository.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState>{
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  ForgotPasswordRepository _repository = ForgotPasswordRepository();

  void resetPassword(email){
    emit(ForgotPasswordSubmitting());
    _repository.reset_password(email)
    .then((response){
      emit(ForgotPasswordSuccess());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ForgotPasswordFailed(error.response!.data));
        } catch (e) {
          emit(ForgotPasswordFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ForgotPasswordFailed("Please check your internet connection!"));
        } else {
          emit(ForgotPasswordFailed(error.message));
        }
      }
    });
  }

}