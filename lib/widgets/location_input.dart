import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/location_helpers.dart';
import 'package:flutter_complete_guide/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function({double latitude, double longitude}) onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview({double latitude, double longitude}) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      await Future.delayed(Duration(seconds: 3));
      _showPreview(latitude: locData.latitude, longitude: locData.longitude);
      widget.onSelectPlace(
        latitude: locData.latitude,
        longitude: locData.longitude,
      );
    } catch (error) {
      print(error);
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) {
      return;
    }

    _showPreview(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
    widget.onSelectPlace(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: Text('Current Location'),
              onPressed: _getCurrentUserLocation,
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: Text('Select on Map'),
              onPressed: _selectOnMap,
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
