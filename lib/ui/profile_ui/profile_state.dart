import 'package:date_format/date_format.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/ui/item_details_ui/item_details_state.dart';
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

  int _count = 0;
  List<ProductEntity> _products = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this)..index = 0;

    UserWebService().getProductHistory().then((data){
      setState(() {
        _count = data['count'];
        _products.addAll(data['products']);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Builder(
        builder: (context) => new SliverFab(
          floatingWidget: Container(
            width: _width * .3,
            height: _width * .3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.white,
                  width: 3.5,
                ),
                color: Values.primaryColor),
            padding: EdgeInsets.all(3.0),
            child: ClipRRect(
              child: TransitionToImage(
                  image: AdvancedNetworkImage(widget.user.profilePicThumb, useDiskCache: true),
                  loadingWidget: Image.asset(
                    "assets/icon_profile_default.png",
                  ),
                placeholder: Image.asset(
                  "assets/icon_profile_default.png",
                ),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          floatingPosition:
              FloatingPosition(left: _width * .1, top: -_width * .05),
          expandedHeight: _height * .35,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _height * .35,
              pinned: true,
              title: Text("Hello"),
              floating: false,
              backgroundColor: Values.primaryColor,
              //title: Text("Sliver Fab"),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  width: _width,
                  child: Text(
                    "SliverFab Example",
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: _width * .42,
                          ),
                          Text(
                            "Joined on ${formatDate(widget.user.joinDate, [M, ' ', yyyy])}",
                            style: TextStyle(
                                color: Colors.grey.withOpacity(.8),
                                fontSize: 10.0),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(right: 8.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${_count??"0"} Items sold",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0,
                                  fontFamily: "Gilroy"),
                            ),
                          )),
                        ],
                      ),
                      _optionTabs(),
                    ],
                  ),
                )
              ]),
            ),
            _tabView()
          ],
        ),
      ),
    );
  }

  Widget _cardItem(ProductEntity product) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailsScreen(product: product,))),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: TransitionToImage(
                image: AdvancedNetworkImage(product.thumb,
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: Duration(days: 10))),
                placeholder: ShimmerText(height: 70.0, width: 70.0,),
                loadingWidget: FlutterLogo(size: _height * .2),
                repeat: ImageRepeat.noRepeat,
                //borderRadius: BorderRadius.circular(500.0),
              ),
            ),
            Container(
              width: double.infinity,
              height: 3.0,
              color: Values.primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "${product.title}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "\$${product.price}",
                        style:
                            TextStyle(color: Values.primaryColor, fontSize: 15.0),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Icon(
                    FontAwesomeIcons.heart,
                    color: Colors.pink,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _optionTabs() {
    return Padding(
        padding: EdgeInsets.only(top: _width * .2, bottom: _height * .05),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Values.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3.0,
          unselectedLabelStyle: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(
              color: Values.primaryColor, fontWeight: FontWeight.bold),
          tabs: <Widget>[
            Tab(
              text: "Sales $_count",
            )
          ],
        ));
  }

  Widget _tabView() {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        LimitedBox(
          maxHeight: 4000.0,
          child: TabBarView(
            children: [
              _salesGrid(),
            ],
            controller: _tabController,
          ),
        ),
      ]),
    );
  }

  Widget _salesGrid() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _products.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: .8),
      itemBuilder: (context, index) {
        final product = _products[index];
        return _cardItem(product);
      },
    );
  }
}
