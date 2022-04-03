


abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressUpdating extends AddressState {}

class AddressUpdated extends AddressState {
  String name,address,contact_no,district,state;
  int pincode;

  AddressUpdated(this.name, this.address, this.contact_no, this.district,
      this.state, this.pincode);
}

class AddressFailed extends AddressState {
  String message;

  AddressFailed(this.message);
}

class InitiatingPayment extends AddressState {}
class PaymentInitiated extends AddressState {
  String token,currency,orderId,tx_amount,appId;

  PaymentInitiated(
      this.token, this.currency, this.orderId, this.tx_amount, this.appId);
}

class ProcessingPayment extends AddressState {}

class PaymentProcessed extends AddressState {}

class PaymentFailed extends AddressState {
  String message;

  PaymentFailed(this.message);
}

