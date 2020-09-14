

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowPhotoScreen extends StatelessWidget {
  final String imageUrl;

  const ShowPhotoScreen({Key key, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
            tag: imageUrl,
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => Center(
                child: Text("Error"),
              ),
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
        ),
      ),
    );
  }
}
