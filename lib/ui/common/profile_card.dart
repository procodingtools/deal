import 'package:date_format/date_format.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class DetailsProfileCard extends StatelessWidget {
  final bool isLoading;
  final UserEntity user;
  final Widget navigateTo;
  final ProductDetailsEntity product;
  final DateTime createdAt;

  const DetailsProfileCard(
      {Key key,
      this.isLoading,
      this.user,
      this.navigateTo,
      this.product,
      this.createdAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return InkWell(
      onTap: () => navigateTo != null ? Navigator.push(
          context, MaterialPageRoute(builder: (context) => navigateTo)) : null,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 50.0,
                      top: product != null ? 10.0 : 30.0,
                      bottom: product != null ? 10.0 : 30.0,
                      right: 10.0),
                  child: Row(
                    children: <Widget>[
                      !isLoading
                          ? LimitedBox(
                            maxWidth: product != null ? Dimens.Width * .45 : Dimens.Width * .4,
                        child: _userName(),
                      )
                          : ShimmerText(
                              width: 50.0,
                              height: 15.0,
                            ),
                      Expanded(child: Container()),
                      product == null ? _userRating() : Container(),
                      product == null ? _share() : Container(),
                      product != null ? _ProductWidget(product: product, createdAt: createdAt,) : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _userPhoto(),
            ),
          )
        ],
      ),
    );
  }

  Widget _userPhoto() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Values.primaryColor, width: .5),
          shape: BoxShape.circle),
      padding: EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500.0),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Color(0xffD2D7DB)),
          child: TransitionToImage(
            loadingWidget: Image.asset(
              "assets/icon_profile_default.png",
              width: 70.0,
            ),
            placeholder: Image.asset(
              "assets/icon_profile_default.png",
              width: 70.0,
            ),
            image: AdvancedNetworkImage(user?.thumb ?? "null",
                //useDiskCache: true,
                cacheRule: CacheRule(maxAge: Duration(days: 10)),
                header: AppData.Headers),
            width: 70.0,
            borderRadius: BorderRadius.circular(double.infinity),
            height: 70.0,
          ),
        ),
      ),
    );
  }

  Widget _userRating() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Values.ratingColor,
        ),
        Text(
          " ${user?.rating ?? .0}",
          style: TextStyle(color: Values.ratingColor),
        )
      ],
    );
  }

  Widget _share() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Icon(
        Icons.share,
        color: Colors.grey,
      ),
    );
  }

  Widget _userName() {
    return product == null ? Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          product.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}


class _ProductWidget extends StatefulWidget{
  final ProductDetailsEntity product;
  final DateTime createdAt;

  const _ProductWidget({Key key, this.product, this.createdAt}) : super(key: key);
  createState() => _ProductState();
}

class _ProductState extends State<_ProductWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Values.primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(1.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TransitionToImage(
              placeholder: Container(
                color: Colors.grey,
              ),
              loadingWidget: Container(
                color: Colors.grey,
              ),
              image: NetworkImage(
                widget.product.img,
                //useDiskCache: false,
                headers: AppData.Headers,
              ),
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          formatDate(widget.createdAt, [M, ' ', dd]),
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

}
