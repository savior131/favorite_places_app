import 'dart:convert';

import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/favorite_place.dart';
import 'package:favorite_places_app/screens/google_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLoaction});
  final void Function(PlaceLocation location) onSelectLoaction;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? selectedLocation;

  void getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    if (!context.mounted) {
      return;
    }
    LatLng selectedLatLng = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => (locationData.latitude != null)
            ? GoogleMapScreen(
                latlng: LatLng(locationData.latitude!, locationData.latitude!),
                isSelecting: true)
            : const GoogleMapScreen(isSelecting: true),
      ),
    );
    final lng = selectedLatLng.longitude;
    final lat = selectedLatLng.latitude;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleAPIKey');
    final response = await http.get(url);
    final responseDate = jsonDecode(response.body);
    final address = responseDate['results'][0]['formatted_address'];
    setState(() {
      selectedLocation = PlaceLocation(
        address: address,
        longitude: lng,
        latitude: lat,
      );
    });
    widget.onSelectLoaction(selectedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: IconButton(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
        ),
        onPressed: getLocation,
        icon: const Icon(Icons.location_on),
      ),
    );
    if (selectedLocation != null) {
      mainContent = FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: selectedLocation!.snapshotLink,
        fit: BoxFit.fitWidth,
      );
    }

    return mainContent;
  }
}
