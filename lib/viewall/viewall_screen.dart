import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/viewall/viewall_cubit.dart';
import 'package:my_smartstore/viewall/viewall_state.dart';

import '../../../constants.dart';
import '../../../registration/authentication/auth_cubit.dart';
import '../product_details/product_details_cubit.dart';
import '../product_details/product_details_screen.dart';

class ViewAllScreen extends StatelessWidget {
  List<ProductOptions>? products = [];

  String title,id;


  ViewAllScreen(this.title,this.id);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewAllCubit, ViewAllState>(
      listener: (context, state) {
        if (state is ViewAllFailed) {
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
        if(state is ViewAllInitial){
          BlocProvider.of<ViewAllCubit>(context).viewall(id);
        }
        if (state is ViewAllLoaded) {
          products!.clear();
          products!.addAll(state.products);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              if (index < products!.length) {
                ProductOptions product = products![index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider<ProductDetailsCubit>(
                          create: (_) => ProductDetailsCubit(product.id!),
                          child: ProductDetailsScreen(),
                        )));
                  },
                  leading: CachedNetworkImage(
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
                  ),
                );
              } else {
                if (state is ViewAllLoaded && state.nextUrl != null) {
                  BlocProvider.of<ViewAllCubit>(context).loadMoreItems();
                }
                return Center(child: CircularProgressIndicator());
              }
            },
            itemCount: state is ViewAllLoading ||
                (state is ViewAllLoaded && state.nextUrl != null)
                ? products!.length + 1
                : products!.length,
          ),
        );
      },
    );
  }
}
