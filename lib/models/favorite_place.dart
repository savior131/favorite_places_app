import 'dart:io';
import 'package:favorite_places_app/main.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
String snapShot(lat, lng) {
  return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Alabel:S%7C$lat,$lng&key=$googleAPIKey';
}

class PlaceLocation {
  PlaceLocation({
    required this.longitude,
    required this.latitude,
    required this.address,
  }) : snapshotLink = snapShot(latitude, longitude);
  final double longitude;
  final double latitude;
  final String address;
  final String snapshotLink;
}

class FavoritePlace {
  FavoritePlace({
    required this.name,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  final String name;
  final String id;
  File image;
  final PlaceLocation location;
}
