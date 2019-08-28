import 'package:deal/entities/category.dart';
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
import 'package:google_map_location_picker/google_map_location_picker.dart';

class MainScreen extends StatefulWidget {
  createState() => _MainState();
}

class _MainState extends State<MainScreen> with TickerProviderStateMixin {
  final _width = Dimens.Width, _height = Dimens.Height;
  final _scrollController = ScrollController();

  AnimationController _animController;
  Animation _animation;

  //to switch between Search/Normal appBar
  List<Widget> _appBarActions, _appliedAppBarActions;
  Widget _appBarTitle, _appBarSearch, _appliedAppBarTitle;

  //to check if user scrolling down ot top
  double _oldScrollPosition = 0.0;

  bool _isSetToSearch = false /*if appBar is searching mode*/,
      _isLoading = true /*to check if loading for first time*/,
      _isLoadingNext = true

      /*to check if is loading new items when user reach the end of list*/;

  List<ProductEntity> _products;

  //filtring by category
  CategoryEntity _selectedCategory;

  //current app lang
  String _lang = "English";

  //searching by location (starts by the user location)
  LocationResult _location = LocationResult(
      lat: double.parse(AppData.Latitude),
      lng: double.parse(AppData.Longitude));

  //when user select category
  _onCategoryCahnged(CategoryEntity category, CategoryEntity subCat) {
    setState(() {
      _isLoading = true;
      if (category != null)
        _selectedCategory = CategoryEntity()
          ..id = category.id
          ..label = category.label
          ..subCategory = subCat != null
              ? [
                  CategoryEntity()
                    ..id = subCat.id
                    ..label = subCat.label
                ]
              : null;
      else
        _selectedCategory = null;
    });

    //moving list to first position
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);

    //getting products
    ProductWebService()
        .getPosts(
            lat: _location.latLng.latitude,
            lng: _location.latLng.longitude,
            category: _selectedCategory)
        .then((list) {
      setState(() {
        _products.clear();
        _products = List.from(list);
        _isLoading = false;
      });
    });
  }

  //when user change settings
  _onSettingsChanged(Map<String, dynamic> data) {
    setState(() {
      _lang = data['lang'];
      _location = data['loc'];
      _isLoading = true;
    });

    //moving list to first index
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);

    //getting products
    ProductWebService()
        .getPosts(
            lat: _location.latLng.latitude, lng: _location.latLng.longitude)
        .then((list) {
      setState(() {
        _products.clear();
        _products = List.from(list);
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //initializing animations
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
    _animController.forward();

    //initializing products
    _products = List();

    //getting products for the first time
    ProductWebService().getPosts().then((list) {
      setState(() {
        _products.addAll(list);
        _isLoading = false;
        _isLoadingNext = false;
      });
    });

    //_______________________initializing appBar views__________________________
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
            onTap: () => showDialog(
                context: context,
                builder: (context) => AuthDialog(
                      loginStatus: (status) {
                        if (status)
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
                context: context,
                builder: (context) => SettingsDialog(
                      onDataChanged: _onSettingsChanged,
                      data: {"lang": _lang, 'loc': _location},
                    )),
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
    //_____________________end initializing appBar views________________________
  }

  //defining scrolling direction
  AxisDirection _scrollDirection() {
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
        drawer: MainDrawer(
          catgoryCallback: _onCategoryCahnged,
        ),
        body: WillPopScope(
          onWillPop: () {
            //if appBar is searching mode, switch to normal view
            if (_isSetToSearch) {
              setState(() {
                _appliedAppBarTitle = _appBarTitle;
                _appliedAppBarActions = _appBarActions;
                _isSetToSearch = false;
              });
            } else //quitting app
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
      //blocking user scrolling if is loading for the first time
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
      itemBuilder: (context, index) {
        _scrollController.position.addListener(() {
          //show/hide overlay cards
          _scrollDirection() == AxisDirection.down
              ? _animController.forward()
              : _animController.reverse();

          //checking if will reach the end of scroll to get more results
          if (_scrollController.position.maxScrollExtent - _height * .3 >=
                  _scrollController.position.pixels &&
              !_isLoadingNext) {
            print("reached");
            setState(() {
              _isLoadingNext = true;
            });
            ProductWebService()
                .getPosts(
                    offset: _products.length,
                    lat: _location.latLng.latitude,
                    lng: _location.latLng.longitude,
                    category: _selectedCategory)
                .then((list) {
              setState(() {
                _products.addAll(list);
                _isLoadingNext = false;
              });
            });
          }
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
                    child: _productsNearCard(),
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
                    child: _postProductCard(),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _productsNearCard() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RichText(
              overflow: TextOverflow.clip,
                text: TextSpan(text: "Deals near ", style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: "${_location?.city ?? "you"}",
                  style: TextStyle(
                      color: _location?.city != null
                          ? Values.primaryColor
                          : Colors.black))
            ])),
          ),
        ),
      ),
    );
  }

  Widget _postProductCard() {
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
                  return AppData.User != null
                      ? PostScreen()
                      : AuthDialog(loginStatus: (status) {
                          if (status)
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
      bottom: PreferredSize(
        preferredSize: Size(
            double.infinity, _selectedCategory != null ? _height * .08 : 0),
        child: Container(
          color: Values.primaryColor,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _selectedCategory == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(left: 20.0, bottom: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            _selectedCategory.label,
                            style: TextStyle(color: Values.primaryColor),
                          ),
                        ),
                        InkWell(
                            onTap: () => _onCategoryCahnged(null, null),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.remove_circle,
                                color: Values.primaryColor,
                                size: 13.0,
                              ),
                            ))
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
