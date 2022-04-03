import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/MyWidgets/product_thumbnail.dart';
import 'package:my_smartstore/viewall/viewall_cubit.dart';
import 'package:my_smartstore/viewall/viewall_screen.dart';

import '../models/page_item_model.dart';

class Swiper extends StatelessWidget {
  late Results result;

  Swiper(this.result);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                result.title!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (_) => ViewAllCubit(),
                              child: ViewAllScreen(result.title!,result.id!.toString()),
                            )));
                  },
                  child: Text('View all'))
            ],
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: result.productOptions!.length,
                itemBuilder: (context, index) {
                  ProductOptions product = result.productOptions![index];
                  return ProductThumbnail(product, 150);
                }),
          )
        ],
      ),
    );
  }
}
