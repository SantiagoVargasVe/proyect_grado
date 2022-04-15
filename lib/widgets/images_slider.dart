import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImagesSlider extends StatelessWidget {
  List<String> images;
  ImagesSlider({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((e) {
        return Container(
          child: Image.network(e, fit: BoxFit.cover),
        );
      }).toList(),
      options: CarouselOptions(
        enlargeCenterPage: true,
      ),
    );
  }
}
