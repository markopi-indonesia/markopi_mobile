import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
   @override
  Widget build(BuildContext context) { 
    return AppBar(
        title: Text('Markopi'),
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