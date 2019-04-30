import 'package:flutter/material.dart';

class SubMenu extends StatelessWidget {

  final String title;
  final Image image;

  SubMenu({Key key, @required this.title, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Row(
        children: <Widget>[
          Flexible(
              flex: 3,
              child: Container(
                child: Center(
                  child: new FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 0.9,
                    child: new Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
//                        color: Colors.orange,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(title, style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w900)),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height/3,
                                  child: image,
                                ),
                                SubMenuButton(name: 'Persiapan Lahan'),
                                SubMenuButton(name: 'Pembuatan Lubang Tanam'),
                                SubMenuButton(name: 'Cara Penanaman'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
//              Center(
//                  child: Text(
//                    "Size ${media.width} * ${media.height}",
//                    style: Theme.of(context).textTheme.title,
//                  )
//              ),
              )),
        ],
      ),
    );
  }
}

class SubMenuImageAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/pola_tanam.jpeg');
    Image image = Image(image: assetImage);
    return image;
  }
}

class SubMenuButton extends StatelessWidget {

  SubMenuButton({this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 300.0,
          height: 50.0,
          margin: EdgeInsets.only(top: 30.0),
          child: OutlineButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),
            child: Text(this.name, style: TextStyle(color: Colors.redAccent)),
            color: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              // Perform some action
            },
          )
        )
      ],
    );
  }
}
