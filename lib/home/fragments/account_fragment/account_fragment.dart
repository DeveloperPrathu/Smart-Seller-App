import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/change_password/change_password_cubit.dart';
import 'package:my_smartstore/models/user_model.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';
import 'package:my_smartstore/update_info/update_info_screen.dart';

import '../../../change_password/change_password_screen.dart';
import '../../../update_info/update_info_cubit.dart';

class AccountFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = (BlocProvider.of<AuthCubit>(context).state as Authenticated).userdata;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email Address',style: TextStyle(color: Colors.blueGrey),),
            Text(userModel.email!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 16,),
            Text('Phone',style: TextStyle(color: Colors.blueGrey),),
            Text(userModel.phone!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 16,),
            Text('Fullname',style: TextStyle(color: Colors.blueGrey),),
            Text(userModel.fullname!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 16,),
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
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider<UpdateInfoCubit>(
                          create: (_) => UpdateInfoCubit(),
                          child:
                          UpdateInfoScreen(userModel))));

                },
                child: Text('Update info')),
            SizedBox(height: 16,),

            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    fixedSize: MaterialStateProperty.all(
                        Size(double.maxFinite, 50))),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider<ChangePasswordCubit>(
                          create: (_) => ChangePasswordCubit(),
                          child:
                          ChangePasswordScreen())));
                },
                child: Text('Change Password')),
            SizedBox(height: 16,),
            Divider(thickness: 1,),
            SizedBox(height: 16,),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    elevation: MaterialStateProperty.all(0),
                    fixedSize: MaterialStateProperty.all(
                        Size(double.maxFinite, 50))),
                onPressed: (){
                 _logout(context, false);
                },
                child: Text('Logout')),
            SizedBox(height: 16,),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                    elevation: MaterialStateProperty.all(0),
                    fixedSize: MaterialStateProperty.all(
                        Size(double.maxFinite, 50))),
                onPressed: (){
                  _logout(context, true);
                },
                child: Text('Logout All')),
          ],
        ),
      ),
    );
  }

  _logout(context,all){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(all?"Logout ALL":'Logout'),
        content: Text('Are you sure, do you want to logout${all?" from all devices":''}?'),
        actions: [
          TextButton(onPressed: (){
            BlocProvider.of<AuthCubit>(context).logout(all);
            Navigator.pop(context);
          }, child: Text("Logout")),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      );

    });
  }
}
