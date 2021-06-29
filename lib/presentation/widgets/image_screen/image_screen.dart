import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class ImageScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int startingIndex;

  ImageScreen({this.imageUrls, this.startingIndex = 0});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ExtendedImageGesturePageView.builder(
        controller: PageController(initialPage: widget.startingIndex),
        itemCount: widget.imageUrls.length,
        itemBuilder: (_, index) =>
            ExtendedImage.network(
              widget.imageUrls[index],
              fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (ExtendedImageState state) => GestureConfig(
                inPageView: true,
                initialScale: 1.0,
                maxScale: 5.0,
                animationMaxScale: 6.0,
                initialAlignment: InitialAlignment.center,
              ),
            ),
      ),
    );
  }
}
