import 'dart:math';

import 'package:fav_places/model/place.dart';
import 'package:fav_places/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;
  var isGettingLocation = false;
  String? address;
  MapPreview? mapPreview;

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    if (latitude != null && longitude != null) {
      // Convert coordinates to an address
      try {
        List<geocode.Placemark> placemarks =
            await geocode.placemarkFromCoordinates(latitude, longitude);
        geocode.Placemark place = placemarks[0];
        address = "${place.street}, ${place.locality}, ${place.country}";

        setState(() {
          pickedLocation = PlaceLocation(
            latitude: latitude,
            longitude: longitude,
            address: address,
          );
          isGettingLocation = false;
        });

        widget.onSelectLocation(pickedLocation!);
      } catch (e) {
        setState(() {
          address = "Could not get address";
          isGettingLocation = false;
        });
      }
    }
  }

  void selectOnMap() async {
    LatLng? selectedCoordinates = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapPreview(
          latitude:
              pickedLocation?.latitude ?? 19.1752, // Default to India's lat
          longitude: pickedLocation?.longitude ?? 72.9423,
          isSelectable: true, // Enable selection on this instance
        ),
      ),
    );

    if (selectedCoordinates != null) {
      // If new coordinates are selected, update address and map preview
      try {
        List<geocode.Placemark> placemarks =
            await geocode.placemarkFromCoordinates(
          selectedCoordinates.latitude,
          selectedCoordinates.longitude,
        );
        geocode.Placemark place = placemarks[0];
        address = "${place.street}, ${place.locality}, ${place.country}";

        setState(() {
          pickedLocation = PlaceLocation(
              latitude: selectedCoordinates.latitude,
              longitude: selectedCoordinates.longitude,
              address: address);
          mapPreview = MapPreview(
              latitude: selectedCoordinates.latitude,
              longitude: selectedCoordinates.longitude);
          print(selectedCoordinates.latitude);
          print(selectedCoordinates.longitude);
        });

        widget.onSelectLocation(pickedLocation!);
      } catch (e) {
        setState(() {
          address = "Could not get address";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location Chosen',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
    );

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (mapPreview != null) {
      previewContent = Container(child: mapPreview);
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
              onPressed: getCurrentLocation,
              label: Text(
                'Get Current Location',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              label: Text(
                'Select on Map',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              icon: Icon(
                Icons.map_sharp,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
