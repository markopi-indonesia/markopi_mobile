import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/search.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
   @override
  Widget build(BuildContext context) { 
    return AppBar(
        title: Text('Markopi'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, semanticLabel: 'search'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SearchState()
              ));
            },
          ),
        ],
      );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}