import 'package:fav_places/store/location_input_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../widget/map.dart';
import '../model/place.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatelessWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  Widget build(BuildContext context) {
    final locationStore = LocationInputStore();

    return Observer(
      builder: (_) {
        Widget previewContent = Text(
          'No Location Chosen',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        );

        if (locationStore.isGettingLocation) {
          previewContent = const CircularProgressIndicator();
        } else if (locationStore.pickedLocation != null) {
          previewContent = MapPreview(
            latitude: locationStore.pickedLocation!.latitude!,
            longitude: locationStore.pickedLocation!.longitude!,
          );
        }

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              ),
              height: 150,
              width: double.infinity,
              alignment: Alignment.center,
              child: previewContent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await locationStore.getCurrentLocation();
                    if (locationStore.pickedLocation != null) {
                      onSelectLocation(locationStore.pickedLocation!);
                    }
                  },
                  icon: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Get Current Location',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    LatLng? selectedCoordinates =
                        await Navigator.of(context).push<LatLng>(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (ctx) => MapPreview(
                          latitude:
                              locationStore.pickedLocation?.latitude ?? 19.1752,
                          longitude: locationStore.pickedLocation?.longitude ??
                              72.9423,
                          isSelectable: true,
                        ),
                      ),
                    );

                    if (selectedCoordinates != null) {
                      await locationStore.selectOnMap(selectedCoordinates);
                      if (locationStore.pickedLocation != null) {
                        onSelectLocation(locationStore.pickedLocation!);
                      }
                    }
                  },
                  icon: Icon(
                    Icons.map_sharp,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Select on Map',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
