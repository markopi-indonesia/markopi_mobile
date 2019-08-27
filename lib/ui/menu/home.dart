import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/models/menu.dart';
import 'package:markopi_mobile/ui/menu/submenu.dart';

// Self import
import 'package:markopi_mobile/components/header.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                padding: EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 20.0),
                shrinkWrap: true,
                itemCount: listMenu.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => _navigateSubMenu(context, listMenu[index].reference.documentID, listMenu[index].color),
                    child: CardMenu(
                        name: listMenu[index].name,
                        image: Image.asset(listMenu[index].image),
                        documentID: listMenu[index].reference.documentID),
                  );
                },
              );
            },
          ),
        ));
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
      color: Color(0xFFF0F6FE),
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
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ),
        ],
      ),
    );
    return card;
  }
}
