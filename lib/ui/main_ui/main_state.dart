import 'package:deal/entities/product.dart';
import 'package:deal/ui/auth_ui/auth_state.dart';
import 'package:deal/ui/dialogs/auth/auth_dialog.dart';
import 'package:deal/ui/dialogs/settings/settings_dialog.dart';
import 'package:deal/ui/main_ui/item_card.dart';
import 'package:deal/ui/main_ui/main_drawer.dart';
import 'package:deal/ui/post_ui/post_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MainScreen extends StatefulWidget {
  createState() => _MainState();
}

class _MainState extends State<MainScreen> with TickerProviderStateMixin {
  final _width = Dimens.Width, _height = Dimens.Height;

  final _scrollController = ScrollController();

  AnimationController _animController;
  Animation _animation;

  List<Widget> _appBarActions, _appliedAppBarActions;
  Widget _appBarTitle, _appBarSearch, _appliedAppBarTitle;

  double _oldScrollPosition = 0.0;

  bool _isSetToSearch = false, _isLoading = true;

  List<ProductEntity> _products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
    _animController.forward();

    _products = List();

    ProductWebService().getPosts().then((list) {
      setState(() {
        _products.addAll(list);
        _isLoading = false;
      });
    });

    _appBarActions = [
      InkWell(
        onTap: () => setState(() {
          _appliedAppBarTitle = _appBarSearch;
          _appliedAppBarActions = [];
          _isSetToSearch = true;
        }),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.search),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
            onTap: () => showDialog(context: context, builder: (context) => AuthDialog(
              loginStatus: (status){
                if(status)
                  setState(() {
                    _isLoading = true;
                    _products.clear();
                    ProductWebService().getPosts().then((list) {
                      setState(() {
                        _products.addAll(list);
                        _isLoading = false;
                      });
                    });
                  });
              },
            )),
            child: Icon(Icons.notifications_none)),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
            onTap: () => showDialog(
                context: context, builder: (context) => SettingsDialog()),
            child: Icon(Icons.tune)),
      )
    ];

    _appliedAppBarActions = List()..addAll(_appBarActions);

    _appBarTitle = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Image.asset(
            "assets/icon_logo_white.png",
            width: 30.0,
          ),
        ),
        Text("Deal"),
      ],
    );

    _appBarSearch = DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: TextField(
        decoration: InputDecoration(
          fillColor: Colors.white,
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: "Search",
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          border: InputBorder.none,
        ),
        style: TextStyle(fontWeight: FontWeight.bold),
        expands: false,
        autocorrect: false,
        autofocus: true,
        minLines: 1,
      ),
    );

    _appliedAppBarTitle = _appBarTitle;
  }

  AxisDirection _scrollDirection() {
    //print("${_scrollController.position.pixels}   ${_oldScrollPosition}");
    if (_scrollController.position.pixels > _oldScrollPosition) {
      _oldScrollPosition = _scrollController.position.pixels - 1;
      return AxisDirection.up;
    } else {
      _oldScrollPosition = _scrollController.position.pixels + 1;
      return AxisDirection.down;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: _appBar(),
        drawer: MainDrawer(),
        body: WillPopScope(
          onWillPop: () {
            if (_isSetToSearch) {
              setState(() {
                _appliedAppBarTitle = _appBarTitle;
                _appliedAppBarActions = _appBarActions;
                _isSetToSearch = false;
              });
            } else
              return Future.value(true);
          },
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: _gridView(),
                ),
                _cards(),
              ],
            ),
          ),
        ));
  }

  Widget _gridView() {
    return StaggeredGridView.countBuilder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      primary: false,
      physics: _isLoading ? NeverScrollableScrollPhysics() : null,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
      itemBuilder: (context, index) {
        _scrollController.position.addListener(() => {
              _scrollDirection() == AxisDirection.down
                  ? _animController.forward()
                  : _animController.reverse()
            });

        ProductEntity product;
        if (!_isLoading) product = _products[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ItemCard(
            isLoading: _isLoading,
            product: product,
          ),
        );
      },
      itemCount: !_isLoading ? _products.length : 10,
    );
  }

  Widget _cards() {
    return AnimatedBuilder(
        animation: _animController,
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Transform(
                  transform: Matrix4.translationValues(
                      .0, 0 - (255.0 - (255 * _animation.value)), .0),
                  child: Opacity(
                    child: _topCard(),
                    opacity: _animation.value,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform(
                  transform: Matrix4.translationValues(
                      .0, 255 - (255 * _animation.value), .0),
                  child: Opacity(
                    opacity: _animation.value,
                    child: _bottomCatd(),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _topCard() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text("Deals near you"),
        ),
      ),
    );
  }

  Widget _bottomCatd() {
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
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AppData.User != null ? PostScreen() : AuthDialog(loginStatus: (status){
                    if(status)
                      setState(() {
                        _isLoading = true;
                        _products.clear();
                        ProductWebService().getPosts().then((list) {
                          setState(() {
                            _products.addAll(list);
                            _isLoading = false;
                          });
                        });
                      });
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

  Widget _appBar() {
    return AppBar(
      backgroundColor: Values.primaryColor,
      title: _appliedAppBarTitle,
      actions: _appliedAppBarActions,
    );
  }
}
