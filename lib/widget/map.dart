import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isSelectable;

  const MapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.isSelectable = true, // Default to false
  });

  @override
  MapPreviewState createState() => MapPreviewState();
}

class MapPreviewState extends State<MapPreview> {
  late LatLng markerPosition;

  @override
  void initState() {
    super.initState();
    // Set initial position of the marker
    markerPosition = LatLng(widget.latitude, widget.longitude);
  }

  void onTapp(TapPosition tapPosition, LatLng position) {
    // If map is in selectable mode, update the marker's position
    if (widget.isSelectable) {
      setState(() {
        markerPosition = position;
      });
      // Pass the selected location back to the previous screen
      Navigator.of(context).pop(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(widget.latitude, widget.longitude),
        initialZoom: 7.0,
        onTap: onTapp, // Listen to tap events
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: markerPosition,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
