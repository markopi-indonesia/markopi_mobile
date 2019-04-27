import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
//            header
          new UserAccountsDrawerHeader(
            accountName: Text('Markopi'),
            accountEmail: Text('markopi.indonesia@gmail.com'),
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
            onTap: () {},
            child: ListTile(
              title: Text('Beranda'),
              leading: Icon(Icons.home),
            ),
          ),

          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Masuk'),
              leading: Icon(Icons.person),
            ),
          ),

          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Daftar'),
              leading: Icon(Icons.person_add),
            ),
          ),
        ],
      ),
    );
  }
}
