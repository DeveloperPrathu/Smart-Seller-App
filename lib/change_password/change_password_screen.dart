import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/change_password/change_password_cubit.dart';
import 'package:my_smartstore/change_password/change_password_state.dart';

import '../constants.dart';
import '../registration/authentication/auth_cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  final formkey = GlobalKey<FormState>();

  late String _oldpassword,_password,_confirmpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'),),
      body: BlocConsumer<ChangePasswordCubit,ChangePasswordState>(
        listener: (context,state){
          if (state is ChangePasswordFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));

            if (state.message == UNAUTHENTICATED_USER) {
              context.read<AuthCubit>().removeToken();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          }

          if(state is ChangePasswordUpdated){
            context.read<AuthCubit>().removeToken();
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          return SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _oldpasswordField(!(state is ChangePasswordUpdating), state is ChangePasswordFailed
                        ? state.message == "incorrect_password"
                        ? "Incorrect password!"
                        : null
                        : null),
                    SizedBox(
                      height: 24,
                    ),
                    _passwordField(!(state is ChangePasswordUpdating)),
                    SizedBox(
                      height: 24,
                    ),
                    _confirmpasswordField(!(state is ChangePasswordUpdating)),
                    SizedBox(
                      height: 28,
                    ),
                    if (state is ChangePasswordUpdating)
                      CircularProgressIndicator(),
                    SizedBox(
                      height: 28,
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
                        onPressed: (state is ChangePasswordUpdating)
                            ? null
                            : () {
                          if (formkey.currentState!.validate()) {
                            BlocProvider.of<ChangePasswordCubit>(context)
                                .changePassword(_oldpassword, _confirmpassword);
                          }
                        },
                        child: Text('Change Password')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }



  Widget _oldpasswordField(enableForm,error) {
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
        _oldpassword = value;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorText:error,
          errorStyle: TextStyle(height: 1),
          hintText: "Old Password",
          labelText: "Old Password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }

  Widget _passwordField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      validator: (value) {
        if (value!.length < 8) {
          return "at least 8 characters";
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
          errorStyle: TextStyle(height: 1),
          hintText: "New Password",
          labelText: "New Password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }

  Widget _confirmpasswordField(enableForm) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      validator: (value) {
        if (value != _password) {
          return "Password mismatched!";
        }
        _confirmpassword = value!;
      },
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: ENABLED_BORDER,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          focusedBorder: FOCUSED_BORDER,
          errorBorder: ERROR_BORDER,
          focusedErrorBorder: FOCUSED_BORDER,
          errorStyle: TextStyle(height: 1),
          hintText: "Confirm New Password",
          labelText: "Confirm New Password",
          suffixIcon: const Icon(Icons.lock)),
    );
  }
}
