import 'dart:io';

import 'package:deal/ui/post_ui/photo_picker.dart';
import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';

class PhotosList extends StatefulWidget {
  createState() => _PhotosListState();
}

class _PhotosListState extends State<PhotosList> {
  List<Map<String, dynamic>> _photos = List();
  List<Widget> _thumbs = List();
  Map<String, dynamic> _selectedPhoto = Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _thumbs.add(_photo());
  }

  Widget _thumbnail(Map<String, dynamic> asset) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPhoto = asset;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
          child: asset.containsKey('thumb')
              ? Image.memory(
                  asset['thumb'],
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(
                    asset['path'],
                  ),
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _photo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhotoPickerScreen(
                      photos: _photos,
                      onPhotosSectectedChaned: (photos) {
                        setState(() {
                          _photos
                            ..clear()
                            ..addAll(photos);
                          _thumbs.clear();
                          photos.forEach(
                              (asset) => _thumbs.add(_thumbnail(asset)));
                          _thumbs.add(_photo());
                          _selectedPhoto = Map();
                          if (!photos.isEmpty) _selectedPhoto = photos[0];
                        });
                      },
                    ))),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.grey,
      height: Dimens.Height * .4,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: _selectedPhoto.isNotEmpty
                ? Image.file(
                    File(_selectedPhoto['path']),
                    width: Dimens.Width,
                    height: Dimens.Height * .4,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.photo,
                    size: Dimens.Width * .5,
                    color: Colors.black45,
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.black26,
              ),
              child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _thumbs,
                      ),
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => print('hel'),
              child: Container(
                color: Colors.black45,
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
