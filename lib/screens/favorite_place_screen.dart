import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/favorite_place.dart';
import 'package:favorite_places_app/screens/google_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoritePlaceScreen extends StatelessWidget {
  const FavoritePlaceScreen({super.key, required this.favoritePlace});
  final FavoritePlace favoritePlace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(favoritePlace.name),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            favoritePlace.image,
            fit: BoxFit.fitHeight,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    final LatLng latLng = LatLng(
                        favoritePlace.location.latitude,
                        favoritePlace.location.longitude);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => GoogleMapScreen(
                          latlng: latLng,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  splashColor: colorScheme.onSecondaryContainer,
                  child: CircleAvatar(
                    backgroundImage: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: favoritePlace.location.snapshotLink)
                        .image,
                    radius: 60,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  textAlign: TextAlign.center,
                  favoritePlace.location.address,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
