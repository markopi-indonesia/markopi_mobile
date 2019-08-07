import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/pages/crud_informasi/edit.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/controllers/informasi_controller.dart';

class DetailInformasi extends StatefulWidget {
  final String documentID;
  final String categoryID;
  final String cover;
  final String deskripsi;
  final String images;
  final String ownerRole;
  final String title;
  final String userID;
  final String video;

  DetailInformasi(
      {this.documentID,
      this.categoryID,
      this.cover,
      this.deskripsi,
      this.images,
      this.ownerRole,
      this.title,
      this.userID,
      this.video});

  @override
  State<StatefulWidget> createState() => new _DetailInformasiState();
}

class _DetailInformasiState extends State<DetailInformasi> {
  var images = [];

  @override
  void initState() {
    setState(() {
      images = widget.images.split(";");
    });
    super.initState();
    images.forEach((f) {
      print(f);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
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
                    // DetailThumbnail(),
                    // DetailImage(),
                    new Center(
                        child: new Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 15),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Text(
                                            widget.title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              16.0,
                                      child: new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          new Text("by: " + widget.ownerRole,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Spacer(flex: 1),
                                          // new Text("date: 23 April 2019",
                                          //     style: TextStyle(
                                          //         color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                    )),
                    Container(
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
                                    image: new NetworkImage(widget.cover))),
                          )),
                    ),
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
                  Text(widget.deskripsi),
                  Divider(),
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
                          child: widget.images.isNotEmpty
                              ? Column(
                                  children: <Widget>[
                                    for (var item in images) Image.network(item)
                                  ],
                                )
                              : Text("Tidak ada gambar"),
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
                          child: widget.video.isNotEmpty
                              ? Image.asset('assets/pola_tanam.jpeg')
                              : Text("Tidak ada video"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          new Padding(padding: new EdgeInsets.only(top: 30.0)),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () => _update(
                      context,
                      widget.documentID,
                      widget.categoryID,
                      widget.cover,
                      widget.deskripsi,
                      widget.images,
                      widget.ownerRole,
                      widget.title,
                      widget.userID,
                      widget.video),
                  child: new Text("Ubah"),
                ),
                new RaisedButton(
                  onPressed: () =>
                      _buildConfirmationDialog(context, widget.documentID),
                  textColor: Colors.white,
                  color: Colors.lightGreen[800],
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Hapus",
                  ),
                ),
              ])
        ])));
  }

  void _update(
    BuildContext context,
    String documentID,
    String categoryID,
    String cover,
    String deskripsi,
    String images,
    String ownerRole,
    String title,
    String userID,
    String video,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditInformasiDialog(
              documentID: documentID,
              categoryID: categoryID,
              cover: cover,
              deskripsi: deskripsi,
              images: images,
              ownerRole: ownerRole,
              title: title,
              userID: userID,
              video: video,
            ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget getTextWidgets(List<String> strings) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus'),
          content: Text('Apakah anda ingin menghapus informasi ini?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Ya'),
                onPressed: () => {
                      InformasiController.removeInformasi(documentID),
                      Navigator.pop(context),
                      Navigator.of(context).pushNamed("/informasi"),
                      // Navigator.of(context).pushNamed("/informasi"),
                    }),
          ],
        );
      },
    );
  }
}
