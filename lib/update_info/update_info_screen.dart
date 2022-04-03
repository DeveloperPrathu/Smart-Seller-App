import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/user_model.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';
import 'package:my_smartstore/update_info/update_info_cubit.dart';
import 'package:my_smartstore/update_info/update_info_state.dart';

import '../constants.dart';
import '../registration/authentication/auth_cubit.dart';
import '../registration/otp/otp_cubit.dart';
import '../registration/otp/otp_screen.dart';

class UpdateInfoScreen extends StatelessWidget {
  final formkey = GlobalKey<FormState>();

  late String _email;
  late String _phone;
  late String _name;
  late String _password;

  UserModel userModel;

  UpdateInfoScreen(this.userModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Info'),
      ),
      body: BlocConsumer<UpdateInfoCubit, UpdateInfoState>(
        listener: (context, state) {
          if (state is UpdateInfoFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));

            if (state.message == UNAUTHENTICATED_USER) {
              context.read<AuthCubit>().removeToken();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          }

          if (state is UpdateInfoOtpRequested) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => BlocProvider<OtpCubit>(
                        create: (_) => OtpCubit(),
                        child: OtpScreen(
                          _email,
                          _phone,
                          _name,
                          _password,
                          onlyVerify: true,
                        ))))
                .then((verified) {
              if (verified == true) {
                BlocProvider.of<UpdateInfoCubit>(context)
                    .updateInfo(_email, _phone, _name, _password);
              }
            });
          }

          if (state is UpdateInfoSubmitted) {
            userModel.email = _email;
            userModel.phone = _phone;
            userModel.fullname = _name;
            context.read<AuthCubit>().emit(Authenticated(userModel));
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
              child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 28,
                  ),
                  Text(
                    'Update Info',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  _emailField(
                      !(state is UpdateInfoSubmitting),
                      state is UpdateInfoFailed
                          ? state.message == 'email already exists'
                              ? state.message
                              : null
                          : null),
                  SizedBox(
                    height: 24,
                  ),
                  _phoneField(
                      !(state is UpdateInfoSubmitting),
                      state is UpdateInfoFailed
                          ? state.message == 'phone already exists'
                              ? state.message
                              : null
                          : null),
                  SizedBox(
                    height: 24,
                  ),
                  _nameField(!(state is UpdateInfoSubmitting)),
                  SizedBox(
                    height: 24,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Text(
                    "Password is mandatory to update info",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  _passwordField(!(state is UpdateInfoSubmitting), state is UpdateInfoFailed
                      ? state.message == "incorrect_password"
                      ? "Incorrect password!"
                      : null
                      : null),
                  SizedBox(
                    height: 28,
                  ),
                  if (state is UpdateInfoSubmitting)
                    CircularProgressIndicator(),
                  SizedBox(
                    height: 28,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          fixedSize: MaterialStateProperty.all(
                              Size(double.maxFinite, 50))),
                      onPressed: (state is UpdateInfoSubmitting)
                          ? null
                          : () {
                              if (formkey.currentState!.validate()) {
                                if (_phone == userModel.phone) {
                                  BlocProvider.of<UpdateInfoCubit>(context)
                                      .updateInfo(
                                          _email, _phone, _name, _password);
                                } else {
//                                  request otp
                                  BlocProvider.of<UpdateInfoCubit>(context)
                                      .updatePhoneOtp(_phone, _password);
                                }
//
                              }
                            },
                      child: Text('Update')),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget _emailField(enableForm, error) {
    return TextFormField(
      initialValue: userModel.email,
      enabled: enableForm,
      validator: (value) {
        if (!RegExp(EMAIL_REGEX).hasMatch(value!)) {
          return "Please enter a valid Email Address!";
        }
        _email = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your Email Address",
          labelText: "Email Address",
          suffixIcon: const Icon(Icons.email)),
    );
  }

  Widget _phoneField(enableForm, error) {
    return TextFormField(
      maxLength: 10,
      initialValue: userModel.phone,
      enabled: enableForm,
      validator: (value) {
        if (value!.length != 10) {
          return "Please enter a valid Phone number!";
        }
        _phone = value;
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
          hintText: "Enter your Phone no.",
          labelText: "Phone",
          suffixIcon: const Icon(Icons.smartphone)),
    );
  }

  Widget _nameField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      initialValue: userModel.fullname,
      validator: (value) {
        if (value!.length <= 1) {
          return "Please enter a valid name!";
        }
        _name = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Enter your Name",
          labelText: "Fullname",
          suffixIcon: const Icon(Icons.person)),
    );
  }

  Widget _passwordField(enableForm,error) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length < 8) {
          return "Incorrect Password!";
        }
        _password = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText: error,
          errorStyle: TextStyle(height: 1),
          hintText: "Password",
          labelText: "Password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }
}
