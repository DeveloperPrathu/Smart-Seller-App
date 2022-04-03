abstract class UpdateInfoState {}

class UpdateInfoInitial extends UpdateInfoState {}

class UpdateInfoSubmitting extends UpdateInfoState {}

class UpdateInfoOtpRequested extends UpdateInfoState {}

class UpdateInfoSubmitted extends UpdateInfoState {}

class UpdateInfoFailed extends UpdateInfoState {
  String message;

  UpdateInfoFailed(this.message);
}
