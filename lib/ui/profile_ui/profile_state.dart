import 'package:date_format/date_format.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/auth_ui/password_form.dart';
import 'package:deal/ui/common/post_product_card.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/ui/item_details_ui/item_details_state.dart';
import 'package:deal/ui/profile_ui/SliverBar.dart';
import 'package:deal/ui/profile_ui/delete_button.dart';
import 'package:deal/ui/profile_ui/floatting_profilr_picture.dart';
import 'package:deal/ui/profile_ui/profile_card_item.dart';
import 'package:deal/ui/profile_ui/sliver_list.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/user_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliver_fab/sliver_fab.dart';

class ProfileScreen extends StatefulWidget {
  final UserEntity user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> with TickerProviderStateMixin {
  final double _width = Dimens.Width, _height = Dimens.Height;
  TabController _tabController;

  int _soldCount = 0, _favCount = 0;
  List<ProductEntity> _productsHistory = List();
  List<ProductEntity> _productsFav = List();
  UserEntity _user;
  bool _editProfile = false;
  final _formKey = GlobalKey<FormState>();
  String _userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _user = widget.user ?? AppData.User;

    _tabController = TabController(
        length: _user.id == AppData.User?.id ?? 0 ? 2 : 1,
        vsync: this,
        initialIndex: 0);

    /*.then((data) {
      
    });*/

    _fetchData();

    Future.delayed(Duration(milliseconds: 20)).then((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: AlertDialog(
                  content: ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text("Please wait..."),
                  ),
                ),
              ));
    });
  }

  void _fetchData() {
    setState(() {
      _soldCount = 0;
      _productsHistory.clear();
      _favCount = 0;
      _productsFav.clear();
    });

    Future.wait([
      UserWebService().getProductHistory(_user.id),
      _user.id == AppData.User?.id ?? 0
          ? UserWebService().getFavProducts()
          : Future.delayed(Duration(microseconds: 1))
    ]).then((data) {
      setState(() {
        Navigator.pop(context);
        _soldCount = data[0]['count'];
        _productsHistory.addAll(data[0]['products']);
        if (_user.id == AppData.User?.id ?? 0) {
          _favCount = data[1]['count'];
          _productsFav.addAll(data[1]['products']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          if (_editProfile)
            setState(() {
              _editProfile = false;
            });
          else
            return Future.value(true);
        },
        child: Stack(
          children: <Widget>[
            new Builder(
              builder: (context) => new SliverFab(
                floatingWidget: FloattingProfilePicture(
                    editProfile: _editProfile, picUrl: _user.profilePicThumb),
                floatingPosition:
                    FloatingPosition(left: _width * .1, top: -_width * .05),
                expandedHeight: _height * .35,
                slivers: <Widget>[
                  SliverBar(
                    editProfile: _editProfile,
                    user: _user,
                    onEditClicked: () {
                      setState(() {
                        _editProfile = true;
                        _userName = AppData.User.name;
                      });
                    },
                  ),
                  _editProfile
                      ? SliverList(
                          delegate:
                              SliverChildListDelegate(<Widget>[Container()]),
                        )
                      : ProfileSliverList(
                          user: _user,
                          optionTabs: _optionTabs(),
                          soldCount: _soldCount,
                        ),
                  _editProfile
                      ? SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Dimens.Height * .15),
                                      child: _editText(
                                          of: "Full name", toUpdate: _userName),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: _editText(
                                          enabled: false,
                                          of: "Email",
                                          toUpdate: AppData.User.email),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 30.0, bottom: 50.0),
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PasswordForm())),
                                              child: Text(
                                                'Change Password',
                                                style: TextStyle(
                                                    fontSize: 13.5,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              textColor: Values.primaryColor,
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _formKey.currentState.save();
                                                  UserWebService()
                                                      .updateUser(
                                                          AppData.User.name)
                                                      .then((_) {
                                                    setState(() {
                                                      _editProfile = false;
                                                      setState(() {
                                                        AppData.User.name =
                                                            _userName;
                                                      });
                                                    });
                                                  });
                                                }
                                              },
                                              child:
                                                  Text("Update".toUpperCase()),
                                              color: Values.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500.0)),
                                              textColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40.0,
                                                  vertical: 20.0),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                          ]),
                        )
                      : _tabView()
                ],
              ),
            ),

            //post product card
            Align(
              alignment: Alignment.bottomCenter,
              child: _editProfile
                  ? Container()
                  : PostProductCard(
                      onProductAdded: () {
                        _fetchData();
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _editText({String of, toUpdate, bool enabled = true}) {
    return TextFormField(
      enabled: enabled,
      keyboardType: TextInputType.text,
      validator: (txt) {
        if (txt.length < 3) return "Please fill with valid $of";
        return null;
      },
      onSaved: (txt) => setState(() {
        _userName = enabled ? txt : _userName;
      }),
      //focusNode: _usernameFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {
        //_usernameFocus.unfocus();
        //FocusScope.of(context).requestFocus(_mailFocus);
      },
      maxLines: 1,
      initialValue: toUpdate,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: Dimens.Width * .05, vertical: 10.0),
          labelText: "$of",
          labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }

  Widget _optionTabs() {
    List<Widget> tabs = [
      Tab(
        text: "Sales ($_soldCount)",
      ),
    ];
    if (_user.id == AppData.User?.id ?? 0)
      tabs.add(Tab(
        text: "Saved ($_favCount)",
      ));

    return Padding(
        padding: EdgeInsets.only(top: _width * .2, bottom: _height * .05),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Values.primaryColor,
          indicatorSize: _user.id == AppData.User?.id ?? 0
              ? TabBarIndicatorSize.tab
              : TabBarIndicatorSize.label,
          indicatorWeight: 3.0,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelColor: Values.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: tabs,
        ));
  }

  Widget _tabView() {
    List<Widget> tabView = [
      _grid(_productsHistory, isMine: true),
    ];
    if (_user.id == AppData.User?.id) tabView.add(_grid(_productsFav));
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        LimitedBox(
          maxHeight: 4000.0,
          child: TabBarView(
            children: tabView,
            controller: _tabController,
          ),
        ),
      ]),
    );
  }

  Widget _grid(List<ProductEntity> products, {bool isMine = false}) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: .8),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProfileCardItem(
          product: product,
          isMine: isMine,
          onDeleteProduct: () => setState(() {
            _soldCount--;
            _productsHistory.remove(product);
          }),
        );
      },
    );
  }
}
