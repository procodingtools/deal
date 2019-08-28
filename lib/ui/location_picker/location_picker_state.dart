import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class LocationPickerScreen extends StatelessWidget {
  final String _apiKey = "AIzaSyBaZsFdNzfRESf6rIYYUVN4pvmSSZn4wbw";
  final Function(LocationResult location) onLocationChanged;

  const LocationPickerScreen({Key key, @required this.onLocationChanged}) : assert(onLocationChanged != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Builder(builder: (context) {
        Future.delayed(Duration(microseconds: 100)).then((_) {
          _getLocation(context).then((val) {
            if (val == null)
              Navigator.pop(context);
            else {
              onLocationChanged(val);
              Navigator.pop(context);
            }
          });
        });
        return Container();
      }),
    );
  }

  Future<LocationResult> _getLocation(BuildContext context) async {
    return await LocationPicker.pickLocation(context, _apiKey);
  }
}
