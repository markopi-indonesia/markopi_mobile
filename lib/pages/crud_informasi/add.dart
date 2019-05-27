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

class AddInformasiDialog extends StatefulWidget {
  @override
  _AddInformasiDialogState createState() => _AddInformasiDialogState();
}

class _AddInformasiDialogState extends State<AddInformasiDialog> {
  var _repository = Repository();
  final _formAddCategoryKey = GlobalKey<FormState>();
  String title;
  String categoryID;
  String deskripsi;
  String _mySelection;
  String _errorMessage;
  String _photoUrl;
  String _videoUrl;
  String _error;
  FirebaseUser currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userID = "";
  String ownerRole = "";
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
  List<Asset> images = List<Asset>();

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
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
      images = resultList;
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
        Firestore.instance
            .collection('profile')
            .where("userID", isEqualTo: userID)
            .snapshots()
            .listen((data) => data.documents.forEach((doc) => setState(() {
                  ownerRole = doc["role"];
                  print(ownerRole);
                  addInformasi();
                })));
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
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

  void addInformasi() async {
    final docRef = await Firestore.instance.collection('informasi').add({
      'title': title,
      'deskripsi': deskripsi,
      "categoryID": categoryID,
      'userID': userID,
      'ownerRole': ownerRole,
      'cover': '',
      'images': '',
      'video': ''
    });
    print(docRef.documentID);
    _repository.uploadImageToStorage(imageFile).then((url) {
      _repository.addPhoto(url, docRef.documentID).then((v) {});
    });
    images.forEach((f) {
      _repository.saveImage(f).then((url) {
        if(urls.isEmpty){
          urls = url;  
        }else{
          urls = urls + ";" + url;
        }
        print(urls);
        print("masuk");
        _repository.addImage(urls, docRef.documentID).then((v) {});
      });
    });
    _repository.uploadVideoToStorage(videoFile).then((url) {
      _repository.addVideo(url, docRef.documentID).then((v) {});
    });
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currentUser = user;
          userID = user?.uid;
        }
      });
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
                        new Center(child: Text("Form Tambah Informasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Judul",
                              labelText: "Judul",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          validator: (value) =>
                              value.isEmpty ? 'Judul tidak boleh kosong' : null,
                          onSaved: (value) => title = value,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text('Tambah Cover',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          onTap: _showImageDialog,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
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
                                  hint: new Text("Pilih Kategori"),
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
                          validator: (value) => value.isEmpty
                              ? 'Deskripsi tidak boleh kosong'
                              : null,
                          onSaved: (value) => deskripsi = value,
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text('Tambah Gambar',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          onTap: loadAssets,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text('Tambah Video',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          onTap: _showVideoDialog,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
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
                child: Text('Pilih dari Galeri'),
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
                child: Text('Batal'),
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
