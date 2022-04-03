import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_smartstore/order_details/order_details_cubit.dart';
import 'package:my_smartstore/order_details/order_details_state.dart';

import '../constants.dart';

class OrderDetailsScreen extends StatelessWidget {
  bool statusActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order details'),
      ),
      body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OrderDetailsInitial) {
            BlocProvider.of<OrderDetailsCubit>(context).loadDetails();
          }
          if (state is OrderDetailsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(state.orderDetailsModel.createdAt!)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Order# ${state.orderDetailsModel.id}'),
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: DOMAIN_URL + state.orderDetailsModel.image!,
                          height: 120,
                          width: 120,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.warning),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                          state.orderDetailsModel.title!,
                          style: TextStyle(fontSize: 20),
                        ))
                      ],
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text("Quantity " +
                            state.orderDetailsModel.quantity.toString())),
                    Divider(),
                    Text(
                      'Order Status',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (state.orderDetailsModel.status == 'CANCELLED')
                      Text('CANCELLED',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    if (state.orderDetailsModel.status != 'CANCELLED')
                      Stepper(
                          physics: ClampingScrollPhysics(),
                          currentStep: currentActiveStepIndex(
                              state.orderDetailsModel.status!),
                          controlsBuilder:
                              (BuildContext context, ControlsDetails details) {
                            return Row();
                          },
                          steps: [
                            Step(
                                isActive: isStatusActive(
                                    state.orderDetailsModel.status, 'ORDERED'),
                                title: Text('ORDERED'),
                                content:
                                    Text('Your product has been ordered.')),
                            Step(
                                isActive: isStatusActive(
                                    state.orderDetailsModel.status, 'PACKED'),
                                title: Text('PACKED'),
                                content: Text(
                                    'Your order has been packed and ready to be shipped.')),
                            Step(
                                isActive: isStatusActive(
                                    state.orderDetailsModel.status, 'SHIPPED'),
                                title: Text('SHIPPED'),
                                content: Text('Your order has been shipped.')),
                            Step(
                                isActive: isStatusActive(
                                    state.orderDetailsModel.status,
                                    'OUT_FOR_DELIVERY'),
                                title: Text('OUT FOR DELIVERY'),
                                content: Text(
                                    'Your order has been arrived at local courier facility and it is out for delivery.')),
                            Step(
                                isActive: isStatusActive(
                                    state.orderDetailsModel.status,
                                    'DELIVERED'),
                                title: Text('DELIVERED'),
                                content: Text(
                                    'Your order has been delivered successfully.')),
                          ]),
                    if (state.orderDetailsModel.status == 'DELIVERED') ...[
                      Text(
                        'Rating',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      RatingBar.builder(
                        initialRating:
                            state.orderDetailsModel.rating!.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          BlocProvider.of<OrderDetailsCubit>(context)
                              .updateRating(rating.toInt());
                        },
                      ),
                    ],
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 8)
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipping Address',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            state.orderDetailsModel.address!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Cart Total',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text('Items total'),
                              Spacer(),
                              Text('Rs.${state.orderDetailsModel.productPrice}')
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text('Delivery charge'),
                              Spacer(),
                              Text('Rs.${state.orderDetailsModel.deliveryPrice}')
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text('Rs.${state.orderDetailsModel.txPrice}',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),

                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text('Tx ID'),
                        Spacer(),
                        Text(state.orderDetailsModel.txId!)
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text('Tx Status'),
                        Spacer(),
                        Text(state.orderDetailsModel.txStatus!)
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text('Payment Mode'),
                        Spacer(),
                        Text(state.orderDetailsModel.paymentMode!)
                      ],
                    ),

                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  isStatusActive(status, constValue) {
    if (statusActive == false) {
      return false;
    }
    if (status == constValue) {
      statusActive = false;
    }
    return true;
  }

  currentActiveStepIndex(currentStatus) {
    int currentStep = 0;
    var statuses = [
      'ORDERED',
      'PACKED',
      'SHIPPED',
      'OUT_FOR_DELIVERY',
      'DELIVERED',
      'CANCELLED',
    ];
    for (var element in statuses) {
      if (currentStatus == element) {
        break;
      }
      currentStep++;
    }
    return currentStep;
  }
}
