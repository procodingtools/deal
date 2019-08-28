import 'package:deal/entities/product_details.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:sliver_fab/sliver_fab.dart';

class ReportScreen extends StatelessWidget {
  final ProductDetailsEntity details;

  const ReportScreen({Key key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = Dimens.Width, _height = Dimens.Height;
    final List<String> reasons = [
      "It's prohibited on Deals",
      "It's offensive to me",
      "It's not real post",
      "It's a duplicated post",
      "I'ts in the wrong category",
      "It may be scam",
      "It may be stolen",
      "Other"
    ];
    // TODO: implement build
    return Scaffold(
      body: Builder(
          builder: (context) => SliverFab(
                slivers: <Widget>[
                  new SliverAppBar(
                    expandedHeight: _height * .4,
                    pinned: true,
                    //title: Text("Hello"),
                    floating: false,
                    backgroundColor: Values.primaryColor,
                    //title: Text("Sliver Fab"),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Container(
                        width: width,
                        child: Text(
                          "SliverFab Example",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(<Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: width * .2, horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 10.0),
                                      child: Text(
                                        details.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: width*.15),
                                      child: Text(details.user.name),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  "Why do you want to report this item?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, ),
                                ),
                              ),
                              Column(
                                children: reasons.map((r) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)),
                                    child: InkWell(
                                      onTap: () {
                                        ProductWebService().reportProduct(details.id, r);
                                        Navigator.pop(context);
                                      },
                                      child: ListTile(
                                        title: Text(r, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ))
                    ]),
                  ),
                ],
                floatingWidget: Container(
                  width: width * .4,
                  height: width * .4,
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
                      image: AdvancedNetworkImage(details.images[0].img,
                          useDiskCache: true),
                      loadingWidget: Image.asset(
                        "assets/icon_no_image.png",
                      ),
                      placeholder: Image.asset(
                        "assets/icon_no_image.png",
                      ),
                      width: width * .2,
                      height: width * .2,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                floatingPosition: FloatingPosition(
                    top: -width * .1,
                    left: (width / 2) - width * .2,
                    right: (width / 2) - width * .2),
              )),
    );
  }
}
