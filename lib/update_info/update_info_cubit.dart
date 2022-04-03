import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/update_info/update_info_repository.dart';
import 'package:my_smartstore/update_info/update_info_state.dart';

class UpdateInfoCubit extends Cubit<UpdateInfoState>{
  UpdateInfoCubit() : super(UpdateInfoInitial());

  UpdateInfoRepository _repository = UpdateInfoRepository();

  void updateInfo(email,phone,fullname,password){
    emit(UpdateInfoSubmitting());
    _repository.updateInfo(email, phone, fullname, password).then((value) {
      emit(UpdateInfoSubmitted());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(UpdateInfoFailed(error.response!.data));
        } catch (e) {
          emit(UpdateInfoFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(UpdateInfoFailed("Please check your internet connection!"));
        } else {
          emit(UpdateInfoFailed(error.message));
        }
      }
    });
  }

  void updatePhoneOtp(phone,password){
    emit(UpdateInfoSubmitting());
    _repository.updatePhoneOtp(phone, password).then((value) {
      emit(UpdateInfoOtpRequested());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(UpdateInfoFailed(error.response!.data));
        } catch (e) {
          emit(UpdateInfoFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(UpdateInfoFailed("Please check your internet connection!"));
        } else {
          emit(UpdateInfoFailed(error.message));
        }
      }
    });
  }

}