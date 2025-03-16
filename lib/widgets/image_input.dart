import 'dart:io';

import 'package:favorite_places_app/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ImagePickerBehaviour { browseImage, takeImage }

final imagePicker = ImagePicker();

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;
  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;
  final formKey = GlobalKey<FormState>();
  String enteredName = '';
  void getImage({required ImagePickerBehaviour imagePickerBehaviour}) async {
    ImageSource source;
    switch (imagePickerBehaviour) {
      case ImagePickerBehaviour.browseImage:
        source = ImageSource.gallery;
        break;
      case ImagePickerBehaviour.takeImage:
        source = ImageSource.camera;
        break;
    }
    final xImage = await imagePicker.pickImage(
      source: source,
    );
    if (xImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(xImage.path);
    });
    widget.onPickImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget imagepickerContent;
    if (selectedImage == null) {
      imagepickerContent = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () {
              getImage(imagePickerBehaviour: ImagePickerBehaviour.takeImage);
            },
            label: const Text('take image'),
            icon: const Icon(Icons.camera),
          ),
          const SizedBox(
            width: 8,
          ),
          TextButton.icon(
            onPressed: () {
              getImage(imagePickerBehaviour: ImagePickerBehaviour.browseImage);
            },
            label: const Text('browse image'),
            icon: const Icon(Icons.storage),
          ),
        ],
      );
    } else {
      imagepickerContent = Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(colorScheme.error),
                backgroundColor: WidgetStatePropertyAll(
                  colorScheme.surface.withOpacity(0.3),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedImage = null;
                });
              },
              label: const Text('remove'),
              icon: const Icon(Icons.remove_circle_outline_outlined),
            ),
          ),
        ],
      );
    }
    return imagepickerContent;
  }
}
