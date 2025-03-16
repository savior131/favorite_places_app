import 'dart:io';

import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/favorite_place.dart';
import 'package:favorite_places_app/providers/favorite_places_provider.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFavoritePlaceScreen extends ConsumerStatefulWidget {
  const AddFavoritePlaceScreen({super.key});
  @override
  ConsumerState<AddFavoritePlaceScreen> createState() {
    return _AddFavoritePlaceScreenState();
  }
}

class _AddFavoritePlaceScreenState
    extends ConsumerState<AddFavoritePlaceScreen> {
  final formKey = GlobalKey<FormState>();
  String enteredName = '';
  File? selectedImage;
  PlaceLocation? selectedLocation;
  void validateForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ref.read(favoritePlacesProvider.notifier).triggerFavoritePlace(
          FavoritePlace(
              name: enteredName,
              image: selectedImage!,
              location: selectedLocation!));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite Place'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('name'),
                  ),
                  style: TextStyle(color: colorScheme.onSurface),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter a name';
                    } else if (value.length < 2) {
                      return 'name entered is too short';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    enteredName = newValue!;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 1,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ImageInput(
                    onPickImage: (image) {
                      selectedImage = image;
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 1,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: LocationInput(
                    onSelectLoaction: (location) {
                      selectedLocation = location;
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton.icon(
                  onPressed: validateForm,
                  icon: const Icon(Icons.add),
                  label: const Text('add place'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
