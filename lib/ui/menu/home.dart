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
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
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
                padding: EdgeInsets.only(top: 22.0),
                childAspectRatio: 8.0 / 10.0, //size card
                children: <Widget>[
                  new CardMenu(name: 'Pola Tanam', image: Image.asset('assets/pola_tanam.jpeg', fit: BoxFit.cover)),
                  new CardMenu(name: 'Pohon Pelindung', image: Image.asset('assets/pohon_pelindung.jpeg', fit: BoxFit.cover)),
                  new CardMenu(name: 'Pemupukan', image: Image.asset('assets/pemupukan_kopi.jpg', fit: BoxFit.cover)),
                  new CardMenu(name: 'Pemangkasan', image: Image.asset('assets/pemangkasan.jpeg', fit: BoxFit.cover)),
                  new CardMenu(name: 'Sanitasi Kebun', image: Image.asset('assets/sanitasi.jpeg', fit: BoxFit.cover)),
                  new CardMenu(name: 'Hama dan Penyakit', image: Image.asset('assets/hama_penyakit.jpeg', fit: BoxFit.cover)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardMenu extends StatelessWidget{

  CardMenu({this.name, this.image});

  final String name;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return new Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 13.0 / 11.0,
            child: this.image,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.name, style: TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
