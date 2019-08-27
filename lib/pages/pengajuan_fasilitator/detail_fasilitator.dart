import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header_back.dart';
// import 'package:markopi_mobile/pages/crud_Pengajuan/edit.dart';
import 'package:markopi_mobile/models/pengajuan_fasilitator.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
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
      image: Image.network(widget.selfie, fit: BoxFit.fitWidth,),
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

  Widget _sertifikat(){
    return new Column(children: urls.map((item) => new Text(item)).toList());
  }
}
