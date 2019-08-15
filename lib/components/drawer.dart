import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:markopi_mobile/pages/profile/edit.dart';
import 'package:markopi_mobile/ui/menu/submenu.dart';

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
          print(_userId);
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
                accountName: Text(
                  "Markopi Indonesia",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // accountEmail: Text(
                //   email,
                //   style: TextStyle(color: Colors.white),
                // ),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                ),
                decoration: new BoxDecoration(
                  // borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                      image: AssetImage('assets/sanitasi.jpeg'),
                      fit: BoxFit.cover),
                ),
              ),

//            body
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/home");
                },
                child: ListTile(
                  title: Text('Beranda'),
                  leading: Icon(Icons.home),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-Lf-IJCL0QmHf83DChgw',
                                title: 'Pola Tanam',
                                image: Image.asset('assets/pola_tanam.jpeg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Pola Tanam'),
                  leading: Icon(Icons.label_important),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-Lf-ILm7heQeRarL3_xK',
                                title: 'Pohon Pelindung',
                                image: Image.asset(
                                    'assets/pohon_pelindung.jpeg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Pohon Pelindung'),
                  leading: Icon(Icons.label_important),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-Lf-IP4g0fmcAsGdD-Jq',
                                title: 'Pemupukan',
                                image: Image.asset('assets/pemupukan_kopi.jpg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Pemupukan'),
                  leading: Icon(Icons.label_important),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-Lf-IRsIeHX8E8SCo4xx',
                                title: 'Pemangkasan',
                                image: Image.asset('assets/pemangkasan.jpeg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Pemangkasan'),
                  leading: Icon(Icons.label_important),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-Lf-IWRvsCctVqZKDjkz',
                                title: 'Sanitasi Kebun',
                                image: Image.asset('assets/sanitasi.jpeg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Sanitasi Kebun'),
                  leading: Icon(Icons.label_important),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-Lf-IYZCDRmrigxLatxA',
                                title: 'Hama dan Penyakit',
                                image: Image.asset('assets/hama_penyakit.jpeg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Hama dan Penyakit'),
                  leading: Icon(Icons.label_important),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubMenu(
                                documentID: '-LfbN8xg2hXnvKcwGDCO',
                                title: 'Pembibitan',
                                image: Image.asset('assets/pembibitan.jpg',
                                    fit: BoxFit.cover),
                              )));
                },
                child: ListTile(
                  title: Text('Pembibitan'),
                  leading: Icon(Icons.label_important),
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
          if (_userId == "nAXShDzUG8UyJliQ4qim6xmrfXn2") {
            return Drawer(
              child: new ListView(
                children: <Widget>[
//            header
                  new UserAccountsDrawerHeader(
                    accountName: Text(
                      nama,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    accountEmail: Text(
                      email,
                      style: TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: GestureDetector(
                      child: new CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: image.isNotEmpty
                            ? NetworkImage(image)
                            : AssetImage('assets/no_user.jpg'),
                      ),
                    ),
                    decoration: new BoxDecoration(
                      // borderRadius: BorderRadius.circular(100.0),
                      image: DecorationImage(
                          image: AssetImage('assets/sanitasi.jpeg'),
                          fit: BoxFit.cover),
                    ),
                  ),

//            body
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/home");
                    },
                    child: ListTile(
                      title: Text('Beranda'),
                      leading: Icon(Icons.home),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/video");
                    },
                    child: ListTile(
                      title: Text('Tambah Video'),
                      leading: Icon(Icons.videocam),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/menu");
                    },
                    child: ListTile(
                      title: Text('Menu'),
                      leading: Icon(Icons.more),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IJCL0QmHf83DChgw',
                                    title: 'Pola Tanam',
                                    image: Image.asset('assets/pola_tanam.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pola Tanam'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-ILm7heQeRarL3_xK',
                                    title: 'Pohon Pelindung',
                                    image: Image.asset(
                                        'assets/pohon_pelindung.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pohon Pelindung'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IP4g0fmcAsGdD-Jq',
                                    title: 'Pemupukan',
                                    image: Image.asset(
                                        'assets/pemupukan_kopi.jpg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pemupukan'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IRsIeHX8E8SCo4xx',
                                    title: 'Pemangkasan',
                                    image: Image.asset(
                                        'assets/pemangkasan.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pemangkasan'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IWRvsCctVqZKDjkz',
                                    title: 'Sanitasi Kebun',
                                    image: Image.asset('assets/sanitasi.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Sanitasi Kebun'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IYZCDRmrigxLatxA',
                                    title: 'Hama dan Penyakit',
                                    image: Image.asset(
                                        'assets/hama_penyakit.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Hama dan Penyakit'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-LfbN8xg2hXnvKcwGDCO',
                                    title: 'Pembibitan',
                                    image: Image.asset('assets/pembibitan.jpg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pembibitan'),
                      leading: Icon(Icons.label_important),
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
                    onTap: () => _navigateToEditProfile(context, _userId),
                    child: ListTile(
                      title: Text('Ubah Profil'),
                      leading: Icon(Icons.settings),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      this._signOut();
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/home");
                    },
                    child: ListTile(
                      title: Text('Logout'),
                      leading: Icon(Icons.exit_to_app),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Drawer(
              child: new ListView(
                children: <Widget>[
//            header
                  new UserAccountsDrawerHeader(
                    accountName: Text(
                      nama,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    accountEmail: Text(
                      email,
                      style: TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: GestureDetector(
                      child: new CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: image.isNotEmpty
                            ? NetworkImage(image)
                            : AssetImage('assets/no_user.jpg'),
                      ),
                    ),
                    decoration: new BoxDecoration(
                      // borderRadius: BorderRadius.circular(100.0),
                      image: DecorationImage(
                          image: AssetImage('assets/sanitasi.jpeg'),
                          fit: BoxFit.cover),
                    ),
                  ),

//            body
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/home");
                    },
                    child: ListTile(
                      title: Text('Beranda'),
                      leading: Icon(Icons.home),
                    ),
                  ),

                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.of(context).pushNamed("/category");
                  //   },
                  //   child: ListTile(
                  //     title: Text('Kategori'),
                  //     leading: Icon(Icons.category),
                  //   ),
                  // ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IJCL0QmHf83DChgw',
                                    title: 'Pola Tanam',
                                    image: Image.asset('assets/pola_tanam.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pola Tanam'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-ILm7heQeRarL3_xK',
                                    title: 'Pohon Pelindung',
                                    image: Image.asset(
                                        'assets/pohon_pelindung.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pohon Pelindung'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IP4g0fmcAsGdD-Jq',
                                    title: 'Pemupukan',
                                    image: Image.asset(
                                        'assets/pemupukan_kopi.jpg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pemupukan'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IRsIeHX8E8SCo4xx',
                                    title: 'Pemangkasan',
                                    image: Image.asset(
                                        'assets/pemangkasan.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pemangkasan'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IWRvsCctVqZKDjkz',
                                    title: 'Sanitasi Kebun',
                                    image: Image.asset('assets/sanitasi.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Sanitasi Kebun'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-Lf-IYZCDRmrigxLatxA',
                                    title: 'Hama dan Penyakit',
                                    image: Image.asset(
                                        'assets/hama_penyakit.jpeg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Hama dan Penyakit'),
                      leading: Icon(Icons.label_important),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu(
                                    documentID: '-LfbN8xg2hXnvKcwGDCO',
                                    title: 'Pembibitan',
                                    image: Image.asset('assets/pembibitan.jpg',
                                        fit: BoxFit.cover),
                                  )));
                    },
                    child: ListTile(
                      title: Text('Pembibitan'),
                      leading: Icon(Icons.label_important),
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
                    onTap: () => _navigateToEditProfile(context, _userId),
                    child: ListTile(
                      title: Text('Ubah Profil'),
                      leading: Icon(Icons.settings),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      this._signOut();
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/home");
                    },
                    child: ListTile(
                      title: Text('Logout'),
                      leading: Icon(Icons.exit_to_app),
                    ),
                  ),
                ],
              ),
            );
          }
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }

  void _navigateToEditProfile(BuildContext context, String userID) {
    print("masuk");
    print(userID);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileDialog(
          userID: userID,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
