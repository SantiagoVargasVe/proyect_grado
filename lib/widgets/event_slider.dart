import 'package:flutter/material.dart';
import 'card_event.dart';

class EventSlider extends StatelessWidget {
  const EventSlider({
    Key? key,
    required this.dummyData,
  }) : super(key: key);

  final List dummyData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dummyData.length,
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 3 / 5,
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 43,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return const GridTile(child: CardEvent(title: "Uwu"));
          }),
    );
  }
}
