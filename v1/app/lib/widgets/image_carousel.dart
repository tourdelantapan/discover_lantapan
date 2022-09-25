import 'package:app/models/photo_model.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  Photo photo;
  Function onPress;
  ImageCarousel({Key? key, required this.photo, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(0),
        image: DecorationImage(
          image: NetworkImage(photo.small ?? ""),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPress(),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}
