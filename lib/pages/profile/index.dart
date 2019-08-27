import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:markopi_mobile/pages/profile/edit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:markopi_mobile/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/resources/repository.dart';

class IndexProfileDialog extends StatefulWidget {
  final String userID;
  IndexProfileDialog({this.userID});
  @override
  _IndexProfileDialogState createState() => _IndexProfileDialogState();
}

class _IndexProfileDialogState extends State<IndexProfileDialog> {
  var _repository = Repository();
  final _ProfileKeyPage = GlobalKey<ScaffoldState>();
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

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
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
        appBar: Header(),
        drawer: DrawerPage(),
        body: Stack(
          children: <Widget>[
            _build(context),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _build(BuildContext context) {
    return new Scaffold(
        key: _ProfileKeyPage,
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.blueGrey.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
              width: 350.0,
              top: MediaQuery.of(context).size.height / 9,
              child: new Column(children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                        width: 140.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            image: DecorationImage(
                                image: _photoUrlController.text.isEmpty
                                    ? AssetImage('assets/no_user.jpg')
                                    : NetworkImage(_photoUrlController.text),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.white)
                            ])),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  _namaController.text,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Montserrat'),
                ),
                Text(
                  _profesiController.text,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),

                Text(
                  _noHPController.text,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),

                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Provinsi:  ",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                        Text(_provinsiController.text,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Montserrat')),
                      ],
                    ),
                    Column(children: <Widget>[
                      Text(
                        "Kabupaten:  ",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      Text(
                        _kabupatenController.text,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Montserrat'),
                      ),
                    ]),
                    Column(children: <Widget>[
                      Text(
                        "Kecamatan:  ",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      Text(
                        _kecamatanController.text,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Montserrat'),
                      ),
                    ]),
                  ],
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
                          child: new Text('Ubah Profile',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileDialog()),
                            );
                          }),
                      // )
                    )
                    // ]
                    ),
              ]),
            ),
          ],
        ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width + 120, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

// https://www.youtube.com/watch?v=GwENgFQo0Qg
