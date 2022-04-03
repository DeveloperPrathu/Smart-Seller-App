

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/registration/otp/otp_repository.dart';
import 'package:my_smartstore/registration/otp/otp_state.dart';

class OtpCubit extends Cubit<OtpState>{
  OtpCubit() : super(OtpInitial());

  OtpRepository _repository = OtpRepository();


  void verifyOtp({required String email,required String name,required String password,required String phone,required String otp}){

    emit(OtpVerifying());
    _repository.verifyOtp(phone, otp).then((response){
_createAccount(email, phone, name, password);
    }).catchError((value){
      DioError error = value;
      if(error.response != null){
        emit(OtpVerificationFailed(error.response!.data));
      }else{
        if(error.type == DioErrorType.other){
          emit(OtpVerificationFailed("Please check your internet connection!"));
        }else{
          emit(OtpVerificationFailed(error.message));
        }
      }
    });



  }

  void verifyUpdateOtp({required String phone,required String otp}){

    emit(OtpVerifying());
    _repository.verifyOtp(phone, otp).then((response){
      emit(OtpVerified(response.data));
    }).catchError((value){
      DioError error = value;
      if(error.response != null){
        emit(OtpVerificationFailed(error.response!.data));
      }else{
        if(error.type == DioErrorType.other){
          emit(OtpVerificationFailed("Please check your internet connection!"));
        }else{
          emit(OtpVerificationFailed(error.message));
        }
      }
    });



  }

  void _createAccount(email,phone,name,password){
    _repository.createAccount(email: email, phone: phone, name: name, password: password)
        .then((response){
          emit(OtpVerified(response.data));
    }).catchError((value){
      DioError error = value;
      if(error.response != null){
        emit(OtpVerificationFailed(error.response!.data));
      }else{
        if(error.type == DioErrorType.other){
          emit(OtpVerificationFailed("Please check your internet connection!"));
        }else{
          emit(OtpVerificationFailed(error.message));
        }
      }
    });
  }

  void resendOtp({required phone}){
    _repository.resendOtp(phone);
  }


}