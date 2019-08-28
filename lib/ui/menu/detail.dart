import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/pages/crud_informasi/edit.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/controllers/informasi_controller.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:youtube_player/youtube_player.dart';

class DetailInformasi extends StatefulWidget {
  final String documentID;
  final String cover;
  final String deskripsi;
  final String images;
  final String title;
  final String userID;
  final String nama;
  final String video;

  DetailInformasi(
      {this.documentID,
      this.cover,
      this.deskripsi,
      this.images,
      this.title,
      this.userID,
      this.nama,
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
        appBar: HeaderBack(),
        // drawer: DrawerPage(),
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: ListView(children: <Widget>[
          new Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
              constraints: new BoxConstraints(
                minHeight: 50.0,
                minWidth: 5.0,
                maxHeight: 50.0,
                maxWidth: 30.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFffc83f),
                // border: Border.all(),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: new Text(widget.title,
                    style: new TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black)),
              )),
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
            margin: EdgeInsets.all(2),
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
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: new Text("Gambar",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Color(0xFF3B444F))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: widget.images.isNotEmpty
                              ? Column(
                                  children: <Widget>[
                                    for (var img in images)
                                      PinchZoomImage(
                                        image: Image.network(img),
                                        zoomedBackgroundColor:
                                            Color.fromRGBO(240, 240, 240, 1.0),
                                        hideStatusBarWhileZooming: true,
                                        onZoomStart: () {
                                          print('Zoom started');
                                        },
                                        onZoomEnd: () {
                                          print('Zoom finished');
                                        },
                                      ),
                                    Divider(),
                                  ],
                                )
                              : Text("Tidak ada gambar"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider(),
          Container(
            margin: EdgeInsets.all(8),
            child: widget.video.isNotEmpty
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: new Container(
//                    height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 1.5,
//                    color: Colors.greenAccent,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: new Text("Video",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Color(0xFF3B444F))),
                                ),
                              ),
                              YoutubePlayer(
                                  context: context,
                                  source: widget.video,
                                  quality: YoutubeQuality.LOW,
                                  // callbackController is (optional).
                                  // use it to control player on your own.
                                  // callbackController: (controller) {
                                  //   _videoController = controller;
                                  // },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(""),
          ),
//           Container(
//             margin: EdgeInsets.all(8),
//             child: widget.video.isNotEmpty
//                 ? Row(
//                     children: <Widget>[
//                       Expanded(
//                         flex: 3,
//                         child: new Container(
// //                    height: MediaQuery.of(context).size.height,
//                           width: MediaQuery.of(context).size.width / 1.5,
// //                    color: Colors.greenAccent,
//                           child: Column(
//                             children: <Widget>[
//                               Text('Video Terkait',
//                                   style: TextStyle(
//                                       fontSize: 22.0,
//                                       fontWeight: FontWeight.w700)),
//                               Container(
//                                 margin: EdgeInsets.all(10.0),
//                                 child: widget.video.isNotEmpty
//                                     ? Image.asset('assets/pola_tanam.jpeg')
//                                     : Text("Tidak ada video"),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : Text(""),
//           ),
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
          content: Text('Apakah anda ingin menghapus artikel ini?'),
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
                      // Navigator.of(context).pushNamed("/informasi"),
                    }),
          ],
        );
      },
    );
  }
}
