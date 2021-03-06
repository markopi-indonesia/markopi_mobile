import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/models/menu.dart';
import 'package:markopi_mobile/pages/profile/index.dart';
import 'package:markopi_mobile/ui/menu/submenu.dart';
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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String _userId = "";
  String nama = "";
  String image = "";
  String email;
  String role = "";
  int totalDataPengajuan = 0;

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      if (user != null) {
        this.retrieveUserDetails(user).then((profile) {
          setState(() {
            if (profile != null) {
              nama = profile.nama;
              image = profile.photoUrl;
              role = profile.role;
            }
          });
        });
      }
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          email = user.email;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });

    countDataPengajuan();

    super.initState();
  }

  void countDataPengajuan() async {
    QuerySnapshot _myDoc = await Firestore.instance
        .collection('pengajuan')
        .where('status', isEqualTo: 'Menunggu')
        .getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;

    setState(() {
      totalDataPengajuan = _myDocCount.length;
    });
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
    } catch (e) {}
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
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: Color(0xFF142B44),
                ),
                accountEmail: null,
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
                        return ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: menuList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => _navigateSubMenu(
                                  context,
                                  menuList[index].reference.documentID,
                                  menuList[index].color,
                                  menuList[index].name,
                                ),
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
                  Navigator.of(context).pushNamed("/credit");
                },
                child: ListTile(
                  title: Text('Tentang Kami'),
                  leading: Icon(Icons.info),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/login");
                },
                child: ListTile(
                  title: Text('Login'),
                  leading: Icon(Icons.person),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/register");
                },
                child: ListTile(
                  title: Text('Register'),
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
                          backgroundColor: Colors.white,
                          backgroundImage: image.contains("assets")
                              ? AssetImage(image)
                              : NetworkImage(image)),
                    ),
                    decoration: new BoxDecoration(
                      color: Color(0xFF142B44),
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
                      Navigator.of(context).pushNamed("/manage-user");
                    },
                    child: ListTile(
                      title: Text('Mengelola User'),
                      leading: Icon(Icons.supervised_user_circle),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamed("/pengajuan_fasilitator_admin");
                    },
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Pengajuan Fasilitator'),
                          totalDataPengajuan != 0
                              ? new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff1d508d),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$totalDataPengajuan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : new Container(),
                        ],
                      ),
                      leading: Icon(Icons.verified_user),
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
                            return ListView.builder(
                                physics: ScrollPhysics(),
                                itemCount: menuList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () => _navigateSubMenu(
                                      context,
                                      menuList[index].reference.documentID,
                                      menuList[index].color,
                                      menuList[index].name,
                                    ),
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
                      Navigator.of(context).pushNamed("/credit");
                    },
                    child: ListTile(
                      title: Text('Tentang Kami'),
                      leading: Icon(Icons.info),
                    ),
                  ),

                  InkWell(
                    onTap: () => _navigateToEditProfile(context, _userId),
                    child: ListTile(
                      title: Text('Profil'),
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
                          backgroundColor: Colors.white,
                          backgroundImage: image.contains("assets")
                              ? AssetImage(image)
                              : NetworkImage(image)),
                    ),
                    decoration: new BoxDecoration(
                      color: Color(0xFF142B44),
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
                      Navigator.of(context).pushNamed("/pengajuan_fasilitator");
                    },
                    child: ListTile(
                      title: Text('Pengajuan Fasilitator'),
                      leading: Icon(Icons.verified_user),
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
                            return ListView.builder(
                                physics: ScrollPhysics(),
                                itemCount: menuList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () => _navigateSubMenu(
                                      context,
                                      menuList[index].reference.documentID,
                                      menuList[index].color,
                                      menuList[index].name,
                                    ),
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
                      Navigator.of(context).pushNamed("/credit");
                    },
                    child: ListTile(
                      title: Text('Tentang Kami'),
                      leading: Icon(Icons.info),
                    ),
                  ),

                  InkWell(
                    onTap: () => _navigateToEditProfile(context, _userId),
                    child: ListTile(
                      title: Text('Profil'),
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
      BuildContext context, String documentID, String _color, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubMenu(
          menuId: documentID,
          color: _color,
          menuName: name,
          role: role,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, String userID) {
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
