import 'package:deal/ui/about_ui/webview_state.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Values.primaryColor,
        title: Text("About"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              "About Deal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebviewScreen(
                          title: "About Deal",
                          file: "About_English.html",
                        ))),
          ),
          Divider(
            color: Colors.grey,
            height: 0.0,
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text(
              "Terms of Service",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebviewScreen(
                      title: "Terms of Service",
                      file: "Terms_English.html",
                    ))),
          ),
          Divider(
            color: Colors.grey,
            height: 0.0,
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text(
              "Privacy Policy",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 0.0,
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text(
              "Feedback",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
