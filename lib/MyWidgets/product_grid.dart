import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/MyWidgets/product_thumbnail.dart';

import '../models/page_item_model.dart';
import '../viewall/viewall_cubit.dart';
import '../viewall/viewall_screen.dart';

class ProductGrid extends StatelessWidget {
 late  Results result;


  ProductGrid(this.result);

  @override
  Widget build(BuildContext context) {
    int productsCount = result.productOptions!.length;
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(result.title!,style: TextStyle(fontWeight: FontWeight.bold),),
              Spacer(),
              TextButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => ViewAllCubit(),
                      child: ViewAllScreen(result.title!,result.id!.toString()),
                    )));
              }, child: Text('View all'))

            ],
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                ProductThumbnail(result.productOptions![0], null),
                if(productsCount>1)
                  ...[
                    VerticalDivider(thickness: 1,color: Colors.grey,),
                    ProductThumbnail(result.productOptions![1], null),

                  ]
              ],
            ),
          ),
          if(productsCount>2)
            ...[
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProductThumbnail(result.productOptions![2], null),
                    if(productsCount>3)
                      ...[
                        VerticalDivider(thickness: 1,color: Colors.grey,),
                        ProductThumbnail(result.productOptions![3], null),

                      ]
                  ],
                ),
              ),
            ]
        ],
      ),
    );
  }
}
