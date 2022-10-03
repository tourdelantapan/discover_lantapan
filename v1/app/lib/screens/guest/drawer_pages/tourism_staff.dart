import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';

class TourismStaff extends StatefulWidget {
  TourismStaff({Key? key}) : super(key: key);

  @override
  State<TourismStaff> createState() => _TourismStaffState();
}

class _TourismStaffState extends State<TourismStaff> {
  Staff president = Staff(
      name: "John Doe",
      designation: "President",
      photo: const AssetImage('assets/images/history.jpeg'));

  List<List> staff = [
    [
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg')),
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg')),
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg'))
    ],
    [
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg')),
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg')),
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg'))
    ],
    [
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg')),
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg')),
      Staff(
          name: "Mike Wheeler",
          designation: "Staff",
          photo: const AssetImage('assets/images/history.jpeg'))
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StaffBadge(staff: president),
      Expanded(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile(context)
                    ? 15
                    : MediaQuery.of(context).size.width * .30,
                vertical: 15),
            itemCount: staff.length,
            itemBuilder: (context, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(staff[i].length,
                      (ind) => StaffBadge(staff: staff[i][ind])),
                )),
      )
    ]);
  }
}

class StaffBadge extends StatelessWidget {
  final Staff staff;
  const StaffBadge({Key? key, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image(
              image: staff.photo,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          height: 15,
        ),
        IconText(
          mainAxisAlignment: MainAxisAlignment.center,
          label: staff.name,
          size: 17,
          color: Colors.black,
        ),
        IconText(
            label: staff.designation,
            mainAxisAlignment: MainAxisAlignment.center,
            color: Colors.grey),
      ]),
    );
  }
}

class Staff {
  Staff({required this.name, required this.designation, required this.photo});
  String name;
  String designation;
  AssetImage photo;
}
