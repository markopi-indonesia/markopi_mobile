import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
   @override
  Widget build(BuildContext context) { 
    return AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Center(child:Text('markopi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, semanticLabel: 'search'),
            onPressed: () {
              print('Search button');
            },
          ),
        ],
      );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}