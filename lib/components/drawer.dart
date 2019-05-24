import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Self import
import 'package:markopi_mobile/models/profile.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

enum AuthStatus {
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _DrawerPageState extends State<DrawerPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String _userId = "";
  ProfileModel _profile;
  String nama = "";
  String image = "";
  String email;

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      if (user != null) {
        this.retrieveUserDetails(user).then((profile) {
          setState(() {
            if (profile != null) {
              nama = profile.nama;
              image = profile.photoUrl;
              print(nama);
              print(image);
            }
          });
        });
      }
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          email = user.email;
          // print(_userId);
          print(email);
          // retrieveUserDetails();
          // print(_profile.nama);
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    super.initState();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<ProfileModel> retrieveUserDetails(FirebaseUser user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection("profile").document(user.uid).get();
    ProfileModel profile = ProfileModel.fromMap(_documentSnapshot.data);
    return profile;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  _signOut() async {
    try {
      _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return Drawer(
          child: new ListView(
            children: <Widget>[
//            header
              new UserAccountsDrawerHeader(
                accountName: Text('Belum Masuk'),
                accountEmail: Text('Belum Masuk'),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: new BoxDecoration(color: Colors.yellow.shade900),
              ),

//            body
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/");
                },
                child: ListTile(
                  title: Text('Beranda'),
                  leading: Icon(Icons.home),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/login");
                },
                child: ListTile(
                  title: Text('Masuk'),
                  leading: Icon(Icons.dashboard),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/register");
                },
                child: ListTile(
                  title: Text('Daftar'),
                  leading: Icon(Icons.person_add),
                ),
              ),
            ],
          ),
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return Drawer(
            child: new ListView(
              children: <Widget>[
//            header
                new UserAccountsDrawerHeader(
                  accountName: Text(nama),
                  accountEmail: Text(email),
                  currentAccountPicture: GestureDetector(
                    child: new CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: image.isEmpty
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.laptop,
                            color: Colors.red,
                          ),
                    ),
                  ),
                  decoration: new BoxDecoration(color: Colors.yellow.shade900),
                ),

//            body
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/");
                  },
                  child: ListTile(
                    title: Text('Beranda'),
                    leading: Icon(Icons.home),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/category");
                  },
                  child: ListTile(
                    title: Text('Kategori'),
                    leading: Icon(Icons.category),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/informasi");
                  },
                  child: ListTile(
                    title: Text('Informasiku'),
                    leading: Icon(Icons.info),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/profile");
                  },
                  child: ListTile(
                    title: Text('Ubah Profil'),
                    leading: Icon(Icons.settings),
                  ),
                ),

                InkWell(
                  onTap: () {
                    this._signOut();
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/");
                  },
                  child: ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.exit_to_app),
                  ),
                ),
              ],
            ),
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
