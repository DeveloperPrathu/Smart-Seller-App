import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment_cubit.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment_state.dart';
import 'package:my_smartstore/order_details/order_details_cubit.dart';
import 'package:my_smartstore/order_details/order_details_screen.dart';

import '../../../constants.dart';
import '../../../models/orders_item_model.dart';
import '../../../registration/authentication/auth_cubit.dart';

class OrdersFragment extends StatelessWidget {

  List<Results>? orderItems = [];


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersFragmentCubit, OrdersFragmentState>(
      listener: (context, state) {
        if (state is OrdersFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));

          if (state.message == UNAUTHENTICATED_USER) {
            context.read<AuthCubit>().removeToken();
          }
        }
      },
      builder: (context, state) {
        if (state is OrdersInitial) {
          BlocProvider.of<OrdersFragmentCubit>(context)
              .loadOrders();
        }

        if (state is OrdersLoaded) {
          orderItems!.clear();
          orderItems!.addAll(state.ordersItemModel.results!);
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            if (index < orderItems!.length) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                      BlocProvider(create: (_) => OrderDetailsCubit(orderItems![index].id!),
                        child: OrderDetailsScreen(),)));
                },
                leading: CachedNetworkImage(
                  imageUrl: DOMAIN_URL + orderItems![index].image!,
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Icon(Icons.warning),
                ),
                title: Text(orderItems![index].title!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Text("STATUS : " + orderItems![index].status!),
                    SizedBox(height: 8,),
                    Text(orderItems![index].createdAt!),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(orderItems![index].rating!.toString()),
                        Icon(Icons.star, color: Colors.amber, size: 18,)
                      ],
                    ),
                    SizedBox(height: 8,),

                  ],
                ),
                trailing: Text(
                    "QTY : " + orderItems![index].quantity!.toString()),

              );
            } else {
              if (state is OrdersLoaded && state.ordersItemModel.next != null) {
                BlocProvider.of<OrdersFragmentCubit>(context).loadMoreItems();
              }
              return Center(child: CircularProgressIndicator());
            }
          },
          itemCount: state is OrdersLoading ||
              (state is OrdersLoaded && state.ordersItemModel.next != null)
              ? orderItems!.length + 1
              : orderItems!.length,
        );
      },
    );
  }
}
