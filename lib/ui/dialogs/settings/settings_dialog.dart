import 'package:deal/ui/location_picker/location_picker_state.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class SettingsDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> data;

  const SettingsDialog({Key key, this.onDataChanged, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: _DialogContent(
        onDataChanged: onDataChanged,
        data: data,
      ),
    );
  }
}

class _DialogContent extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> data;

  const _DialogContent({Key key, this.onDataChanged, this.data})
      : super(key: key);
  createState() => _DialogState();
}

class _DialogState extends State<_DialogContent> {
  final _languages = ["English", "Espagnole", "عربي"];

  String _selectedLang;
  LocationResult _location;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedLang = widget.data['lang'] ?? _languages[0];
    _location = widget.data['loc'];
  }

  _onLocationChanged(LocationResult result) => setState(() {
        _location = result;
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationPickerScreen(
                          onLocationChanged: _onLocationChanged,
                        ))),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                child: Text(
                  _location == null ? "Select location" : _location.address ?? "Select location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                child: DropdownButton<String>(
                    onChanged: (item) {
                      setState(() {
                        _selectedLang = item;
                      });
                    },
                    isExpanded: true,
                    isDense: true,
                    underline: Container(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black),
                    value: _selectedLang,
                    items: _languages.map((lang) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          lang,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: lang,
                      );
                    }).toList()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
                onPressed: () {
                  widget
                      .onDataChanged({"lang": _selectedLang, 'loc': _location});
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                color: Values.primaryColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                        child: Text(
                      "Done",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white),
                    )),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
