import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/models/page_item_model.dart';
import 'package:my_smartstore/product_details/product_details_cubit.dart';
import 'package:my_smartstore/product_details/product_details_screen.dart';

class ProductThumbnail extends StatelessWidget {
  ProductOptions product;
  double? width;

  ProductThumbnail(this.product, this.width);

  @override
  Widget build(BuildContext context) {
    if (width == null) {
      width = (MediaQuery.of(context).size.width / 2) - 50;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider<ProductDetailsCubit>(
                  create: (_) => ProductDetailsCubit(product.id!),
                  child: ProductDetailsScreen(),
                )));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: DOMAIN_URL + product.image!,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Icon(Icons.warning),
              ),
            ),
            Text(
              product.title!,
              style: TextStyle(fontSize: 14, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Rs." + product.offerPrice!.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (product.price != product.offerPrice)
              Text(
                "Rs." + product.price!.toString(),
                style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
