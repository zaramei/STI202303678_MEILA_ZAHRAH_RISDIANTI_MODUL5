import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapOSM extends StatefulWidget {
  const MapOSM({super.key});

  @override
  State<MapOSM> createState() => _MapOSMState();
}

class _MapOSMState extends State<MapOSM> {
  Position? pos;
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) return;

    final p = await Geolocator.getCurrentPosition();
    setState(() => pos = p);

    mapController.move(LatLng(p.latitude, p.longitude), 16);
  }

  @override
  Widget build(BuildContext context) {
    final center = pos != null
        ? LatLng(pos!.latitude, pos!.longitude)
        : LatLng(-7.4246, 109.2332);

    return Scaffold(
      appBar: AppBar(title: const Text("OpenStreetMap")),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(initialCenter: center, initialZoom: 14),
        children: [
          TileLayer(
            urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.event_kampus_locator",
          ),
          MarkerLayer(markers: [
            Marker(
              point: center,
              width: 40,
              height: 40,
              child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
            )
          ])
        ],
      ),
    );
  }
}
