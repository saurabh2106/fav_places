import 'package:mobx/mobx.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import '../model/place.dart';

part 'location_input_store.g.dart';

class LocationInputStore = LocationStore with _$LocationInputStore;

abstract class LocationStore with Store {
  @observable
  PlaceLocation? pickedLocation;

  @observable
  bool isGettingLocation = false;

  @observable
  String? address;

  @action
  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    isGettingLocation = true;

    try {
      final locationData = await location.getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      if (latitude != null && longitude != null) {
        List<geocode.Placemark> placemarks =
            await geocode.placemarkFromCoordinates(latitude, longitude);
        geocode.Placemark place = placemarks[0];
        address = "${place.street}, ${place.locality}, ${place.country}";

        pickedLocation = PlaceLocation(
          latitude: latitude,
          longitude: longitude,
          address: address,
        );
      }
    } catch (_) {
      address = "Could not get address";
    } finally {
      isGettingLocation = false;
    }
  }

  @action
  Future<void> selectOnMap(LatLng selectedCoordinates) async {
    try {
      List<geocode.Placemark> placemarks =
          await geocode.placemarkFromCoordinates(
        selectedCoordinates.latitude,
        selectedCoordinates.longitude,
      );
      geocode.Placemark place = placemarks[0];
      address = "${place.street}, ${place.locality}, ${place.country}";

      pickedLocation = PlaceLocation(
        latitude: selectedCoordinates.latitude,
        longitude: selectedCoordinates.longitude,
        address: address,
      );
    } catch (_) {
      address = "Could not get address";
    }
  }
}
