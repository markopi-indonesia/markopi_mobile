import 'package:flutter/cupertino.dart';
import 'package:markopi_mobile/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileDialog extends StatefulWidget {
  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
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
  TextEditingController _profesiController = TextEditingController();
  TextEditingController _noHPController = TextEditingController();
  TextEditingController _provinsiController = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;

  bool _isIos;
  bool _isLoading;

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
        ProfileController.updateProfile(_docID, _nama, _profesi, _noHP,
            _provinsi, _kabupaten, _kecamatan, _alamat, _bio);
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
          _userID = user?.uid;
        }
      });
    });
    Firestore.instance
        .collection('profile')
        .where("userID", isEqualTo: _userID)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => [
              _docID = doc.documentID,
              _namaController.text = doc["nama"],
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

  void _showUpdateSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Perubahan Profil"),
          content:
              new Text("Perubahan profil yang anda lakukan berhasil"),
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
        key: _formEditProfileKey,
        child: ListView(
          children: <Widget>[
            new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
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
                          hintText: "Bio",
                          labelText: "Bio",
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
                            color: Colors.blue,
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
}
