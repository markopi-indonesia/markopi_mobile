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
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: new TextSpan(
                  style: new TextStyle(color: Colors.black, fontSize: 22.0),
                  children: <TextSpan>[
                    new TextSpan(
                        text: 'Selamat Datang di ',
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    new TextSpan(text: 'markopi'),
                  ]),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16.0),
                childAspectRatio: 8.0 / 10.0, //size card
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 13.0 / 11.0,
                          child: Image.asset('assets/pembibitan.jpeg', fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Pembibitan', style: TextStyle(fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 13.0 / 11.0,
                          child: Image.asset('assets/pola_tanam.jpeg', fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Pola Tanam', style: TextStyle(fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 13.0 / 11.0,
                          child: Image.asset('assets/pohon_pelindung.jpeg', fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Pohon Pelindung', style: TextStyle(fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 13.0 / 11.0,
                          child: Image.asset('assets/pemupukan_kopi.jpg', fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Pemupukan', style: TextStyle(fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
