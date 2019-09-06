import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/pages/crud_informasi/edit.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:markopi_mobile/models/profile.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var _isVisible = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  @override
  void initState() {
    setState(() {
      images = widget.images.split(";");
    });
    this.getCurrentUser().then((user) {
      if (user != null) {
        this.retrieveUserDetails(user).then((profile) {
          if (profile.userID == widget.userID) {
            setState(() {
              _isVisible = true;
            });
          }
        });
      }
    });
    super.initState();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<ProfileModel> retrieveUserDetails(FirebaseUser user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection("profile").document(user.uid).get();
    ProfileModel profile = ProfileModel.fromMap(_documentSnapshot.data);
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: ListView(children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 0.0),
              child: Container(
                constraints: new BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 320.0,
                  maxHeight: double.infinity,
                  maxWidth: 1000.0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F6FE),
                ),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3b444f)),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
              )),
          deskripsiTeks(),
          Container(
            margin: EdgeInsets.all(2),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: new Container(
                    width: MediaQuery.of(context).size.width / 1.5,
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
                                      Column(
                                        children: <Widget>[
                                          PinchZoomImage(
                                            image: Image.network(img),
                                            zoomedBackgroundColor:
                                                Color.fromRGBO(
                                                    240, 240, 240, 1.0),
                                            hideStatusBarWhileZooming: true,
                                            onZoomStart: () {},
                                            onZoomEnd: () {},
                                          ),
                                          Divider(),
                                        ],
                                      )
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
          Container(
            margin: EdgeInsets.all(8),
            child: widget.video.isNotEmpty
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: new Container(
                          width: MediaQuery.of(context).size.width / 1.5,
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
                              // YoutubePlayer(
                              //   context: context,
                              //   source: widget.video,
                              //   quality: YoutubeQuality.LOW,
                              // ),
                              InkWell(
                                child: RichText(
                                  text: TextSpan(children: [
                                    new TextSpan(
                                      text: "Klik untuk melihat video",
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xff297cbb),
                                      ),
                                    )
                                  ]),
                                ),
                                onTap: () async {
                                  if (await canLaunch(widget.video)) {
                                    await launch(widget.video);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(""),
          ),
          Visibility(
            visible: _isVisible,
            child: new Column(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.only(top: 30.0)),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Color(0xff2696D6),
                        onPressed: () => _update(
                            context,
                            widget.documentID,
                            widget.deskripsi,
                            widget.images,
                            widget.title,
                            widget.userID,
                            widget.video),
                        child: new Text("Ubah"),
                      ),
                      new RaisedButton(
                        onPressed: () => _buildConfirmationDialog(
                            context, widget.documentID),
                        textColor: Colors.white,
                        color: Color(0xffD90600),
                        padding: const EdgeInsets.all(8.0),
                        child: new Text(
                          "Hapus",
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ])));
  }

  Widget deskripsiTeks() {
    List<String> text = widget.deskripsi.split("##");
    if (!widget.deskripsi.contains("##")) {
      return Column(
        children: <Widget>[
          new Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              width: double.infinity,
              child: new Text(widget.deskripsi)),
          new Divider(),
        ],
      );
    }
    List<Widget> list = new List<Widget>();
    if (text[0] != "") {
      list.add(Align(
          alignment: Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0, 0.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFF99a9b3), width: 0.5))),
              child: new Text(text[0]))));
    }
    for (var i = 1; i < text.length; i++) {
      list.add(Align(
          alignment: Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0, 0.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xFF99a9b3), width: 0.5))),
              child: new Text(text[i]))));
    }
    return new Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Column(children: list));
  }

  void _update(
    BuildContext context,
    String documentID,
    String deskripsi,
    String images,
    String title,
    String userID,
    String video,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditInformasiDialog(
          documentID: documentID,
          deskripsi: deskripsi,
          images: images,
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
                      Firestore.instance
                          .collection('informasi')
                          .document(documentID)
                          .delete()
                          .catchError((e) {
                        print(e);
                      }),
                      Navigator.pop(context),
                      Navigator.pop(context),
                    }),
          ],
        );
      },
    );
  }
}
