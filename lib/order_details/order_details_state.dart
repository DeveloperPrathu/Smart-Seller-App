import '../models/order_details_model.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  OrderDetailsModel orderDetailsModel ;

  OrderDetailsLoaded(this.orderDetailsModel);
}

class OrderDetailsFailed extends OrderDetailsState {
  String message;

  OrderDetailsFailed(this.message);
}
