import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:markopi_mobile/models/menu.dart';
import 'package:markopi_mobile/pages/profile/edit.dart';
import 'package:markopi_mobile/pages/profile/index.dart';
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

              Center(
                child: new AspectRatio(
                  aspectRatio: 90 / 100,
                  child: new Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('menu').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();

                        List<Menu> menuList = [];

                        snapshot.data.documents.forEach((data) {
                          menuList.add(Menu.fromSnapshot(data));
                        });

                        if (!menuList.isEmpty) {
                          print("menuList not empty");
                        }

                        return ListView.builder(
                            // itemExtent: 62.0,
                            physics: ScrollPhysics(),
                            itemCount: menuList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => _navigateSubMenu(
                                    context,
                                    menuList[index].reference.documentID,
                                    menuList[index].color),
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                        text: menuList[index].name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  leading: Icon(Icons.label_important),
                                ),
                              );
                            });
                      },
                    ),
                  ),
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

                  Center(
                    child: new AspectRatio(
                      aspectRatio: 90 / 100,
                      child: new Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream:
                              Firestore.instance.collection('menu').snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();

                            List<Menu> menuList = [];

                            snapshot.data.documents.forEach((data) {
                              menuList.add(Menu.fromSnapshot(data));
                            });

                            if (!menuList.isEmpty) {
                              print("menuList not empty");
                            }

                            return ListView.builder(
                                // itemExtent: 60.0,
                                // shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: menuList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () => _navigateSubMenu(
                                        context,
                                        menuList[index].reference.documentID,
                                        menuList[index].color),
                                    child: ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                            text: menuList[index].name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      leading: Icon(Icons.label_important),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
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

                  Center(
                    child: new AspectRatio(
                      aspectRatio: 90 / 100,
                      child: new Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream:
                              Firestore.instance.collection('menu').snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();

                            List<Menu> menuList = [];

                            snapshot.data.documents.forEach((data) {
                              menuList.add(Menu.fromSnapshot(data));
                            });

                            if (!menuList.isEmpty) {
                              print("menuList not empty");
                            }

                            return ListView.builder(
                                // itemExtent: 60.0,
                                physics: ScrollPhysics(),
                                itemCount: menuList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () => _navigateSubMenu(
                                        context,
                                        menuList[index].reference.documentID,
                                        menuList[index].color),
                                    child: ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                            text: menuList[index].name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      leading: Icon(Icons.label_important),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
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

  void _navigateSubMenu(
      BuildContext context, String documentID, String _color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubMenu(
          menuId: documentID,
          color: _color,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, String userID) {
    print("masuk");
    print(userID);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndexProfileDialog(
          userID: userID,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
