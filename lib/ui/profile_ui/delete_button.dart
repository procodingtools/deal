import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/profile_ui/sell_to_dialog.dart';
import 'package:deal/ui/rate_ui/rate_user.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final ProductEntity product;
  final Function() onProductDelete;

  const DeleteButton({Key key, this.product, this.onProductDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.topRight,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          onTap: () => _showDeleteDialog(context),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.delete,
              color: Colors.red,
              size: 25.0,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                onPressed: () => _confirm(context),
                child: Text("Delete"),
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                color: Colors.redAccent,
                minWidth: double.infinity,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                elevation: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Or",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              MaterialButton(
                elevation: 5.0,
                onPressed: () => _sellTo(context),
                child: Text("Mark as Sold"),
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                color: Colors.green,
                minWidth: double.infinity,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            ],
          ),
          contentPadding:
          EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        );
      },
    );
  }

  _confirm(BuildContext context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              content: Text("Are you sure you want to delete item?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context), child: Text('No')),
                FlatButton(
                    onPressed: () {
                      _showLoaingDialog(context);
                      ProductWebService().deleteProduct(product.id).then((_) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        if (onProductDelete != null) onProductDelete();
                      });
                    },
                    child: Text("Yes")),
              ],
            ),
          );
        });
  }

  _sellTo(BuildContext context) {
    UserEntity selectedUser;
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SellToDialog(
              product: product,
              onUserChanged: (user) => selectedUser = user,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedUser != null)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RateUserScreen(
                                product: product,
                                user: selectedUser,
                              )));
                },
              )
            ],
          );
        });
  }

  void _showLoaingDialog(BuildContext context) {
    showDialog(barrierDismissible: false,context: context, builder: (context) =>
        WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            content: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Please wait...'),
            ),
          ),
        ));
  }
}
