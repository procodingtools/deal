import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class SoldDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: Dimens.Width*.7,
      height: Dimens.Height*.3,
      child: Center(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
                child: Card(
                  color: Colors.white54,
                  child: SizedBox(
                    width: Dimens.Width*.8,
                    height: Dimens.Height*.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("Item Sold", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17.0),),
                        ),

                        Text("This item has been sold", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(color: Values.primaryColor, shape: BoxShape.circle,),
                padding: EdgeInsets.all(3.0),
                child: Icon(Icons.info, color: Colors.white, size: 40.0,),
              ),
            )
          ],
        ),
      ),
    );
  }

}