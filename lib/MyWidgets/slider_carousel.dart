import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_smartstore/constants.dart';

class SliderCarousel extends StatefulWidget {
  late List<String> imgList;

  late List<Widget> imageSliders;

  SliderCarousel(this.imgList) {
    imageSliders = _generateSlides();
  }

  List<Widget> _generateSlides() {
    return imgList
        .map((item) => Container(
              margin: EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: HOST_URL + item,
                  fit: BoxFit.cover,
                  width: 1000,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.warning_rounded),
                ),
              ),
            ))
        .toList();
  }

  @override
  _SliderCarouselState createState() => _SliderCarouselState();
}

class _SliderCarouselState extends State<SliderCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            items: widget.imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                viewportFraction: 0.99,
                autoPlay: true,
                aspectRatio: 21 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),),
        Positioned(
            bottom: 8,
            right: 0,left: 0,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.asMap().entries.map((entry){
            return GestureDetector(
              onTap: (){
_controller.animateToPage(entry.key);
              },
              child: Container(
                width: 8,height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PRIMARY_SWATCH.withOpacity(_current==entry.key?0.9:0.4)
                ),
              ),
            );
          }).toList(),
        ))
      ],
    );
  }
}
