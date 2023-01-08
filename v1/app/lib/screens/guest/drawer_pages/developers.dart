import 'package:app/screens/guest/drawer_pages/tourism_staff.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:flutter/material.dart';

class Developers extends StatefulWidget {
  Developers({Key? key}) : super(key: key);

  @override
  State<Developers> createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {
  List<List> staff = [
    [
      Staff(
          name: "Anthony\nPaglas",
          designation: "Developer",
          photo: const AssetImage('assets/images/developers/paglas.JPG')),
      Staff(
          name: "John Paul\nTadiamon",
          designation: "Developer",
          photo: const AssetImage('assets/images/developers/noto.jpg')),
    ],
    [
      Staff(
          name: "Justine\nBinanlao",
          designation: "Developer",
          photo: const AssetImage('assets/images/developers/binanlao.jpg')),
      Staff(
          name: "Klinton\nNoto",
          designation: "Developer",
          photo: const AssetImage('assets/images/developers/tadiamon.jpg'))
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBG1,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile(context)
                        ? 0
                        : MediaQuery.of(context).size.width * .30,
                    vertical: 15),
                itemCount: staff.length,
                itemBuilder: (context, i) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                          staff[i].length,
                          (ind) => Expanded(
                              child: StaffBadge(staff: staff[i][ind]))),
                    )),
          )
        ],
      ),
    );
  }
}
