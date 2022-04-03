import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment_cubit.dart';
import 'package:my_smartstore/home/fragments/orders_fragment/orders_fragment_state.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/order_details/order_details_cubit.dart';
import 'package:my_smartstore/order_details/order_details_screen.dart';
import 'package:my_smartstore/search/search_cubit.dart';
import 'package:my_smartstore/search/search_state.dart';

import '../../../constants.dart';
import '../../../models/orders_item_model.dart';
import '../../../registration/authentication/auth_cubit.dart';
import '../product_details/product_details_cubit.dart';
import '../product_details/product_details_screen.dart';

class SearchScreen extends StatelessWidget {
  List<ProductOptions>? products = [];

  String search = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchFailed) {
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
        if (state is SearchLoaded) {
          products!.clear();
          products!.addAll(state.products);
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: _searchField(context),
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
                if (state is SearchLoaded && state.nextUrl != null) {
                  BlocProvider.of<SearchCubit>(context).loadMoreItems();
                }
                return Center(child: CircularProgressIndicator());
              }
            },
            itemCount: state is SearchLoading ||
                    (state is SearchLoaded && state.nextUrl != null)
                ? products!.length + 1
                : products!.length,
          ),
        );
      },
    );
  }

  Widget _searchField(context) {
    return TextFormField(
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) {
        if(value.isNotEmpty && value.length >2){
          search = value;
          BlocProvider.of<SearchCubit>(context).search(value);
        }

      },
      initialValue: search,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search',
      ),
    );
  }
}
