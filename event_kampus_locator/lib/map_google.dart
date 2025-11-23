import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  GoogleMapController? controller;
  Position? pos;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    final has = await Geolocator.isLocationServiceEnabled();
    if (!has) return;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) return;

    final p = await Geolocator.getCurrentPosition();
    setState(() {
      pos = p;
      markers = {
        Marker(
          markerId: const MarkerId("me"),
          position: LatLng(p.latitude, p.longitude),
          infoWindow: const InfoWindow(title: "Posisi Saya"),
        )
      };
    });

    controller?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(p.latitude, p.longitude),
      16,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps")),
      body: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: LatLng(-7.4246, 109.2332), zoom: 14),
        onMapCreated: (c) => controller = c,
        myLocationEnabled: true,
        markers: markers,
      ),
    );
  }
}
