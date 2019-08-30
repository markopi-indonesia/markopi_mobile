import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header_back.dart';
// import 'package:markopi_mobile/pages/crud_Pengajuan/edit.dart';
import 'package:markopi_mobile/models/pengajuan_fasilitator.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/edit.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:http/http.dart' as http;
// import 'package:markopi_mobile/controllers/Pengajuan_controller.dart';

class DetailPengajuan extends StatefulWidget {
  final String documentID;
  final String userID;
  final String ktp;
  final String selfie;
  final String pengalaman;
  final String sertifikat;
  final String status;
  final String pesan;
  final String dateTime;

  DetailPengajuan(
      {this.documentID,
      this.userID,
      this.ktp,
      this.selfie,
      this.pengalaman,
      this.sertifikat,
      this.status,
      this.pesan,
      this.dateTime});

  @override
  State<StatefulWidget> createState() => new _DetailPengajuanState();
}

class _DetailPengajuanState extends State<DetailPengajuan> {
  List<String> urls;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  static CollectionReference reference =
      Firestore.instance.collection('pengajuan');
  @override
  void initState() {
    urls = widget.sertifikat.split(";");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              _judulPengajuan(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Gambar KTP"),
              _fotoKTP(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Gambar Selfie"),
              _fotoSelfie(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Pengalaman"),
              _pengalaman(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Sertifikat"),
              _sertifikat(),
              _formEditHapus(),
            ])));
  }

  Widget _judulPengajuan() {
    return new Center(
      child: Text(
        "Detail Pengajuan Fasilitator",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _fotoKTP() {
    return new PinchZoomImage(
      image: Image.network(widget.ktp),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      onZoomStart: () {
        print('Zoom started');
      },
      onZoomEnd: () {
        print('Zoom finished');
      },
    );
  }

  Widget _fotoSelfie() {
    return new PinchZoomImage(
      image: Image.network(
        widget.selfie,
        fit: BoxFit.fitWidth,
      ),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      onZoomStart: () {
        print('Zoom started');
      },
      onZoomEnd: () {
        print('Zoom finished');
      },
    );
  }

  Widget _pengalaman() {
    return new Container(
      child: new Text(widget.pengalaman),
    );
  }

  Widget _sertifikat() {
    // return new Column(children: urls.map((item) => new Text(item)).toList());
    return new Column(
        children: urls
            .map((item) => new PinchZoomImage(
                  image: Image.network(item),
                  zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  hideStatusBarWhileZooming: true,
                  onZoomStart: () {
                    print('Zoom started');
                  },
                  onZoomEnd: () {
                    print('Zoom finished');
                  },
                ))
            .toList());
  }

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus'),
          content: Text('Apakah anda ingin menghapus pengajuan ini?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Ya'),
              onPressed: () => {
                Firestore.instance
                    .collection('pengajuan')
                    .document(documentID)
                    .delete()
                    .catchError((e) {
                  print(e);
                }),
                print(documentID),
                Navigator.pop(context),
                Navigator.of(context).pushNamed("/pengajuan_fasilitator"),
              },
            ),
          ],
        );
      },
    );
  }

  Widget _formEditHapus() {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new RaisedButton(
            padding: const EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () => _update(
                context,
                widget.documentID,
                widget.userID,
                widget.ktp,
                widget.selfie,
                widget.pengalaman,
                widget.sertifikat,
                widget.status,
                widget.pesan,
                widget.dateTime),
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
        ]);
  }

  void _update(
    BuildContext context,
    String documentID,
    String userID,
    String ktp,
    String selfie,
    String pengalaman,
    String sertifikat,
    String status,
    String pesan,
    String dateTime,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPengajuanDialog(
          documentID: documentID,
          userID: userID,
          ktp: ktp,
          selfie: selfie,
          pengalaman: pengalaman,
          sertifikat: sertifikat,
          status: status,
          pesan: pesan,
          dateTime: dateTime,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
