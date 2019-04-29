import 'package:flutter/material.dart';

class SubMenu extends StatelessWidget {
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
              child:
              Center(
                child: new FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 0.9,
                  child: new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.orange,
                    ),
                    child: new Column(
                      children: <Widget>[
                        SubMenuImageAsset(),
                        SubMenuButton()
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
            )
          ),

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

class SubMenuButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      margin: EdgeInsets.only(top: 30.0),
      child: RaisedButton(
        child: const Text('Persiapan Lahan'),
        color: Colors.deepPurpleAccent,
        elevation: 6.0,
        splashColor: Colors.blueGrey,
        onPressed: () {
          // Perform some action
        },
      ),
    );
  }

}
