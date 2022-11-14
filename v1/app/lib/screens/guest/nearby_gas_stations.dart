import 'dart:async';
import 'dart:convert';

import 'package:app/models/gas_station_model.dart';
import 'package:app/models/photo_model.dart';
import 'package:app/provider/app_provider.dart';
import 'package:app/provider/location_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/image_carousel.dart';
import 'package:app/widgets/place_card.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as coords;

class NearbyGasStations extends StatefulWidget {
  NearbyGasStations({Key? key}) : super(key: key);

  @override
  State<NearbyGasStations> createState() => _NearbyGasStationsState();
}

class _NearbyGasStationsState extends State<NearbyGasStations> {
  int index = 0;
  late GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CarouselController buttonCarouselController = CarouselController();

  fetchPlaces() {
    coords.LatLng loc =
        Provider.of<LocationProvider>(context, listen: false).coordinates;
    Provider.of<AppProvider>(context, listen: false).getGasStationList(
        query: {
          "userLocation":
              jsonEncode({"latitude": loc.latitude, "longitude": loc.longitude})
        },
        callback: (code, message) async {
          if (code != 200) {
            launchSnackbar(
                context: context,
                mode: code == 200 ? "SUCCESS" : "ERROR",
                message: message ?? "Success!");
            return;
          }

          var icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), 'assets/images/fuel_map.png');

          List<GasStation> gasStations =
              Provider.of<AppProvider>(context, listen: false).gasStations;

          for (int i = 0; i < gasStations.length; i++) {
            MarkerId locationMarkerId = MarkerId(gasStations[i].id);
            Marker locationMarker = Marker(
              icon: icon,
              markerId: locationMarkerId,
              position: gasStations[i].coordinates.coordinates,
              infoWindow: InfoWindow(title: gasStations[i].name),
              onTap: () {
                setState(() {
                  index = i;
                });
                _controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: Provider.of<AppProvider>(context, listen: false)
                            .gasStations[i]
                            .coordinates
                            .coordinates,
                        zoom: mapZoom)));
              },
            );
            markers[locationMarkerId] = locationMarker;
          }
        });
  }

  @override
  void initState() {
    if (!mounted) return;
    fetchPlaces();
    MarkerId locationMarkerId = const MarkerId("location");
    Marker locationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(.5),
      markerId: locationMarkerId,
      position: LatLng(
          Provider.of<LocationProvider>(context, listen: false)
              .coordinates
              .latitude,
          Provider.of<LocationProvider>(context, listen: false)
              .coordinates
              .longitude),
      infoWindow: const InfoWindow(title: "location", snippet: '*'),
      onTap: () {},
    );
    markers[locationMarkerId] = locationMarker;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.watch<AppProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: .3,
          actions: [
            if (appProvider.loading == "gas-station-list")
              showDoubleBounce(size: 20, color: Colors.white),
            const SizedBox(
              width: 30,
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Expanded(
              child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: const LatLng(8.053088729642518, 125.13539297751151),
              zoom: mapZoom,
            ),
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              coords.LatLng latlng =
                  Provider.of<LocationProvider>(context, listen: false)
                      .coordinates;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(latlng.latitude, latlng.longitude),
                      zoom: mapZoom)));
            },
          )),
          if (appProvider.gasStations.isNotEmpty)
            Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * .90,
                      height: height * .3,
                      child: PlaceCard(
                          onPress: () {},
                          photoUrl:
                              appProvider.gasStations[index].photos[0].original,
                          label: appProvider.gasStations[index].name),
                    ),
                  ],
                ))
        ]));
  }
}
