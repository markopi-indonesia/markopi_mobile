import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/resources/repository.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';

class EditInformasiDialog extends StatefulWidget {
  final String documentID;
  final String categoryID;
  final String cover;
  final String deskripsi;
  final String images;
  final String ownerRole;
  final String title;
  final String userID;
  final String video;

  EditInformasiDialog(
      {this.documentID,
      this.categoryID,
      this.cover,
      this.deskripsi,
      this.images,
      this.ownerRole,
      this.title,
      this.userID,
      this.video});
  @override
  _EditInformasiDialogState createState() => _EditInformasiDialogState();
}

class _EditInformasiDialogState extends State<EditInformasiDialog> {
  var _repository = Repository();
  final _formAddCategoryKey = GlobalKey<FormState>();
  String categoryID;
  String cover;
  String deskripsi;
  String images;
  String ownerRole;
  String title;
  String userID;
  String video;
  String _mySelection;
  String _errorMessage;
  String _photoUrl;
  String _videoUrl;
  String _error;
  FirebaseUser currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  StorageReference _storageReference;

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

  File imageFile;
  File videoFile;
  List<File> _imageList = [];
  File _image;
  String urls = "";
  List<Asset> image = List<Asset>();

  Future<void> loadAssets() async {
    setState(() {
      image = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      image = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

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
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        updateInformasi();

        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        Navigator.of(context).pushNamed("/informasi");
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void updateInformasi() async {
    // final docRef = await Firestore.instance.collection('informasi').add({
    //   'title': title,
    //   'deskripsi': deskripsi,
    //   "categoryID": categoryID,
    //   'userID': userID,
    //   'ownerRole': ownerRole,
    //   'cover': '',
    //   'images': '',
    //   'video': ''
    // });
    CollectionReference reference = Firestore.instance.collection('informasi');
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(widget.documentID).updateData({
        'title': title,
        'deskripsi': deskripsi,
        "categoryID": categoryID,
        'userID': userID,
        'ownerRole': ownerRole,
        'cover': cover,
        'images': images,
        'video': video,
      }).catchError((error) {
        print(error);
      });
    });
    if (imageFile != null) {
      _repository.uploadImageToStorage(imageFile).then((url) {
        _repository.addPhoto(url, widget.documentID).then((v) {});
      });
    }
    if (image != null) {
      image.forEach((f) {
        _repository.saveImage(f).then((url) {
          if (urls.isEmpty) {
            urls = url;
          } else {
            urls = urls + ";" + url;
          }
          print(urls);
          print("masuk");
          _repository.addImage(urls, widget.documentID).then((v) {});
        });
      });
    }
    if (videoFile != null) {
      _repository.uploadVideoToStorage(videoFile).then((url) {
        _repository.addVideo(url, widget.documentID).then((v) {});
      });
    }
    Navigator.pop(context);
    Navigator.of(context).pushNamed("/informasi");
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;

    setState(() {
      categoryID = widget.categoryID;
      cover = widget.cover;
      deskripsi = widget.deskripsi;
      images = widget.images;
      ownerRole = widget.ownerRole;
      title = widget.title;
      userID = widget.userID;
      video = widget.video;
    });
    super.initState();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
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
                            "Form Ubah Informasi",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Judul",
                              labelText: "Judul",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          initialValue: widget.title,
                          validator: (value) =>
                              value.isEmpty ? 'Judul tidak boleh kosong' : null,
                          onSaved: (value) => title = value,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        GestureDetector(
                          // child: Padding(
                          //   padding: const EdgeInsets.only(top: 12.0),
                          //   child: Text('Perbaharui Cover',
                          //       style: TextStyle(
                          //           color: Colors.green,
                          //           fontSize: 20.0,
                          //           fontWeight: FontWeight.bold)),
                          // ),
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: Colors.lightGreen,
                            child: new Text('Perbaharui Cover',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: _showImageDialog,
                          ),
                          // onTap: _showImageDialog,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 10.0)),
                        new FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                errorText:
                                    state.hasError ? state.errorText : null,
                              ),
                              isEmpty: categoryID == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  isDense: true,
                                  hint: new Text("Perbharui Kategori"),
                                  value: _mySelection,
                                  onChanged: (String newValue) {
                                    state.didChange(newValue);
                                    setState(() {
                                      _mySelection = newValue;
                                    });
                                  },
                                  items: snapshot.data.documents.map((map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.documentID.toString(),
                                      child: new Text(
                                        map["name"],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          initialValue: widget.categoryID,
                          validator: (_mySelection) {
                            if (_mySelection == null) {
                              return "Kategori tidak boleh kosong";
                            }
                          },
                          onSaved: (value) => categoryID = value,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          maxLines: 10,
                          decoration: new InputDecoration(
                              hintText: "Deskripsi",
                              labelText: "Deskripsi",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          initialValue: widget.deskripsi,
                          validator: (value) => value.isEmpty
                              ? 'Deskripsi tidak boleh kosong'
                              : null,
                          onSaved: (value) => deskripsi = value,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        GestureDetector(
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: Colors.lightGreen,
                            child: new Text('Perbaharui Gambar',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: loadAssets,
                          ),
                          // onTap: loadAssets,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        GestureDetector(
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: Colors.lightGreen,
                            child: new Text('Perbaharui Video',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: _showVideoDialog,
                          ),
                          // onTap: _showVideoDialog,
                        ),
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
                                child: new Text('Simpan',
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

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                      // _isLoading = true;
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showVideoDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
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
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }
}
