import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/address/address_cubit.dart';
import 'package:my_smartstore/address/address_screen.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';

import '../../../models/cart_model.dart';
import 'cart_fragment_cubit.dart';
import 'cart_fragment_state.dart';

class CartFragment extends StatefulWidget {
  String? productId;
  bool showAppbar = false;

  CartFragment(this.productId,this.showAppbar);

  @override
  State<CartFragment> createState() => _CartFragmentState();
}

class _CartFragmentState extends State<CartFragment> {
  @override
  Widget build(BuildContext context) {
    AuthState authState = BlocProvider
        .of<AuthCubit>(context)
        .state;

    return Scaffold(
      appBar:widget.showAppbar
          ? AppBar(
        title: Text('My Cart'),
      )
          : null,
      body: BlocConsumer<CartFragmentCubit, CartFragmentState>(
        listener: (context, state) {
          if (state is CartFailed) {
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
          if (state is CartInitial) {
            context.read<CartFragmentCubit>().loadCart(widget.productId);
          }
          if (state is CartLoaded) {
            int items_amt = 0;
            int delivery_amt = 0;
            int total_amt = 0;

            state.products.forEach((element) {
              if (element.quantity! > 0) {
                items_amt =
                    items_amt + (element.offerPrice! * element.selected_qty);
                delivery_amt = delivery_amt + element.deliveryCharge!;
              }
            });

            total_amt = items_amt + delivery_amt;

            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                if (index == state.products.length) {
//                total amount widget
                  return Container(
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
                            Text('Rs.$items_amt')
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text('Delivery charge'),
                            Spacer(),
                            Text('Rs.$delivery_amt')
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
                            Text('Rs.$total_amt',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                elevation: MaterialStateProperty.all(0),
                                fixedSize: MaterialStateProperty.all(
                                    Size(double.maxFinite, 50))),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      BlocProvider.value(
                                        value: BlocProvider.of<CartFragmentCubit>(context),
                                        child: BlocProvider(
                                          create: (_) => AddressCubit(),
                                          child: AddressScreen(widget.productId==null,total_amt),),
                                      )));
                            },
                            child: Text('Continue'))
                      ],
                    ),
                  );
                }
                CartModel product = state.products[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: DOMAIN_URL + product.image!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Icon(Icons.warning),
                  ),
                  title: Text(product.title!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.cod!)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green.shade800,
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          label: const Text('Cash on delivery'),
                        ),
                      if (product.quantity! > 0)
                        Row(
                          children: [
                            Text(
                              "Rs." + product.offerPrice.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Rs." + product.price.toString(),
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      if (product.quantity! <= 0)
                        Text(
                          'Out of Stock',
                          style: TextStyle(color: Colors.red),
                        ),
                      Text(
                        "Rs." +
                            product.deliveryCharge.toString() +
                            " Delivery charge",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      if (widget.productId == null)
                        TextButton(
                          onPressed: () {
                            if (authState is Authenticated) {
                              BlocProvider.of<AuthCubit>(context)
                                  .updateCart(
                                  product.id!,
                                  authState.userdata.cart!
                                      .contains(product.id!)
                                      ? REMOVE
                                      : ADD)
                                  .then((value) {
                                if (value == SUCCESS) {
                                  BlocProvider.of<CartFragmentCubit>(context)
                                      .removeItem(product.id!);
                                } else if (value == FAILED) {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }
                              });
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                  trailing: product.quantity! <= 0
                      ? null
                      : Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.remove),
                          onPressed: product.selected_qty == 1
                              ? null
                              : () {
                            if (product.selected_qty > 1) {
                              product.selected_qty--;
                            }
                            setState(() {});
                          },
                        ),
                        Text(product.selected_qty.toString()),
                        IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.add),
                            onPressed:
                            product.selected_qty == product.quantity
                                ? null
                                : () {
                              if (product.selected_qty <
                                  product.quantity!) {
                                product.selected_qty++;
                              }
                              setState(() {});
                            })
                      ],
                    ),
                  ),
                );
              },
              itemCount: total_amt == 0
                  ? state.products.length
                  : state.products.length + 1,
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
