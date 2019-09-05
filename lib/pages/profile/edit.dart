import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
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
  String _nama;
  String _profesi;
  String _noHP;
  String _provinsi;
  String _kabupaten;
  String _kecamatan;
  String _alamat;
  String _bio;
  String _docID;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _photoUrlController = TextEditingController();
  TextEditingController _profesAvatartroller = TextEditingController();
  TextEditingController _noHPController = TextEditingController();
  TextEditingController _provinsAvatartroller = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  FirebaseUser currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  bool _isLoading;
  Image image;

  List<AssetImage> listAvatars = [];

  String currentAsset;

  void _setAvatar(String asset) => setState(() {
        currentAsset = asset;
        Navigator.of(context).pop(asset);
        _repository.updatePhoto(currentAsset, currentUser.uid).then((v) {
          setState(() {
            _isLoading = false;
          });
          _showUploadDialog();
          Navigator.pop(context);
        });
      });

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
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
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
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadAvatarAsset() {
    setState(() {
      listAvatars.add(AssetImage('assets/avatars/1.png'));
      listAvatars.add(AssetImage('assets/avatars/2.png'));
      listAvatars.add(AssetImage('assets/avatars/3.png'));
      listAvatars.add(AssetImage('assets/avatars/4.png'));
      listAvatars.add(AssetImage('assets/avatars/5.png'));
      listAvatars.add(AssetImage('assets/avatars/6.png'));
    });
  }

  @override
  void initState() {
    _isLoading = false;
    _loadAvatarAsset();
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currentUser = user;
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
              _profesAvatartroller.text = doc["profesi"],
              _noHPController.text = doc["noHP"],
              _provinsAvatartroller.text = doc["provinsi"],
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
                                    image: _photoUrlController.text
                                            .contains("assets")
                                        ? AssetImage(_photoUrlController.text)
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
                      controller: _profesAvatartroller,
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
                      controller: _provinsAvatartroller,
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

                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, currentUser.uid).then((v) {
                        setState(() {
                          _isLoading = false;
                        });
                        _showUploadDialog();
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Pilih dari daftar avatar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _changeAvatar();
                },
              ),
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

  void _changeAvatar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Pilih Avatar Anda",
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                      )))),
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: AspectRatio(
            aspectRatio: 12 / 20,
            child: GridView.builder(
                padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                itemCount: listAvatars.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _setAvatar(listAvatars[index].assetName.toString());
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      color: Color(0xffE3EFFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Image(
                              image: listAvatars[index],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }

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
