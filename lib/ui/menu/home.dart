import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/models/menu.dart';
import 'package:markopi_mobile/models/profile.dart';
import 'package:markopi_mobile/pages/crud_menu/add.dart';
import 'package:markopi_mobile/ui/menu/submenu.dart';

// Self import
import 'package:markopi_mobile/components/header.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isVisible = false;
  String role = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      if (user != null) {
        this.retrieveUserDetails(user).then((profile) {
          setState(() {
            if (profile.role == "Admin") {
              setState(() {
                _isVisible = true;
                role = "Admin";
              });
            }
          });
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: DrawerPage(),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('menu').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            List<Menu> listMenu = [];

            snapshot.data.documents
                .forEach((data) => listMenu.add(Menu.fromSnapshot(data)));

            if (listMenu.isEmpty) {
              print('menu is empty');
            }

            return GridView.builder(
              padding: EdgeInsets.fromLTRB(8.0, 60.0, 8.0, 60.0),
              shrinkWrap: true,
              itemCount: listMenu.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    _navigateSubMenu(
                      context,
                      listMenu[index].reference.documentID,
                      listMenu[index].color);
                    
                    print("#### subMenu ${listMenu[index].reference.documentID}");
                  },
                  child: CardMenu(
                      name: listMenu[index].name,
                      image: Image.asset(listMenu[index].image),
                      documentID: listMenu[index].reference.documentID),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: new Visibility(
        visible: _isVisible,
        child: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddMenuDialog(),
                fullscreenDialog: true,
              ),
            );
          },
          child: new Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  void _navigateSubMenu(
      BuildContext context, String documentID, String _color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubMenu(
          menuId: documentID,
          color: _color,
          role: role,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
          style: new TextStyle(color: Colors.black, fontSize: 22.0),
          children: <TextSpan>[
            new TextSpan(
                text: 'Selamat Datang di ',
                style: TextStyle(fontWeight: FontWeight.w900)),
            new TextSpan(text: 'markopi'),
          ]),
    );
  }
}

class CardMenu extends StatelessWidget {
  CardMenu({this.name, this.image, this.documentID});

  final String name;
  final Image image;
  final String documentID;

  @override
  Widget build(BuildContext context) {
    var card = new Card(
      elevation: 8.0,
      margin: EdgeInsets.all(9.0),
      clipBehavior: Clip.antiAlias,
      color: Color(0xFFD4ECFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: this.image,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 10.0, 16.0, 20.0),
            child: Text(this.name,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xff3b444f))),
          ),
        ],
      ),
    );
    return card;
  }
}
