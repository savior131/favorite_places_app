import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/favorite_place.dart';
import 'package:favorite_places_app/providers/favorite_places_provider.dart';
import 'package:favorite_places_app/screens/add_favorite_place_screen.dart';
import 'package:favorite_places_app/screens/favorite_place_screen.dart';
import 'package:favorite_places_app/widgets/favorite_place_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlacesScreen extends ConsumerStatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  ConsumerState<FavoritePlacesScreen> createState() {
    return _FavoritePlacesScreenState();
  }
}

class _FavoritePlacesScreenState extends ConsumerState<FavoritePlacesScreen> {
  late Future<void> favoritePlacesFuture;
  @override
  void initState() {
    super.initState();
    favoritePlacesFuture =
        ref.read(favoritePlacesProvider.notifier).loadFavoritePlaces();
  }

  @override
  Widget build(BuildContext context) {
    final favoritePlacesList = ref.watch(favoritePlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your FavoritePlaces'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddFavoritePlaceScreen(),
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: favoritePlacesFuture,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.waiting)
            ? const Center(child: CircularProgressIndicator())
            : ListViewWidget(favoritePlacesList: favoritePlacesList, ref: ref),
      ),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
    super.key,
    required this.favoritePlacesList,
    required this.ref,
  });

  final List<FavoritePlace> favoritePlacesList;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return (favoritePlacesList.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) => Dismissible(
              background: Container(
                color: colorScheme.error,
              ),
              key: ValueKey(favoritePlacesList[index].id),
              onDismissed: (direction) => ref
                  .read(favoritePlacesProvider.notifier)
                  .triggerFavoritePlace(favoritePlacesList[index]),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritePlaceScreen(
                                favoritePlace: favoritePlacesList[index])));
                  },
                  child: FavoritePlaceListItem(
                      favoritePlace: favoritePlacesList[index])),
            ),
            itemCount: favoritePlacesList.length,
          )
        : const Center(
            child: Text(
              'no places yet',
              style: TextStyle(color: Colors.white70),
            ),
          );
  }
}
