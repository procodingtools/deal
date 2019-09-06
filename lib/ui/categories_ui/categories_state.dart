import 'package:deal/entities/category.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesScreen extends StatefulWidget {
  final Function(CategoryEntity category, CategoryEntity subCat) catgoryCallback;

  const CategoriesScreen({Key key, this.catgoryCallback})
      : super(key: key);

  createState() => _CategoriesState();

}

class _CategoriesState extends State<CategoriesScreen>{

  List<CategoryEntity> _categories = List.from(AppData.Categories);
  bool _isSetToSub = false;
  CategoryEntity _mainCat, _subCat;


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (_isSetToSub){
          setState(() {
            _isSetToSub = false;
            _categories = List.from(AppData.Categories);
          });
        }else {
          return Future.value(true);
        }
      },
      child: Scaffold(
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.3),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return InkWell(
                onTap: () {
                  if (!_isSetToSub){
                    _mainCat = cat;
                  } else {
                    _subCat = cat;
                  }

                 if(cat.subCategory == null || cat.subCategory.isEmpty){
                   if (widget.catgoryCallback != null)
                     widget.catgoryCallback(_mainCat, _subCat);
                   Navigator.pop(context);
                 }else
                   setState(() {
                     _categories = List.from(cat.subCategory);
                     _isSetToSub = true;
                   });
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: Colors.grey.withOpacity(.5), width: .3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TransitionToImage(
                        image: AdvancedNetworkImage(cat.img),
                        loadingWidget: SizedBox(
                          width: Dimens.Width * .07,
                          height: Dimens.Width * .07,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: Container(
                              width: Dimens.Width * .07,
                              height: Dimens.Width * .07,
                              color: Colors.grey.withOpacity(.4),
                            ),
                          ),
                        ),
                        width: Dimens.Width * .07,
                        height: Dimens.Width * .07,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(cat.label),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: _categories.length,
          )),
    );
  }
}
