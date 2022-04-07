import 'package:flutter/material.dart';
import 'event_slider.dart';

class CommunitiesFeed extends StatelessWidget {
  CommunitiesFeed({Key? key}) : super(key: key);

  final List dummyData = List.generate(10, (index) => '$index');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Activos",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        const SizedBox(height: 20),
        EventSlider(dummyData: dummyData),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Te pueden gustar",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        const SizedBox(height: 20),
        EventSlider(dummyData: dummyData),
      ],
    );
  }
}
