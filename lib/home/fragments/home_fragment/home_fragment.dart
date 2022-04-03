import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/MyWidgets/category_item.dart';
import 'package:my_smartstore/MyWidgets/product_grid.dart';
import 'package:my_smartstore/MyWidgets/swiper.dart';
import 'package:my_smartstore/constants.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment_cubit.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment_state.dart';
import 'package:my_smartstore/page_items/page_items_cubit.dart';
import 'package:my_smartstore/page_items/page_items_state.dart';
import 'package:my_smartstore/search/search_cubit.dart';
import 'package:my_smartstore/search/search_screen.dart';

import '../../../MyWidgets/image_banner.dart';
import '../../../MyWidgets/slider_carousel.dart';
import '../../../models/page_item_model.dart';
import '../../../models/slide_model.dart';

class HomeFragment extends StatefulWidget {
  var slides;
  List<Results>? pgItems = [];

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeFragmentCubit, HomeFragmentState>(
        listener: (context, state) {
          if (state is HomeFragmentLoaded) {
            BlocProvider.of<PageItemsCubit>(context)
                .loadItems(state.categories[0].id);
          }
          if (state is HomeFragmentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state is HomeFragmentInitial) {
            BlocProvider.of<HomeFragmentCubit>(context).loadCategories();
          }
          if (state is HomeFragmentLoaded) {
            widget.slides = state.slides;

            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<HomeFragmentCubit>(context).loadCategories();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    toolbarHeight: 150,
                    titleSpacing: 0,
                    backgroundColor: Colors.white,
                    title: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          color: PRIMARY_SWATCH,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  elevation: MaterialStateProperty.all(0)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        BlocProvider(
                                          create: (_) => SearchCubit(),
                                          child: SearchScreen(),)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Search',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 80,
                          child: _categories(state),
                        )
                      ],
                    ),
                  ),
                  BlocConsumer<PageItemsCubit, PageItemsState>(
                    listener: (context, pgstate) {
                      if (pgstate is PageItemsFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(pgstate.message),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    builder: (context, pgstate) {
                      if (pgstate is PageItemsLoaded) {
                        widget.pgItems!.clear();
                        widget.pgItems!.add(Results(viewtype: 0));
                        widget.pgItems!.addAll(pgstate.pageItemModel.results!);
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index < widget.pgItems!.length) {
                            return listItem(widget.pgItems![index]);
                          } else {
                            if (pgstate is PageItemsLoaded &&
                                pgstate.pageItemModel.next != null) {
                              BlocProvider.of<PageItemsCubit>(context)
                                  .loadMoreItems();
                            }
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                            childCount: pgstate is PageItemsLoading ||
                                (pgstate is PageItemsLoaded &&
                                    pgstate.pageItemModel.next != null) ? widget
                                .pgItems!.length + 1 : widget.pgItems!.length),
                      );
                    },
                  )
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _categories(state) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length,
        itemBuilder: (_, index) {
          return CategoryItem(state.categories[index]);
        });
  }

  listItem(Results result) {
    switch (result.viewtype) {
      case 0:
        return SliderCarousel(List.from(
            widget.slides.map((SlideModel slide) => slide.image.toString())));
      case 1:
        return ImageBanner(DOMAIN_URL + result.image);
      case 2:
        return Swiper(result);
      case 3:
        return ProductGrid(result);
      default:
        return Text('error');
    }
  }
}
