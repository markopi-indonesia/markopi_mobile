import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
// import 'package:markopi_mobile/pages/crud_Pengajuan/edit.dart';
import 'package:markopi_mobile/models/pengajuan_fasilitator.dart';
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
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView());
  }
}
