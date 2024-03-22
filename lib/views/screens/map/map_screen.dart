import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:geolocator/geolocator.dart";

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  ); // google headquarter

  late Position currentLocation;
  // get user current location
  getUserCurrentLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true,
    );
    currentLocation = position;

    // create variable to store latitude and longitude
    LatLng latPos = LatLng(position.latitude, position.longitude);

    // set the map's initial camera position to the user's current location
    CameraPosition cameraTarget = CameraPosition(target: latPos, zoom: 20);

    // move the map's camera to the new CameraPosition
    mapController.moveCamera(CameraUpdate.newCameraPosition(cameraTarget));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle shopText = GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            padding: const EdgeInsets.only(bottom: 100),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              getUserCurrentLocation();
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Shop Now",
                    style: shopText,
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    textStyle: shopText,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
