import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {

  String image;


  ImageBanner(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: CachedNetworkImage(
        imageUrl: image,
        errorWidget: (context, url, error) => Icon(Icons.warning),
      ),
    );
  }
}
