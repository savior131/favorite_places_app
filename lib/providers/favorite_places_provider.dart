import 'dart:io';

import 'package:favorite_places_app/models/favorite_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'create table favPlaces(id text primary key,name text,image text,lat real,lng real,address text)');
    },
    version: 1,
  );

  return db;
}

class FavoritePlacesNotifier extends StateNotifier<List<FavoritePlace>> {
  FavoritePlacesNotifier() : super([]);
  Future<void> loadFavoritePlaces() async {
    final db = await getDataBase();
    final places = await db.query('favPlaces');
    final favPlaces = places
        .map(
          (row) => FavoritePlace(
            id: row['id'] as String,
            name: row['name'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              longitude: row['lng'] as double,
              latitude: row['lat'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = favPlaces;
  }

  void triggerFavoritePlace(FavoritePlace favoritePlace) async {
    final bool exist = state.contains(favoritePlace);
    final db = await getDataBase();

    if (exist) {
      state =
          state.where((favPlace) => favPlace.id != favoritePlace.id).toList();
      await db.delete(
        'favPlaces',
        where: 'id = ?', // Use a placeholder for the id
        whereArgs: [
          favoritePlace.id
        ], // Pass the actual id as a separate argument
      );
    } else {
      final appDir = await sys_path.getApplicationDocumentsDirectory();
      final imageName = path.basename(favoritePlace.image.path);
      final copiedImage =
          await favoritePlace.image.copy('${appDir.path}/$imageName');
      favoritePlace.image = copiedImage;
      state = [...state, favoritePlace];

      db.insert('favPlaces', {
        'id': favoritePlace.id,
        'name': favoritePlace.name,
        'address': favoritePlace.location.address,
        'lat': favoritePlace.location.latitude,
        'lng': favoritePlace.location.longitude,
        'image': favoritePlace.image.path,
      });
    }
    return;
  }
}

final favoritePlacesProvider =
    StateNotifierProvider<FavoritePlacesNotifier, List<FavoritePlace>>(
  (ref) {
    return FavoritePlacesNotifier();
  },
);
