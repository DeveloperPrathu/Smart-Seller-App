


abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordUpdating extends ChangePasswordState {}

class ChangePasswordUpdated extends ChangePasswordState {

}

class ChangePasswordFailed extends ChangePasswordState {
  String message;

  ChangePasswordFailed(this.message);
}


