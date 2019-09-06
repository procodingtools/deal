import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoPickerScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onPhotosSectectedChaned;
  final List<Map<String, dynamic>> photos;

  const PhotoPickerScreen(
      {Key key, @required this.onPhotosSectectedChaned, @required this.photos})
      : super(key: key);

  createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPickerScreen> {
  CameraDescription _cam;
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;
  List<Map<String, dynamic>> _photos = List();
  List<Map<String, dynamic>> _selectedPhotos = List();
  String _tmpDir;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    availableCameras().then((cam) {
      setState(() {
        _cam = cam.first;
        _cameraController = CameraController(_cam, ResolutionPreset.ultraHigh);
        _initializeControllerFuture = _cameraController.initialize();
      });
    });

    _selectedPhotos.addAll(widget.photos);

    getPictures();

    getTemporaryDirectory().then((dir) {
      _tmpDir = dir.path;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Choice Image'),
        backgroundColor: Values.primaryColor,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _cameraPreview(),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _tabsView(),
                _selectedPhotosPreview(),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _removeSelectedPhoto(final asset) {
    for (final photo in _selectedPhotos) {
      if (photo['path'] == asset['path']) {
        setState(() {
          _selectedPhotos.remove(photo);
        });
        break;
      }
    }
  }

  Widget _imageItem(final asset) {
    return InkWell(
      onTap: () {
        if (_selectedPhotosContains(asset))
          setState(() {
            _removeSelectedPhoto(asset);
            widget.onPhotosSectectedChaned(_selectedPhotos);
          });
        else {
          if (_selectedPhotos.length < 5)
            setState(() {
              _selectedPhotos.add(asset);
              widget.onPhotosSectectedChaned(_selectedPhotos);
            });
          else
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("You can upload only 5 photos"),
              ),
              action: SnackBarAction(label: "Dismiss",
                onPressed: () =>
                    _scaffoldKey.currentState.hideCurrentSnackBar(
                        reason: SnackBarClosedReason.dismiss),),));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: _photos.isEmpty
                    ? CircularProgressIndicator()
                    : Image.memory(
                  asset['thumb'],
                  width: Dimens.Width/3,
                  height: Dimens.Width/3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _selectedPhotosContains(asset)
                ? Container(
              decoration: BoxDecoration(color: Colors.black45),
              width: double.infinity,
              height: double.infinity,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  bool _selectedPhotosContains(final asset) {
    bool contains = false;
    for (final photo in _selectedPhotos) {
      if (photo['path'] == asset['path']) {
        contains = true;
        print("$contains");
        break;
      }
    }
    return contains;
  }

  Future<void> getPictures() async {
    var result = await PhotoManager.requestPermission();
    if (!result)
      PhotoManager.openSetting();
    else {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
      AssetPathEntity data = list[
      0]; // 1st album in the list, typically the "Recent" or "All" album
      List<AssetEntity> imageList = await data.assetList;

      imageList.forEach((entity) async {
        File file = await entity.file;
        if (!file.path.substring(file.path.lastIndexOf("/")).contains(".mp4")) {
          Uint8List thumbBytes = await entity.thumbDataWithSize(100, 100);
          setState(() {
            _photos.add({"path": file.path, "thumb": thumbBytes});
          });
        }
      });
    }
  }

  Widget _cameraPreview() {
    return _cameraController != null
        ? FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Transform.scale(
              scale: 1.4,
              child: new Center(
                child: new AspectRatio(
                    aspectRatio:
                    _cameraController.value?.aspectRatio ?? 1.0,
                    //height: 200.0,
                    child: new CameraPreview(_cameraController)),
              ));
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    )
        : CircularProgressIndicator();
  }

  Widget _tabsView() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Camera",
                ),
                Tab(
                  text: "Gallery",
                ),
              ],
              indicatorColor: Values.primaryColor,
              indicatorWeight: 5.0,
              labelColor: Values.primaryColor,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: TabBarView(children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FloatingActionButton(
                    backgroundColor: Color(0xff5c6bc0),
                    elevation: .0,
                    child: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      String path =
                          "$_tmpDir/${DateTime
                          .now()
                          .millisecond}.jpg";
                      _cameraController.takePicture(path).then((_) {
                        setState(() {
                          if (_selectedPhotos.length < 5) {
                            _selectedPhotos.add({'path': path});
                            widget.onPhotosSectectedChaned(_selectedPhotos);
                          }else _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("You can upload only 5 photos"),
                            ),
                            action: SnackBarAction(label: "Dismiss",
                              onPressed: () =>
                                  _scaffoldKey.currentState.hideCurrentSnackBar(
                                      reason: SnackBarClosedReason.dismiss),),));
                        });
                      });
                    }),
              ),
            ),
            Material(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  final asset = _photos[index];
                  return _imageItem(asset);
                },
                itemCount: _photos.length,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _selectedPhotosPreview() {
    print(_selectedPhotos.length);
    return Container(
      height: Dimens.Height * .2,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _selectedPhotos.map((asset) {
              return Container(
                //color: Colors.red,
                  height: Dimens.Width / 5,
                  width: Dimens.Width / 5,
                  padding: EdgeInsets.only(right: 10.0),
                  child: Stack(
                    children: <Widget>[
                      asset.containsKey('thumb')
                          ? Image.memory(
                        asset['thumb'],
                        fit: BoxFit.cover,
                        height: Dimens.Width / 5,
                        width: Dimens.Width / 5,
                      )
                          : Image.file(
                        File(asset['path']),
                        fit: BoxFit.cover,
                        height: Dimens.Width / 5,
                        width: Dimens.Width / 5,
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              child: Container(
                                  color: Colors.white54,
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(Icons.clear)),
                              onTap: () =>
                                  setState(() =>
                                      _selectedPhotos.remove(asset))))
                    ],
                  ));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
