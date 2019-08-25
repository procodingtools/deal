import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: _DialogContent(),
    );
  }
}

class _DialogContent extends StatefulWidget {
  createState() => _DialogState();
}

class _DialogState extends State<_DialogContent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
              child: Text("Select location", style: TextStyle(fontWeight: FontWeight.bold),),
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
                child: Text("English", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
                onPressed: () => Navigator.pop(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                color: Values.primaryColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(child: Text("Done", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),)),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}
