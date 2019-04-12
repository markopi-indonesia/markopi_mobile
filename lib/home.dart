import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Markopi'),
        leading: IconButton(
            icon: Icon(Icons.menu, semanticLabel: 'menu'),
            onPressed: () {
              print('Menu button');
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, semanticLabel: 'search'),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              semanticLabel: 'more',
            ),
            onPressed: () {
              print('More button');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    color: Colors.black,
                      fontSize: 18.0
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: 'Selamat Datang di ', style: TextStyle(fontWeight: FontWeight.w900)),
                    new TextSpan(text: 'markopi'),
                  ]
                ),
              )
            ],
          ),
      ),
    );
  }
}
