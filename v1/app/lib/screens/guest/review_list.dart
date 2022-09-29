import 'package:app/models/review_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/review_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/review_item.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  ReviewList({Key? key}) : super(key: key);

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      Provider.of<ReviewProvider>(context, listen: false).getReviews(
          placeId:
              Provider.of<PlaceProvider>(context, listen: false).placeInfo.id,
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
    ReviewProvider reviewProvider = context.watch<ReviewProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Reviews"),
      ),
      body: Column(
        children: [
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: HORIZONTAL_PADDING),
              child: Row(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      placeProvider.placeInfo.photos.isNotEmpty
                          ? placeProvider.placeInfo.photos[0].small!
                          : placeholderImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  width: 15,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  IconText(
                    label: placeProvider.placeInfo.name,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  IconText(
                    label: placeProvider.placeInfo.address,
                    color: Colors.black,
                  )
                ])
              ])),
          if (reviewProvider.loading.contains("reviews-list"))
            const PlaceCardShimmer()
          else
            Expanded(
                child: ListView.builder(
                    itemCount: reviewProvider.reviewList.length,
                    itemBuilder: (context, index) {
                      Review review = reviewProvider.reviewList[index];
                      return ReviewItem(review: review);
                    }))
        ],
      ),
    );
  }
}
