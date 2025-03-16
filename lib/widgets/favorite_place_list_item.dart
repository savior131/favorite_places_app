import 'package:favorite_places_app/models/favorite_place.dart';
import 'package:flutter/material.dart';

class FavoritePlaceListItem extends StatelessWidget {
  const FavoritePlaceListItem({super.key, required this.favoritePlace});
  final FavoritePlace favoritePlace;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: FileImage(favoritePlace.image),
      ),
      title: Text(favoritePlace.name),
      subtitle: Text(favoritePlace.location.address),
    );
  }
}
