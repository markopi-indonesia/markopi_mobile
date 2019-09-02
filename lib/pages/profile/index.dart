import 'dart:async';
import 'dart:io';
import 'package:markopi_mobile/pages/profile/edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IndexProfileDialog extends StatefulWidget {
  final String userID;
  IndexProfileDialog({this.userID});
  @override
  _IndexProfileDialogState createState() => _IndexProfileDialogState();
}

class _IndexProfileDialogState extends State<IndexProfileDialog> {
  String _docID;
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
    _isLoading = false;
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
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.blueGrey.withOpacity(0.8)),
          clipper: GetClipper(),
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
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
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
                  fontFamily: 'SF Pro Text'),
            ),
            Text(
              _profesiController.text,
              style: TextStyle(
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'SF Pro Text'),
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
                          fontFamily: 'SF Pro Text'),
                    ),
                    Text(_provinsiController.text,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'SF Pro Text')),
                  ],
                ),
                Column(children: <Widget>[
                  Text(
                    "Kabupaten:  ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Text'),
                  ),
                  Text(
                    _kabupatenController.text,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'SF Pro Text'),
                  ),
                ]),
                Column(children: <Widget>[
                  Text(
                    "Kecamatan:  ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Text'),
                  ),
                  Text(
                    _kecamatanController.text,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'SF Pro Text'),
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
                      color: Color(0xFF2696D6),
                      child: new Text('Ubah Profil',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileDialog(
                                    userID: _docID,
                                  )),
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

class GetClipper extends CustomClipper<Path> {
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
    return true;
  }
}
