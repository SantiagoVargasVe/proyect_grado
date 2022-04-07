import 'package:flutter/material.dart';

class CardEvent extends StatelessWidget {
  final String title;
  final DateTime? date;
  const CardEvent({Key? key, required this.title, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: const Color.fromARGB(255, 164, 102, 212),
        onTap: () {},
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(" Club de lectura",
                  style: Theme.of(context).textTheme.headline5),
              Text(date?.toString() ?? ""),
            ]),
          ),
        ),
      ),
    );
  }
}
