import '../../models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  final UserModel userdata;

  Authenticated(this.userdata);
}

class AuthenticationFailed extends AuthState {
  String message;

  AuthenticationFailed(this.message);
}

class LoggedOut extends AuthState {}
