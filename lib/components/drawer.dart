import 'package:flutter/material.dart';

//Self import
import 'package:markopi_mobile/pages/authentication/login.dart';
import 'package:markopi_mobile/pages/authentication/register.dart';
import 'package:markopi_mobile/ui/menu/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String _userId = "";

  @override
  void initState(){
    super.initState();
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
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
                  leading: Icon(Icons.person),
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
                accountName: Text('Sudah Masuk'),
                accountEmail: Text('Sudah Masuk'),
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
                  Navigator.of(context).pushNamed("/category");
                },
                child: ListTile(
                  title: Text('Kategori'),
                  leading: Icon(Icons.home),
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
                  leading: Icon(Icons.person),
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
