import 'package:app/models/place_model.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';

class TimeTableDisplay extends StatelessWidget {
  List<TimeTable> timeTable;
  TimeTableDisplay({Key? key, required this.timeTable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        DayOfWeek(timeOfDay: timeTable[0]),
        DayOfWeek(timeOfDay: timeTable[1])
      ]),
      Row(children: [
        DayOfWeek(timeOfDay: timeTable[2]),
        DayOfWeek(timeOfDay: timeTable[3])
      ]),
      Row(children: [
        DayOfWeek(timeOfDay: timeTable[4]),
        DayOfWeek(timeOfDay: timeTable[5])
      ]),
      Row(children: [
        DayOfWeek(timeOfDay: timeTable[6]),
      ])
    ]);
  }
}

class DayOfWeek extends StatelessWidget {
  TimeTable timeOfDay;
  DayOfWeek({Key? key, required this.timeOfDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                label: timeOfDay.day,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              if (timeOfDay.other == "CLOSED")
                IconText(
                    label: "Closed",
                    fontWeight: FontWeight.bold,
                    color: Colors.red)
              else if (timeOfDay.other == "247")
                IconText(
                    label: "Open 24/7",
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)
              else
                Row(children: [
                  IconText(
                      color: Colors.black,
                      label:
                          "${TimeOfDay(hour: timeOfDay.timeFromHour, minute: timeOfDay.timeFromMinute).format(context)} to "),
                  IconText(
                      color: Colors.black,
                      label: TimeOfDay(
                              hour: timeOfDay.timeToHour,
                              minute: timeOfDay.timeToMinute)
                          .format(context))
                ]),
            ]),
      ),
    );
  }
}
