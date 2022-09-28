import 'package:app/models/place_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/grid_count.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/place_card.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ManagePlaces extends StatefulWidget {
  Map<String, dynamic> arguments;
  ManagePlaces({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ManagePlaces> createState() => _ManagePlacesState();
}

class _ManagePlacesState extends State<ManagePlaces> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      Provider.of<PlaceProvider>(context, listen: false).getPlaces(
          query: {"mode": widget.arguments["mode"]},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/place/add");
        },
        isExtended: true,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            if (placeProvider.loading.isNotEmpty)
              const PlaceCardShimmer()
            else if (placeProvider.adminPlaces.isNotEmpty)
              Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount:
                          getGridCount(MediaQuery.of(context).size.width),
                    ),
                    itemCount: placeProvider.adminPlaces.length,
                    itemBuilder: (BuildContext context, int index) {
                      Place place = placeProvider.adminPlaces[index];

                      return PlaceCard(
                          photoUrl: place.photos.isNotEmpty
                              ? place.photos[0].small
                              : placeholderImage,
                          onPress: () {},
                          topLeft: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          label: place.name,
                          subLabel: place.address);
                    }),
              )
            else
              IconText(
                padding: const EdgeInsets.only(top: 50),
                label: "No content",
                color: Colors.black54,
                icon: Icons.air_rounded,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
      ),
    );
  }
}
