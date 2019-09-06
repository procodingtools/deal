import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';

class SellToDialog extends StatefulWidget {
  final ProductEntity product;
  final Function(UserEntity) onUserChanged;

  const SellToDialog({Key key, this.product, this.onUserChanged}) : super(key: key);

  createState() => _SellToDialogState();
}

class _SellToDialogState extends State<SellToDialog> {
  bool _isLoading = true;
  List<UserEntity> _users = List();
  UserEntity _selectedUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ProductWebService().getBuyersList(widget.product.id).then((list) {
      if (list != null) _users.addAll(list);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(maxHeight: Dimens.Height * .3,),
      child: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemBuilder: (context, index) {
                  UserEntity user = _users[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RadioListTile(
                        groupValue: _selectedUser,
                        title: Text(user.name),
                        selected: _selectedUser != null && _selectedUser == user,
                        value: user,
                        onChanged: (user) {
                          setState(() {
                            _selectedUser = user;
                            if(widget.onUserChanged != null)
                              widget.onUserChanged(_selectedUser);
                          });
                        },
                      ),
                      Divider(height: 1.0,)
                    ],
                  );
                },
          itemCount: _users.length,
              ),
      ),
    );
  }


  Widget _placeHolder(){
    return CircleAvatar(
      backgroundImage: AssetImage("assets/icon_profile_default.png",),
    );
  }
}
