import 'package:deal/ui/dialogs/auth/auth_dialog.dart';
import 'package:deal/ui/post_ui/post_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class PostProductCard extends StatelessWidget{

  final Function(bool status) onAuthDialog;
  final Function onProductAdded;

  const PostProductCard({Key key, this.onAuthDialog, this.onProductAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Card(
        elevation: 5.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        color: Values.primaryColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: MaterialButton(
            splashColor: Colors.white54,
            onPressed: () =>
                showDialog(
                    context: context,
                    builder: (context) {
                      return AppData.User != null
                          ? PostScreen(onProductAdded: onProductAdded,)
                          : AuthDialog(loginStatus: (status) {
                        if(onAuthDialog != null)
                          onAuthDialog(status);
                      });
                    }),
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Sell your stuff",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

}