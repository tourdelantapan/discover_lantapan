import 'dart:io';

import 'package:app/models/category_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/screens/guest/mapview.dart';
import 'package:app/widgets/add_photo.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/chips.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPlace extends StatefulWidget {
  AddPlace({Key? key}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> payload = {
    "name": "",
    "address": "",
    "description": "",
    "latitude": 0.0,
    "longitude": 0.0,
    "categoryId": "",
    "status": "OPEN"
  };
  Map<String, dynamic> _payload = {};
  List<File> photos = [];
  List<String> status = ["OPEN", "CLOSED"];
  var addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _payload = {...payload};
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (payload["latitude"] == 0.0) {
              launchSnackbar(
                  context: context,
                  mode: "ERROR",
                  message: "Pin location on the map.");
              return;
            }

            if (payload["categoryId"].isEmpty) {
              launchSnackbar(
                  context: context,
                  mode: "ERROR",
                  message: "Select a Category");
              return;
            }

            if (_formKey.currentState!.validate()) {
              Provider.of<PlaceProvider>(context, listen: false).addPlace(
                  payload: payload,
                  files: photos,
                  callback: (code, message) {
                    if (code == 200) {
                      launchSnackbar(
                          context: context,
                          mode: "SUCCESS",
                          message: message ?? "Success!");
                      setState(() {
                        photos = [];
                        payload = _payload;
                      });
                      addressController.clear();
                      _formKey.currentState!.reset();
                      return;
                    }
                    if (code != 200) {
                      launchSnackbar(
                          context: context,
                          mode: code == 200 ? "SUCCESS" : "ERROR",
                          message: message ?? "Error!");
                    }
                  });
            }
          },
          label: const Text("Add Place"),
          icon: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          title: const Text("Add Place"),
        ),
        body: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(15), children: [
              if (placeProvider.loading.contains("place-add"))
                const LinearProgressIndicator(),
              AddPhotos(
                  photos: photos,
                  onDeletePhoto: (index) =>
                      setState(() => photos.removeAt(index)),
                  onAddPhotos: (List<File> photos) {
                    setState(() => this.photos = photos);
                  }),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: payload["name"],
                onChanged: (e) => setState(() => payload["name"] = e.trim()),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "This field is required";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Name")),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: addressController,
                onChanged: (e) => setState(() => payload["address"] = e.trim()),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "This field is required";
                  }
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text("Address"),
                    suffixIcon: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setModalState) {
                                  return Modal(
                                      title: "Long press to pin your location",
                                      heightInPercentage: .9,
                                      content: SelectLocation(onSelectLocation:
                                          (coordinates, address) {
                                        payload["latitude"] =
                                            coordinates.latitude;
                                        payload["longitude"] =
                                            coordinates.longitude;
                                        payload["address"] = address;
                                        addressController.text = address;
                                      }));
                                });
                              });
                        },
                        icon: const Icon(Icons.pin_drop_rounded))),
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: payload["description"],
                maxLines: null,
                onChanged: (e) =>
                    setState(() => payload["description"] = e.trim()),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "This field is required";
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Description")),
              ),
              const SizedBox(height: 15),
              IconText(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  label: "Select one category"),
              const SizedBox(height: 5),
              Row(
                  children: List.generate(
                      categories.length,
                      (index) => Chippy(
                          backgroundColor:
                              payload["categoryId"] == categories[index].id
                                  ? Colors.black
                                  : Colors.grey,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          label: categories[index].name,
                          onPress: () => setState(() =>
                              payload["categoryId"] = categories[index].id)))),
              const SizedBox(height: 15),
              IconText(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  label: "Status"),
              const SizedBox(height: 5),
              Row(
                  children: List.generate(
                      status.length,
                      (index) => Chippy(
                          backgroundColor: payload["status"] == status[index]
                              ? Colors.black
                              : Colors.grey,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          label: status[index],
                          onPress: () => setState(
                              () => payload["status"] = status[index]))))
            ])));
  }
}
