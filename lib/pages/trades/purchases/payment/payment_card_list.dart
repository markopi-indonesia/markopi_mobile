
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PaymentCardList extends StatefulWidget {
  @override
  _PaymentCardListState createState() => _PaymentCardListState();
}

class _PaymentCardListState extends State<PaymentCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        height: 200,
        viewportFraction: 0.81,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        items: [1,2,3,4,5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                height: 200,
                  child: Image.asset("assets/sample/card.jpg",fit: BoxFit.cover,));
            },
          );
        }).toList(),
      )
    );
  }
}
