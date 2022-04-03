

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/registration/sign_up/signup_repository.dart';
import 'package:my_smartstore/registration/sign_up/signup_state.dart';

class SignUpCubit extends Cubit<SignUpState>{
  SignUpCubit() : super(SignUpInitial());

  final SignUpRepository _repository = SignUpRepository();


  void requestOtp(email,phone){
    emit(SignUpSubmitting());
    _repository.requestOtp(email, phone).then((response) => emit(SignUpSuccess()))
    .catchError((value){
      DioError error = value;
      if(error.response != null){
        emit(SignUpFailed(error.response!.data));
      }else{
        if(error.type == DioErrorType.other){
          emit(SignUpFailed("Please check your internet connection!"));
        }else{
          emit(SignUpFailed(error.message));
        }
      }
    });

  }

}