import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment_cubit.dart';
import 'package:my_smartstore/home/fragments/wishlist_fragment/wishlist_fragment_state.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';

import '../../../product_details/product_details_cubit.dart';
import '../../../product_details/product_details_screen.dart';

class WishlistFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;

    return BlocConsumer<WishlistFragmentCubit, WishlistFragmentState>(
      listener: (context, state) {
        if (state is WishlistFailed) {
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
        if (state is WishlistInitial) {
          context.read<WishlistFragmentCubit>().loadWishlist();
        }
        if (state is WishlistLoaded) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(thickness: 1,);
            },
            itemBuilder: (context, index) {
              ProductOptions product = state.products[index];

              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider<ProductDetailsCubit>(
                        create: (_) => ProductDetailsCubit(product.id!),
                        child: ProductDetailsScreen(),
                      )));
                },
                leading:  CachedNetworkImage(
                  imageUrl: DOMAIN_URL + product.image!,
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Icon(Icons.warning),
                ),
                title: Text(product.title!),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Rs."+product.offerPrice.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                      SizedBox(width: 8,),
                      Text("Rs."+product.price.toString(),style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12),),
                    ],
                  ),
                ),
                trailing: IconButton(
                  onPressed: (){
                    if (authState is Authenticated) {
                      BlocProvider.of<AuthCubit>(context)
                          .updateWishlist(
                          product.id!,
                          authState.userdata.wishlist!
                              .contains(
                              product.id!)
                              ? REMOVE
                              : ADD)
                          .then((value) {
                        if (value == SUCCESS) {
                         BlocProvider.of<WishlistFragmentCubit>(context).removeItem(product.id!);
                        } else if (value == FAILED) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      });
                    }
                  },
                  icon: Icon(Icons.remove_circle_outline,color: Colors.red,),
                ),
              );
            },
            itemCount: state.products.length,
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
