import 'package:app/provider/location_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      Provider.of<LocationProvider>(context, listen: false).resetMarkers();
      Provider.of<LocationProvider>(context, listen: false).setMarker(
          "destination",
          Provider.of<LocationProvider>(context, listen: false)
              .destination
              .coordinates);
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    LocationProvider locationProvider = context.watch<LocationProvider>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: .3,
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: false,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setModalState) {
                          return Modal(
                              title: "Long press to pin your location",
                              heightInPercentage: .9,
                              content: SelectLocation());
                        });
                      });
                },
                icon: const Icon(Icons.pin_drop_rounded))
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
                child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: locationProvider.initialCameraPosition,
              markers: Set<Marker>.of(locationProvider.markers.values),
              polylines: locationProvider.polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: Provider.of<LocationProvider>(context,
                                listen: false)
                            .destination
                            .coordinates,
                        zoom: mapZoom)));
              },
            )),
            Container(
              padding: EdgeInsets.only(
                  left: HORIZONTAL_PADDING,
                  right: HORIZONTAL_PADDING,
                  bottom: bottomPadding == 0.0 ? 15 : bottomPadding),
              color: Colors.white,
              child: Column(children: [
                const SizedBox(
                  height: 15,
                ),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    label: "Destination Tracking"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red[50]),
                              child: const Icon(
                                Icons.pin_drop_rounded,
                                color: Colors.red,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            locationProvider.address.isEmpty
                                ? "No location"
                                : locationProvider.address.trim(),
                            maxLines: 2,
                          ))
                        ]),
                      ),
                      const Expanded(
                          child: Icon(Icons.arrow_right_alt_rounded)),
                      Expanded(
                        child: Row(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Image(
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(placeholderImage))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            locationProvider.destination.name,
                            maxLines: 2,
                          ))
                        ]),
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    label: "Travel Gas Consumption"),
                const SizedBox(
                  height: 25,
                ),
                Details(
                  label: "Trip Distance",
                  value: "${locationProvider.distance.toStringAsFixed(2)}km",
                  measurement: "Kilometers(km)",
                  iconAsset: 'assets/images/distance.png',
                ),
                const SizedBox(
                  height: 25,
                ),
                Details(
                  label: "Fuel Efficiency",
                  value: "${locationProvider.liters.toStringAsFixed(2)} liter",
                  // measurement: "Liters per 100km(L/100km)",
                  measurement: "1L per 12.5km",
                  iconAsset: 'assets/images/fuel.png',
                ),
                const SizedBox(
                  height: 25,
                ),
                Details(
                  label: "Gas Fuel Price",
                  value: "₱${locationProvider.fuelPrice.toStringAsFixed(2)}",
                  measurement: "₱74.20 per Liter",
                  iconAsset: 'assets/images/price.png',
                ),
                const SizedBox(
                  height: 25,
                ),
              ]),
            )
          ],
        ));
  }
}

class Details extends StatelessWidget {
  String label;
  String value;
  String measurement;
  String iconAsset;
  Details(
      {Key? key,
      required this.label,
      required this.value,
      required this.measurement,
      required this.iconAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image(height: 25, width: 25, image: AssetImage(iconAsset)),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconText(
            mainAxisAlignment: MainAxisAlignment.start,
            label: label,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          IconText(
            mainAxisAlignment: MainAxisAlignment.start,
            label: value,
            color: Colors.black,
          )
        ]),
      ),
      Expanded(
        child: IconText(
          mainAxisAlignment: MainAxisAlignment.start,
          label: measurement,
          color: Colors.black,
        ),
      )
    ]);
  }
}

class SelectLocation extends StatefulWidget {
  SelectLocation({Key? key}) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String address = "";
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.143548493162127, 125.13147031688014),
    zoom: mapZoom,
  );
  bool detectingLocation = false;
  LatLng? coordinates;

  _determinePosition() async {
    setState(() => detectingLocation = true);
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      launchSnackbar(
          context: context,
          mode: "ERROR",
          message: 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        launchSnackbar(
            context: context,
            mode: "ERROR",
            message: 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      launchSnackbar(
          context: context,
          mode: "ERROR",
          message:
              'Location permissions are permanently denied, we cannot request permissions.');
    }
    var res = await Geolocator.getCurrentPosition();
    double tempLat = 8.042233792899466;
    double tempLong = 125.15568791362584;
    // THIS IS JUST TEMPORARY
    // mapController?.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(target: LatLng(res.latitude, res.latitude), zoom: 17)));
    // setMarker(LatLng(res.latitude, res.latitude));
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(tempLat, tempLong), zoom: mapZoom)));
    setMarker(LatLng(tempLat, tempLong));
    setState(() => detectingLocation = false);
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      _determinePosition();
    }();
    super.initState();
  }

  setMarker(LatLng pos) async {
    // var markerIdVal = DateTime.now().millisecondsSinceEpoch.toString();
    var markerIdVal = "no_id";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: pos,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );

    setState(() {
      markers[markerId] = marker;
      coordinates = pos;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() => address =
        "${placemarks[0].street}${placemarks[0].street!.isEmpty ? "" : ","} ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}");
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (detectingLocation) const LinearProgressIndicator(),
      const SizedBox(
        height: 15,
      ),
      IconText(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          mainAxisAlignment: MainAxisAlignment.start,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          label: "Your Location"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
            address.isNotEmpty
                ? address.trim()
                : detectingLocation
                    ? "Detecting location..."
                    : "Select Location",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      const SizedBox(
        height: 15,
      ),
      Button(
          backgroundColor: Colors.black87,
          borderColor: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          label: "Select Location",
          onPress: () {
            if (coordinates == null) {
              launchSnackbar(
                  context: context, mode: "ERROR", message: "No location yet.");
              return;
            }

            Provider.of<LocationProvider>(context, listen: false)
                .setCoordinates(coordinates!, address);
            Navigator.pop(context);
          }),
      const SizedBox(
        height: 15,
      ),
      Expanded(
          child: GoogleMap(
        key: const Key("Yuh"),
        onLongPress: (pos) => setMarker(pos),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
      )),
    ]);
  }
}


// https://pub.dev/packages/google_directions_api
// https://medium.com/@shiraz990/flutter-fetching-google-directions-using-changenotifierprovider-f642adbe6cf4