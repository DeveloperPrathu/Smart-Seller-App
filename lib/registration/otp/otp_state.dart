abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifying extends OtpState {}

class OtpVerified extends OtpState {
  String token;

  OtpVerified(this.token);
}

class OtpVerificationFailed extends OtpState {
  String message;

  OtpVerificationFailed(this.message);
}
