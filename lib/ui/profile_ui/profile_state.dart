import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliver_fab/sliver_fab.dart';

class ProfileScreen extends StatefulWidget {
  createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final double _width = Dimens.Width, _height = Dimens.Height;

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
              child: Image.asset(
                "assets/icon_profile_default.png",
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
                            "Joined on Aug 2017",
                            style: TextStyle(
                                color: Colors.grey.withOpacity(.8),
                                fontSize: 10.0),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(right: 8.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "0 Items sold",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0,
                                  fontFamily: "Gilroy"),
                            ),
                          )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _width * .2, bottom: _height*.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sale (2)',
                              style: TextStyle(
                                  color: Values.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            Container(
                              width: _width * .5,
                              height: 3.0,
                              color: Values.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]
              ),
            ),
            SliverGrid(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .8),
              delegate: SliverChildListDelegate(List.generate(20, (i) => i).map((index){
                return _cardItem();
              }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardItem() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TransitionToImage(
              image: AdvancedNetworkImage("fdx",
                  useDiskCache: true,
                  cacheRule: CacheRule(maxAge: Duration(days: 10))),
              placeholder: FlutterLogo(
                size: _height * .20,
              ),
              loadingWidget: FlutterLogo(size: _height * .2),
              repeat: ImageRepeat.noRepeat,
              borderRadius: BorderRadius.circular(500.0),
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
              "Desk",
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
                      "\$180",
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
    );
  }
}
