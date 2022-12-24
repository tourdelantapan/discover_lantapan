import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/image_carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String assetPath) async {
  return await rootBundle.loadString(assetPath);
}

class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isLoading = true;
  int _currentIndex = 0;

  List<Barangay> barangays = [
    Barangay(
        name: "LEGEND OF BARANGAY BUGCAON",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/bugcaon.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY KULASIHAN",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/kulasihan.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY BATUANON",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/batuanon.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY CAPITAN JUAN",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/capitan_juan.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY POBLACION",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/poblacion.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY BALILA",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/balila.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY BACLAYON",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/baclayon.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY ALANIB",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/alanib.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY KAATUAN",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/kaatuan.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY SONGCO",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/songco.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY CAWAYAN",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/cawayan.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY VICTORY",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/victory.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY KIBANGGAY",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/kibangay.txt'),
    Barangay(
        name: "LEGEND OF BARANGAY BASAC",
        photo: const AssetImage('assets/images/history.jpeg'),
        history: 'assets/text/basac.txt'),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      () async {
        for (int i = 0; i < barangays.length; i++) {
          barangays[i].history = await loadAsset(barangays[i].history);
        }
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          isLoading = false;
        });
      }();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBG1,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 1,
              color: Colors.white,
            ))
          : ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider(
                    items: List.generate(
                        barangays.length,
                        (index) => ImageCarousel(
                              borderRadius: 5,
                              bottomLabel: IconText(
                                label: barangays[index].name,
                                color: textColor2,
                                size: 16,
                                padding: const EdgeInsets.only(top: 10),
                                fontWeight: FontWeight.bold,
                              ),
                              assetImage: barangays[index].photo,
                              onPress: () {},
                            )),
                    options: CarouselOptions(
                      // viewportFraction: .1,
                      enableInfiniteScroll: false,
                      aspectRatio: 2,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      pageViewKey:
                          const PageStorageKey<String>('carousel_slider'),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        key: ValueKey<int>(_currentIndex),
                        barangays[_currentIndex].history,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: textColor2, height: 1.5),
                      )),
                )
              ],
            ),
    );
  }
}

class Barangay {
  Barangay({required this.name, required this.history, required this.photo});
  String name;
  AssetImage photo;
  String history;
}
