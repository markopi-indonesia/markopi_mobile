import 'package:flutter/material.dart';

class DetailMenu extends StatelessWidget {
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
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Stack(children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height / 4,
              margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: new Container(
//                padding: EdgeInsets.only(top: 20.0),
                child: new Stack(
                  children: <Widget>[
                    DetailThumbnail(),
                    DetailImage(),
                  ],
                ),
              ),
            ),
          ]),
          Center(
              child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.'),
                  Divider(),
                  Text(
                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.'),
                  Divider(),
                  Text(
                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.'),
                  Divider(),
                  Text(
                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.'),
                  Divider(),
                  Text(
                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.'),
                ],
              ),
            ),
          )),
          Container(
            margin: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Container(
//                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 1.5,
//                    color: Colors.tealAccent,
                    child: Column(
                      children: <Widget>[
                        Text('Gambar Terkait',
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w700)),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Image.asset('assets/pola_tanam.jpeg'),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: new Container(
//                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 1.5,
//                    color: Colors.greenAccent,
                    child: Column(
                      children: <Widget>[
                        Text('Video Terkait',
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w700)),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Image.asset('assets/pola_tanam.jpeg'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ])));
  }
}

class DetailImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
//        color: Colors.red
          ),
//      constraints: BoxConstraints.expand(),
      child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 90.0,
            height: 90.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new AssetImage('assets/pola_tanam.jpeg'))),
          )),
    );
  }
}

class DetailThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
      width: MediaQuery.of(context).size.width * 0.8,
      child: new Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: new BoxDecoration(
          color: Color(0xFF1C8134),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
                color: Colors.black,
                blurRadius: 0.0,
                offset: new Offset(0.0, 0.0))
          ],
        ),
        child: new Container(
            margin: const EdgeInsets.all(10.0),
            constraints: new BoxConstraints.expand(),
            child: Stack(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomCenter,
//                      width: 190.0,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            'Persiapan Lahan',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height / 16.0,
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text("by: Admin",
                              style: TextStyle(color: Colors.white)),
                          Spacer(flex: 1),
                          new Text("date: 23 April 2019",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    ));
  }
}
