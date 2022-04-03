import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/models/category_model.dart';
import 'package:my_smartstore/page_items/page_items_cubit.dart';
import 'package:my_smartstore/page_items/page_items_screen.dart';

class CategoryItem extends StatelessWidget {
  late CategoryModel categoryModel;

  CategoryItem(this.categoryModel);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                BlocProvider<PageItemsCubit>(
                    create: (_) =>
                        PageItemsCubit(),
                    child: PageItemsScreen(categoryModel))));
      },
      child: Container(
        width: 60,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: HOST_URL + categoryModel.image!,
              fit: BoxFit.contain,
              height: 40,
              width: 40,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              categoryModel.name!,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
