import 'dart:io';

import 'package:app/widgets/icon_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddPhotos extends StatelessWidget {
  List<File> photos;
  Function onAddPhotos;
  Function onDeletePhoto;
  AddPhotos(
      {Key? key,
      required this.photos,
      required this.onAddPhotos,
      required this.onDeletePhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconText(
            size: 15,
            color: Colors.black,
            label: "Add Photos",
            icon: Icons.photo_sharp),
        IconButton(
            onPressed: () async {
              try {
                FilePickerResult? result = await FilePicker.platform
                    .pickFiles(type: FileType.image, allowMultiple: true);
                if (result == null) return;
                onAddPhotos(result.files.map((e) => File(e.path!)).toList());
              } catch (e) {
                print(e);
              }
            },
            icon: const Icon(Icons.add)),
      ]),
      SizedBox(
        height: MediaQuery.of(context).size.height * .15,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: photos.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image.file(
                      File(photos[index].path),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * .35,
                      height: MediaQuery.of(context).size.height,
                    )),
                Positioned(
                  right: -10,
                  top: -10,
                  child: IconButton(
                      onPressed: () => onDeletePhoto(index),
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      const Divider(
        height: 15,
      )
    ]);
  }
}
