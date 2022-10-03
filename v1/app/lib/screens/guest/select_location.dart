import 'package:app/utilities/constants.dart';
import 'package:app/utilities/reverse_geocode.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class SelectLocation extends StatefulWidget {
  bool willDetectLocation;
  LatLng? value;
  Function onSelectLocation;
  SelectLocation(
      {Key? key,
      required this.willDetectLocation,
      this.value,
      required this.onSelectLocation})
      : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String address = "";
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(8.143548493162127, 125.13147031688014),
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
    // double tempLat = 8.042233792899466;
    // double tempLong = 125.15568791362584;
    // THIS IS JUST TEMPORARY
    // mapController?.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(target: LatLng(tempLat, tempLong), zoom: mapZoom)));
    // setMarker(LatLng(tempLat, tempLong));
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(res.latitude, res.longitude), zoom: 17)));
    setMarker(LatLng(res.latitude, res.longitude));
    setState(() => detectingLocation = false);
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      if (widget.willDetectLocation) {
        _determinePosition();
      }
      if (widget.value != null && !widget.willDetectLocation) {
        setMarker(widget.value!);
      }
    }();
    super.initState();
  }

  setMarker(LatLng pos) async {
    var markerIdVal = "no_id";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: pos,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );

    address = await AddressRepository.reverseGeocode(coordinates: pos);

    setState(() {
      markers[markerId] = marker;
      coordinates = pos;
    });

    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(pos.latitude, pos.longitude);
    // int lastInd = placemarks.length - 1;
    // setState(() => address =
    //     "${placemarks[lastInd].street}${placemarks[lastInd].street!.isEmpty ? "" : ","} ${placemarks[lastInd].subLocality}${placemarks[lastInd].subLocality!.isEmpty ? "" : ","}${placemarks[lastInd].locality}, ${placemarks[lastInd].administrativeArea}");
  }

  @override
  Widget build(BuildContext context) {
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

            widget.onSelectLocation(coordinates, address);
            Navigator.pop(context);
          }),
      const SizedBox(
        height: 15,
      ),
      Expanded(
          child: GoogleMap(
        key: const Key("map"),
        onLongPress: (pos) => setMarker(pos),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          if (widget.value != null && !widget.willDetectLocation) {
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: widget.value!, zoom: 30)));
          }
          mapController = controller;
        },
      )),
    ]);
  }
}
