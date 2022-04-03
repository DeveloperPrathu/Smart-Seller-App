

import 'package:my_smartstore/models/orders_item_model.dart';

abstract class OrdersFragmentState {}

class OrdersInitial extends OrdersFragmentState {}

class OrdersLoading extends OrdersFragmentState {}

class OrdersLoaded extends OrdersFragmentState {
OrdersItemModel ordersItemModel;

OrdersLoaded(this.ordersItemModel);
}

class OrdersFailed extends OrdersFragmentState {
  String message;

  OrdersFailed(this.message);
}
