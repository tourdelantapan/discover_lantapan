import 'package:app/models/photo_model.dart';
import 'package:app/provider/location_provider.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/action_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/image_carousel.dart';
import 'package:app/widgets/shimmer/place_info_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/utilities/string_extensions.dart';

class PlaceInfo extends StatefulWidget {
  Map<String, dynamic> arguments;
  PlaceInfo({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PlaceInfo> createState() => _PlaceInfoState();
}

class _PlaceInfoState extends State<PlaceInfo> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      Provider.of<PlaceProvider>(context, listen: false).getPlace(
          placeId: widget.arguments["placeId"],
          callback: (code, message) {
            if (code != 200) {
              launchSnackbar(
                  context: context,
                  mode: code == 200 ? "SUCCESS" : "ERROR",
                  message: message ?? "Success!");
            }
          });
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: .5,
        title: const Text("Place Details"),
      ),
      body: placeProvider.loading.contains("place-info")
          ? const PlaceInfoShimmer()
          : ListView(
              children: [
                CarouselSlider(
                    items: ([Photo(small: placeholderImage)]
                        .map((item) => ImageCarousel(
                              photo: item,
                              onPress: () {},
                            ))
                        .toList()),
                    options: CarouselOptions(
                      aspectRatio: 1,
                      autoPlay: true,
                      // enlargeCenterPage: true,
                      pageViewKey:
                          const PageStorageKey<String>('carousel_slider'),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: HORIZONTAL_PADDING),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconText(
                                size: 18,
                                label: placeProvider.placeInfo.name,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              IconText(
                                size: 16,
                                icon: Icons.pin_drop_rounded,
                                label: placeProvider.placeInfo.address,
                                color: Colors.black54,
                              )
                            ]),
                        Container(
                            decoration: BoxDecoration(
                                color: placeProvider.placeInfo.isLiked
                                    ? Colors.red[100]
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                                onPressed: () {
                                  if (userProvider.currentUser == null) {
                                    showModalBottomSheet(
                                        context: context,
                                        isDismissible: false,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext newContext,
                                                  StateSetter setModalState) {
                                            return ActionModal(
                                              isLoading: true,
                                              title: "Account Required.",
                                              subTitle:
                                                  "This action requires an account.",
                                              confirmAction: "Log In/SignUp",
                                              callback: (action) {
                                                if (action != "Log In/SignUp") {
                                                  return;
                                                }
                                                Navigator.pushNamed(
                                                    context, "/auth");
                                              },
                                            );
                                          });
                                        });
                                    return;
                                  }

                                  placeProvider.likePlace(
                                      mode: "single",
                                      index: -1,
                                      placeId: placeProvider.placeInfo.id,
                                      callback: (code, message) {
                                        launchSnackbar(
                                            context: context,
                                            mode: code == 200
                                                ? "SUCCESS"
                                                : "ERROR",
                                            message: code == 200
                                                ? message
                                                : "Failed to submit like.");
                                      });
                                },
                                icon: placeProvider.placeInfo.isLiked
                                    ? const Icon(Icons.favorite_rounded)
                                    : const Icon(Icons.favorite_border),
                                color: placeProvider.placeInfo.isLiked
                                    ? Colors.red
                                    : Colors.black))
                      ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: HORIZONTAL_PADDING),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FeatureBadge(
                              icon: Icons.star_rate_rounded,
                              accentColor: Colors.red,
                              label: "Rating",
                              value: "4.8 (3.2k)"),
                          FeatureBadge(
                              icon: Icons.directions,
                              accentColor: Colors.blue,
                              label: "Distance",
                              value: "3000 km"),
                          FeatureBadge(
                              icon: Icons.door_sliding_rounded,
                              accentColor: Colors.green,
                              label: placeProvider.placeInfo.categoryId.name,
                              value: placeProvider.placeInfo.status.titleCase())
                        ])),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: HORIZONTAL_PADDING),
                  child: Text(
                    placeProvider.placeInfo.description,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Button(
                    borderColor: Colors.transparent,
                    backgroundColor: Colors.black,
                    margin: const EdgeInsets.symmetric(
                        horizontal: HORIZONTAL_PADDING),
                    label: "Show on Map",
                    onPress: () {
                      Provider.of<LocationProvider>(context, listen: false)
                          .setDestination(placeProvider.placeInfo);
                      Navigator.pushNamed(context, "/mapview");
                    })
              ],
            ),
    );
  }
}

class FeatureBadge extends StatelessWidget {
  Color accentColor;
  String label;
  String value;
  IconData icon;
  FeatureBadge(
      {Key? key,
      required this.accentColor,
      required this.label,
      required this.icon,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 25,
            color: accentColor,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconText(
              label: label,
              color: Colors.black,
            ),
            IconText(
              label: value,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ],
        )
      ],
    );
  }
}
