import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/resources/repository.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:markopi_mobile/components/header_back.dart';

class AddInformasiDialog extends StatefulWidget {
  final String menuID;
  final String subMenuID;

  AddInformasiDialog({
    this.menuID,
    this.subMenuID,
  });
  @override
  _AddInformasiDialogState createState() => _AddInformasiDialogState();
}

class _AddInformasiDialogState extends State<AddInformasiDialog> {
  var _repository = Repository();
  final _formAddInformasiKey = GlobalKey<FormState>();
  String title;
  String deskripsi;
  String _videoUrl;
  String menuName;
  String subMenuName;
  FirebaseUser currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userID = "";
  String ownerRole = "";
  bool _isLoading;

  bool _validateAndSave() {
    final form = _formAddInformasiKey.currentState;
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
  String urls = "";
  List<Asset> images = List<Asset>();

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
      );
    } on PlatformException {} on NoImagesSelectedException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  void _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        addInformasi();
        setState(() {
          _isLoading = false;
        });
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

  void addInformasi() async {
    final docRef = await Firestore.instance.collection('informasi').add({
      'title': title,
      'menuID': widget.menuID,
      'menuName': menuName,
      'subMenuID': widget.subMenuID,
      'subMenuName': subMenuName,
      'deskripsi': deskripsi,
      'userID': userID,
      'images': '',
      'video': _videoUrl
    });
    if (images != null) {
      images.forEach((f) {
        _repository.saveImage(f).then((url) {
          if (urls.isEmpty) {
            urls = url;
          } else {
            urls = urls + ";" + url;
          }
          print(urls);
          print("masuk");
          _repository.addImage(urls, docRef.documentID).then((v) {});
        });
      });
    }
  }

  @override
  void initState() {
    _isLoading = false;
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currentUser = user;
          userID = user?.uid;
        }
      });
    });
    Firestore.instance
        .collection('menu')
        .document(widget.menuID)
        .get()
        .then((menu) {
      setState(() {
        menuName = menu.data['name'];
      });
    });
    Firestore.instance
        .collection('submenu')
        .document(widget.subMenuID)
        .get()
        .then((submenu) {
      setState(() {
        subMenuName = submenu.data['name'];
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
      key: _formAddInformasiKey,
      autovalidate: false,
      child: new Container(
          padding: new EdgeInsets.all(10.0),
          child: new ListView(
            children: <Widget>[
              new Center(
                child: Text("Form Tambah Informasi",
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xFF3B444F))),
              ),
              new Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Align(
                alignment: Alignment.topLeft,
                child: new Text("Judul",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Color(0xFF3B444F))),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                    hintText: "Judul",
                    labelText: "Judul",
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0))),
                validator: (value) =>
                    value.isEmpty ? 'Judul tidak boleh kosong' : null,
                onSaved: (value) => title = value,
              ),
              new Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Align(
                alignment: Alignment.topLeft,
                child: new Text("Deskripsi",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Color(0xFF3B444F))),
              ),
              new TextFormField(
                maxLines: 10,
                decoration: new InputDecoration(
                    // hintText:
                    //     "Contoh:\n ##Tujuan\n- Untuk meningkatkan kadar humus pada tanah\n- Untuk menambah nutrisi pada kopi\n##Caranya:\n- Mengukur lubang tanam 30x30 cm",
                    hintText: "Deskripsi",
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0))),
                validator: (value) =>
                    value.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                onSaved: (value) => deskripsi = value,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: SizedBox(
                  height: 43.0,
                  width: 420.0,
                  child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0)),
                    color: Color(0xFFABDCFF),
                    // child: new Image.asset('assets/camera.png'),
                    child: new Text('Tambah Gambar',
                        style: new TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 15.0,
                            color: Color(0xFF3B444F))),
                    onPressed: loadAssets,
                  ),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Align(
                alignment: Alignment.topLeft,
                child: new Text("URL Video Youtube",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Color(0xFF3B444F))),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                    hintText: "Masukkan URL Video Youtube",
                    labelText: "URL Video Youtube",
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0))),
                validator: (value) =>
                    value.isEmpty ? 'URL Video tidak boleh kosong' : null,
                onSaved: (value) => _videoUrl = value,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      color: Color(0xFF2696D6),
                      child: new Text('Simpan Informasi',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () => _validateAndSubmit(),
                    ),
                  )),
            ],
          )),
    );
  }
}
