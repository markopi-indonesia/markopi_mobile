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
                padding: EdgeInsets.fromLTRB(8.0, 60.0, 8.0, 60.0),
                shrinkWrap: true,
                itemCount: listMenu.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Firestore.instance.collection('menu').snapshots().listen(
                          (data) =>
                              data.documents.forEach((doc) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubMenu(
                                            documentID: doc.documentID,
                                            title: doc['name'],
                                            image: Image.asset(doc['image'],
                                                fit: BoxFit.cover),
                                          )))));
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
        ));
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
      margin: EdgeInsets.all(14.0),
      clipBehavior: Clip.antiAlias,
      color: Color(0xffE3EFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 40.0),
            child: this.image,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 10.0),
            child: Text(this.name,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ),
        ],
      ),
    );
    return card;
  }
}
