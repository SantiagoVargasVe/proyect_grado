import 'package:flutter/material.dart';
import 'card_event.dart';
import '../models/event_data.dart';

class EventSlider extends StatelessWidget {
  const EventSlider({
    Key? key,
    required this.events,
  }) : super(key: key);

  final List<EventData> events;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 3 / 5,
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 43,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return GridTile(
                key: UniqueKey(),
                child: CardEvent(
                  title: events[index].title,
                  date: events[index].date,
                  isParcipating: events[index].isParticipating,
                ));
          }),
    );
  }
}
