import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/search.dart';

class HeaderBack extends StatelessWidget implements PreferredSizeWidget{
   @override
  Widget build(BuildContext context) { 
    return AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF2696D6),
        title: Center(child:Text('markopi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
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