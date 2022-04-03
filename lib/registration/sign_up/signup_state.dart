abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpSubmitting extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailed extends SignUpState {

  String message;

  SignUpFailed(this.message);
}
