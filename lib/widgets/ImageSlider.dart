import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
    'assets/images/pizza.jpg',
    'assets/images/pasta.jpg',
    'assets/images/burger.jpg',
  ];

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CarouselSlider(
          options: CarouselOptions(),
          items: imgList.map((item) => Container(
            child: Center(
              child: Image.asset(item, fit: BoxFit.cover, width: 1000)
            ),
          )).toList(),
        )
      ),
    );
  }
}

final List<Widget> imageSlider = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Stack(
        children: <Widget>[
          Image.asset(item, fit: BoxFit.cover, width: 1000.0),
        ],
      )
    ),
  ),
)).toList();