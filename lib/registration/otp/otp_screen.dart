import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../authentication/auth_cubit.dart';
import 'otp_cubit.dart';
import 'otp_state.dart';

class OtpScreen extends StatefulWidget {
  final formkey = GlobalKey<FormState>();

  final String _email, _phone, _name, _password;
  late String _otp;
  late bool onlyVerify;

  var timer;
  int time = 0;

  OtpScreen(this._email, this._phone, this._name, this._password,
      {this.onlyVerify = false});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key : widget.formkey,
              child: BlocConsumer<OtpCubit, OtpState>(
                  listener: (context, state) {

                    if(state is OtpVerificationFailed){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(state.message),backgroundColor: Colors.red,));
                    }

                    if(state is OtpVerified){
                      if(widget.onlyVerify){
                        Navigator.pop(context,true);
                      }else{
                        BlocProvider.of<AuthCubit>(context).loggedIn(state.token);
                        Navigator.pop(context);
                      }
                    }

                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Image.asset(
                          "assets/images/otp.png",
                          height: 100,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Phone Verification",
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                            'A verification code has been successfully sent to your Phone no.'),
                        SizedBox(
                          height: 48,
                        ),
                        _otpField(!(state is OtpVerifying), state is OtpVerificationFailed?state.message:null),
                        SizedBox(
                          height: 24,
                        ),
                        TextButton(
                          child: Text(widget.time !=0? "Wait for ${widget.time} seconds to resend" :'Resend'),
                          onPressed: widget.time !=0?null: () {
                            BlocProvider.of<OtpCubit>(context).resendOtp(phone: widget._phone);
                            startTimer();
                    },
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        if(state is OtpVerifying)
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 48,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                elevation: MaterialStateProperty.all(0),
                                fixedSize: MaterialStateProperty.all(
                                    Size(double.maxFinite, 50))),
                            onPressed: state is OtpVerifying?null:() {
                              if(widget.formkey.currentState!.validate()){
                                if(widget.onlyVerify){
                                  BlocProvider.of<OtpCubit>(context).verifyUpdateOtp(phone:widget._phone,otp: widget._otp);

                                }else{
                                  BlocProvider.of<OtpCubit>(context).verifyOtp(email: widget._email,phone:widget._phone,name:widget._name,password:widget._password,otp: widget._otp);

                                }
                              }
                            },
                            child: Text('Verify')),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpField(enableForm, error) {
    return TextFormField(
      maxLength: 6,
      enabled: enableForm,
      validator: (value) {
        if (value!.length != 6) {
          return "Invalid Otp!";
        }
        widget._otp = value;
      },
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter 6 digit verification code",
          labelText: "Verification Otp",
          suffixIcon: const Icon(Icons.sms)),
    );
  }

  void startTimer(){
    widget.time =60;
    const oneSec = const Duration(seconds: 1);
    widget.timer = Timer.periodic(oneSec, (timer) {
      if(widget.time == 0){
        timer.cancel();
      }else{
        setState(() {
          widget.time = widget.time-1;
        });
      }
    });
  }
}
