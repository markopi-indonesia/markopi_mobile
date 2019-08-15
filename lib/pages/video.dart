import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/resources/repository.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:googleapis/youtube/v3.dart';

class AddVideoDialog extends StatefulWidget {
  @override
  _AddVideoDialogState createState() => _AddVideoDialogState();
}

class _AddVideoDialogState extends State<AddVideoDialog> {
  var _repository = Repository();
  final _formAddCategoryKey = GlobalKey<FormState>();
  String title;
  String _videoUrl;
  String _error;

  bool _isIos;
  bool _isLoading;

  bool _validateAndSave() {
    final form = _formAddCategoryKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  File videoFile;

  Future<File> _pickVideo(String action) async {
    File selectedVideo;

    action == 'Gallery'
        ? selectedVideo =
            await ImagePicker.pickVideo(source: ImageSource.gallery)
        : await ImagePicker.pickVideo(source: ImageSource.camera);

    return selectedVideo;
  }

  void _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        // Firestore.instance
        //     .collection('profile')
        //     .where("userID", isEqualTo: userID)
        //     .snapshots()
        //     .listen((data) => data.documents.forEach((doc) => setState(() {
        //           ownerRole = doc["role"];
        //           print(ownerRole);
        //           AddVideo();
        //         })));
        // setState(() {
        //   _isLoading = false;
        // });
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void AddVideo() async {
  //   final docRef = await Firestore.instance.collection('informasi').add({
  //     'title': title,
  //     'deskripsi': deskripsi,
  //     "categoryID": categoryID,
  //     'userID': userID,
  //     'ownerRole': ownerRole,
  //     'cover': '',
  //     'images': '',
  //     'video': ''
  //   });
  //   print(docRef.documentID);
  //   _repository.uploadImageToStorage(imageFile).then((url) {
  //     _repository.addPhoto(url, docRef.documentID).then((v) {});
  //   });
  //   images.forEach((f) {
  //     _repository.saveImage(f).then((url) {
  //       if (urls.isEmpty) {
  //         urls = url;
  //       } else {
  //         urls = urls + ";" + url;
  //       }
  //       print(urls);
  //       print("masuk");
  //       _repository.addImage(urls, docRef.documentID).then((v) {});
  //     });
  //   });
  //   _repository.uploadVideoToStorage(videoFile).then((url) {
  //     _repository.addVideo(url, docRef.documentID).then((v) {});
  //   });
  // }

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: HeaderBack(),
        // drawer: DrawerPage(),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showForm() {
    return new Form(
      key: _formAddCategoryKey,
      autovalidate: false,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('category').snapshots(),
          builder: (context, snapshot) {
            return new ListView(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Center(
                          child: Text(
                            "Form Tambah Video",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        GestureDetector(
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: Colors.lightGreen,
                            child: new Text('Tambah Video',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: _showVideoDialog,
                          ),
                        ),
                        // new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: SizedBox(
                              height: 40.0,
                              child: new RaisedButton(
                                elevation: 5.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                color: Colors.green,
                                child: new Text('Simpan Informasi',
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                                onPressed: _validateAndSubmit,
                              ),
                            ))
                      ],
                    )),
              ],
            );
          }),
    );
  }

  _showVideoDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Pilih dari Galeri'),
                onPressed: () {
                  Navigator.pop(context);
                  _pickVideo('Gallery').then((selectedVideo) {
                    setState(() {
                      videoFile = selectedVideo;
                      // _isLoading = true;
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }
}
