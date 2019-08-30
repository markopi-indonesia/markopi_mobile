import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:markopi_mobile/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/resources/repository.dart';

class EditProfileDialog extends StatefulWidget {
  final String userID;
  EditProfileDialog({this.userID});
  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  var _repository = Repository();
  final _formEditProfileKey = GlobalKey<FormState>();
  String _userID;
  String _nama;
  String _role;
  String _photoUrl;
  String _profesi;
  String _noHP;
  String _provinsi;
  String _kabupaten;
  String _kecamatan;
  String _alamat;
  String _bio;
  String _docID;
  String _errorMessage;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _photoUrlController = TextEditingController();
  TextEditingController _profesiController = TextEditingController();
  TextEditingController _noHPController = TextEditingController();
  TextEditingController _provinsiController = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  FirebaseUser currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;

  bool _isIos;
  bool _isLoading;
  Image image;

  bool _validateAndSave() {
    final form = _formEditProfileKey.currentState;
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

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        print(_nama);
        print(_docID);
        // ProfileController.updateProfile(_docID, _nama, _profesi, _noHP,
        //     _provinsi, _kabupaten, _kecamatan, _alamat, _bio);

        await Firestore.instance
            .collection('profile')
            .document(_docID)
            .updateData({
          "nama": _nama,
          "profesi": _profesi,
          "noHP": _noHP,
          "provinsi": _provinsi,
          "kabupaten": _kabupaten,
          "kecamatan": _kecamatan,
          "alamat": _alamat,
          "bio": _bio
        });
        Navigator.pop(context);
        _showUpdateSuccess();
        setState(() {
          _isLoading = false;
        });
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

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currentUser = user;
          _userID = user?.uid;
        }
      });
    });

    Firestore.instance
        .collection('profile')
        .where("userID", isEqualTo: widget.userID)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => [
              _docID = doc.documentID,
              _namaController.text = doc["nama"],
              _photoUrlController.text = doc["photoURL"],
              _profesiController.text = doc["profesi"],
              _noHPController.text = doc["noHP"],
              _provinsiController.text = doc["provinsi"],
              _kabupatenController.text = doc["kabupaten"],
              _kecamatanController.text = doc["kecamatan"],
              _alamatController.text = doc["alamat"],
              _bioController.text = doc["bio"]
            ]));
    super.initState();
  }

  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  void _showUpdateSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Perubahan Profil"),
          content: new Text("Perubahan profil yang anda lakukan berhasil"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: HeaderBack(),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showForm() {
    return new Form(
        key: _formEditProfileKey,
        child: ListView(
          children: <Widget>[
            new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                              width: 110.0,
                              height: 110.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                image: DecorationImage(
                                    image: _photoUrlController.text.isEmpty
                                        ? AssetImage('assets/no_user.jpg')
                                        : NetworkImage(
                                            _photoUrlController.text),
                                    fit: BoxFit.cover),
                              )),
                        ),
                        onTap: _showImageDialog),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                        child: new RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          color: Color(0xFF2696D6),
                          child: new Text('Perbaharui Foto',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: _showImageDialog,
                        ),
                      ),
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Nama Anda",
                          labelText: "Nama Anda",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _namaController,
                      onSaved: (value) => _nama = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Profesi",
                          labelText: "Profesi",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _profesiController,
                      onSaved: (value) => _profesi = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "No. HP",
                          labelText: "No. HP",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _noHPController,
                      onSaved: (value) => _noHP = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Provinsi",
                          labelText: "Provinsi",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _provinsiController,
                      onSaved: (value) => _provinsi = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Kabupaten",
                          labelText: "Kabupaten",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _kabupatenController,
                      onSaved: (value) => _kabupaten = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Kecamatan",
                          labelText: "Kecamatan",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _kecamatanController,
                      onSaved: (value) => _kecamatan = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      maxLines: 6,
                      decoration: new InputDecoration(
                          hintText: "Alamat Lengkap",
                          labelText: "Alamat Lengkap",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _alamatController,
                      onSaved: (value) => _alamat = value,
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      maxLines: 6,
                      decoration: new InputDecoration(
                          hintText: "Biodata Diri",
                          labelText: "Biodata Diri",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                      controller: _bioController,
                      onSaved: (value) => _bio = value,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                        child: SizedBox(
                          height: 40.0,
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: Colors.green,
                            child: new Text('Ubah Profil',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: _validateAndSubmit,
                          ),
                        ))
                  ],
                )),
          ],
        ));
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Pilih dari galeri',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 17),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                      _isLoading = true;
                    });
                    // compressImage();
                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, currentUser.uid).then((v) {
                        print("masuk");
                        // setState(() {
                        //   _isLoading = true;
                        // });
                        // print("keluar");
                        setState(() {
                          _isLoading = false;
                        });
                        _showUploadDialog();
                        Navigator.pop(context);

                        // Navigator.of(context).pushNamed("/");
                      });
                    });
                  });
                },
              ),
              // SimpleDialogOption(
              //   child: Text('Take Photo'),
              //   onPressed: () {
              //     _pickImage('Camera').then((selectedImage) {
              //       setState(() {
              //         imageFile = selectedImage;
              //       });
              //       // compressImage();
              //       _repository.uploadImageToStorage(imageFile).then((url) {
              //         _repository.updatePhoto(url, currentUser.uid).then((v) {
              //           Navigator.pop(context);
              //         });
              //       });
              //     });
              //   },
              // ),
              SimpleDialogOption(
                child: Text(
                  'Batal',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  // void compressImage() async {
  //   print('starting compression');
  //   Directory tempDir = await getTemporaryDirectory();
  //   String path = tempDir.path;
  //   int rand = Random().nextInt(10000);

  //   Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
  //   Im.copyResize(image);

  //   var newim2 = new File('$path/img_$rand.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

  //   setState(() {
  //     imageFile = newim2;
  //   });
  //   print('done');
  // }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Upload Berhasil"),
          content: new Text("Upload foto berhasil dilakukan"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
