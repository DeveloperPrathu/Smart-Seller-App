import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/models/category_model.dart';
import 'package:my_smartstore/page_items/page_items_cubit.dart';
import 'package:my_smartstore/page_items/page_items_state.dart';

import '../MyWidgets/image_banner.dart';
import '../MyWidgets/product_grid.dart';
import '../MyWidgets/slider_carousel.dart';
import '../MyWidgets/swiper.dart';
import '../constants.dart';
import '../models/page_item_model.dart';

class PageItemsScreen extends StatelessWidget {
  late CategoryModel _categoryModel;
  List<Results>? pgItems = [];

  PageItemsScreen(this._categoryModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryModel.name!),
      ),
      body: BlocConsumer<PageItemsCubit,PageItemsState>(
        listener: (context,state){

        },
        builder: (context,state){
          if(state is PageItemsInitial){
            BlocProvider.of<PageItemsCubit>(context)
                .loadItems(_categoryModel.id);
          }

          if(state is PageItemsLoaded){
            pgItems!.clear();
            pgItems!.addAll(state.pageItemModel.results!);
          }

          return ListView.builder(
            itemBuilder: (context,index){
              if(index < pgItems!.length){
                return listItem(pgItems![index]);
              }else{
                if(state is PageItemsLoaded && state.pageItemModel.next != null){
                  BlocProvider.of<PageItemsCubit>(context).loadMoreItems();
                }
                return Center(child: CircularProgressIndicator());
              }
            },
              itemCount: state is PageItemsLoading || (state is PageItemsLoaded && state.pageItemModel.next!=null)?pgItems!.length+1:pgItems!.length,
          );
        },
      ),
    );
  }

  listItem(Results result) {
    switch (result.viewtype) {
      case 1:
        return ImageBanner(DOMAIN_URL+result.image);
      case 2:
        return Swiper(result);
      case 3:
        return ProductGrid(result);
      default:
        return Text('error');
    }
  }
}
