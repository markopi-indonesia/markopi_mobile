import 'package:flutter/material.dart';

//Self import
import 'package:markopi_mobile/pages/authentication/login.dart';
import 'package:markopi_mobile/pages/authentication/register.dart';
import 'package:markopi_mobile/ui/menu/home.dart';
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
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            },
            child: ListTile(
              title: Text('Beranda'),
              leading: Icon(Icons.home),
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
            },
            child: ListTile(
              title: Text('Masuk'),
              leading: Icon(Icons.person),
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register()),
            );
            },
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
