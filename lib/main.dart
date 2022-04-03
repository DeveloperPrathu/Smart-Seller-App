import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_smartstore/MyWidgets/cart_icon_btn.dart';
import 'package:my_smartstore/MyWidgets/notification_icon_btn.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment_cubit.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment_cubit.dart';
import 'package:my_smartstore/home/home_screen.dart';
import 'package:my_smartstore/page_items/page_items_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_repository.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';
import 'package:my_smartstore/registration/authentication/authenticating_screen.dart';
import 'package:my_smartstore/registration/sign_up/signup_cubit.dart';
import 'package:my_smartstore/registration/sign_up/signup_screen.dart';
import 'package:my_smartstore/utils.dart';

final AuthRepository authRepository = AuthRepository();
final storage = FlutterSecureStorage();
final AuthCubit authCubit =
    AuthCubit(storage: storage, authRepository: authRepository);
final NotificationCountCubit notificationCountCubit = NotificationCountCubit(0);


//  background listening
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on recieve');
  String? value = await storage.read(key: "notificationCount");
  if(value != null){
    value = (int.parse(value)+1).toString();
  }else{
    value = "1";
  }
  await storage.write(key: "notificationCount", value: value);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (authCubit.state is AuthInitial) {
    await authCubit.authenticate();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
          String? value = await storage.read(key: "notificationCount");
          await storage.write(key: "notificationCount", value: "0");
          if(value != null){
            if(int.parse(value) != 0) {
              notificationCountCubit.setCount(notificationCountCubit.state + int.parse(value));
            }
          }

    }));

//    recieves msg when app is closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('new message');
      }
    });

//  foreground listening
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationCountCubit.setCount(notificationCountCubit.state + 1);
      }
    });

//    when app is opened in background and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print("on tapped");
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authCubit),
        BlocProvider(create: (_) => CartCountCubit(0)),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            context
                .read<CartCountCubit>()
                .setCount(state.userdata.cart!.length);
            notificationCountCubit.setCount(state.userdata.notifications!);
          }

          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: PRIMARY_SWATCH,
            ),
            home: state is Authenticated
                ? MultiBlocProvider(providers: [
                    BlocProvider(create: (_) => notificationCountCubit),
                    BlocProvider(create: (_) => HomeFragmentCubit()),
                    BlocProvider(create: (_) => PageItemsCubit()),
                  ], child: HomeScreen())
                : state is AuthenticationFailed || state is Authenticating
                    ? AuthenticatingScreen(state is AuthenticationFailed
                        ? state.message
                        : "Authenticating...")
                    : BlocProvider<SignUpCubit>(
                        create: (_) => SignUpCubit(), child: SignUpScreen()),
          );
        },
      ),
    );
  }
}
