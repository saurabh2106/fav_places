import 'dart:io';

import 'package:fav_places/model/place.dart';
import 'package:fav_places/provider/user_places_noti.dart';
import 'package:fav_places/widget/image_input.dart';
import 'package:fav_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? selectedLocation;

  void _saveNewPlace() {
    final inputWord = _titleController.text;

    if (inputWord.isEmpty ||
        _selectedImage == null ||
        selectedLocation == null) {
      return;
    }

    ref
        .read(userPlacesNotifier.notifier)
        .addPlace(inputWord, _selectedImage!, selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 20),
            ImageInput(
              onPickedImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 20),
            LocationInput(
              onSelectLocation: (location) {
                selectedLocation = location;
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: _saveNewPlace, label: const Text('Add Place')),
          ],
        ),
      ),
    );
  }
}
