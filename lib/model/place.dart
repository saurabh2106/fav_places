import 'dart:io';

import 'package:uuid/uuid.dart';

class Place {
  Place({required this.title, required this.image, required this.location})
      : id = uuid.v4();
  static const uuid = Uuid();
  final String id;
  final String title;
  File image;
  final PlaceLocation location;
}

class PlaceLocation {
  PlaceLocation({this.latitude, this.longitude, this.address});
  final double? latitude;
  final double? longitude;
  final String? address;
}
