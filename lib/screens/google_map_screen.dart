import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen(
      {super.key,
      this.latlng = const LatLng(30.0444, 31.2357),
      required this.isSelecting});
  final LatLng latlng;
  final bool isSelecting;
  @override
  State<GoogleMapScreen> createState() {
    return _GoogleMapScreenState();
  }
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? selectedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          (widget.isSelecting)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context, selectedLocation ?? widget.latlng);
                  },
                  icon: const Icon(Icons.save),
                )
              : const SizedBox(),
        ],
        title:
            Text((widget.isSelecting) ? 'pick your location' : 'your location'),
      ),
      body: GoogleMap(
        onTap: (widget.isSelecting)
            ? (location) {
                setState(() {
                  selectedLocation = location;
                });
              }
            : null,
        initialCameraPosition: CameraPosition(
          target: widget.latlng,
          zoom: 10,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: selectedLocation ?? widget.latlng,
          )
        },
      ),
    );
  }
}
