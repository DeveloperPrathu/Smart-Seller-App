


import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constants.dart';

class OtpRepository {
  final Dio dio = Dio();

  Future<Response> verifyOtp(phone,otp) async {
    final response = await dio.post(BASE_URL + "/verify_otp/",data:{
      'otp':otp,
      'phone':phone,
    });
    return response;
  }

  Future<Response> createAccount({required String email,required String phone,required String name,required String password}) async {
    final String? fcmtoken = await FirebaseMessaging.instance.getToken();

    final response = await dio.post(BASE_URL + "/create_account/",data:{
      'email':email,
      'phone':phone,
      'fullname':name,
      'password':password,
      'fcmtoken':fcmtoken,
    });
    return response;
  }


  void resendOtp(phone){
    dio.post(BASE_URL + "/resend_otp/",data:{
      'phone':phone,
    });
  }
}