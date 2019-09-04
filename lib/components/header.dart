import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/search.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      backgroundColor: Color(0xFF2696D6),
      title: Text(
        'markopi',
        style: TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, semanticLabel: 'search'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchState()));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
