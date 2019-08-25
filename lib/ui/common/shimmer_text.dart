import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText extends StatelessWidget{

  final double width, height;

  const ShimmerText({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(child: Container(
      width: width??40.0,
      margin: EdgeInsets.only(bottom: 8.0),
      height: height??15.0,
      color: Colors.grey,
    ), baseColor: Colors.grey.withOpacity(.4), highlightColor: Colors.white);;
  }

}