import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/pages/crud_informasi/add.dart';

class Informasi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _InformasiState();
}

class _InformasiState extends State<Informasi> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: Text("Informasi"),
        floatingActionButton: buildAddInformasiFab());
  }


buildAddInformasiFab() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _navigateToAddInformasi();
      },
      child: Icon(Icons.add),
    );
  }

  void _navigateToAddInformasi() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddInformasiDialog(),
        fullscreenDialog: true,
      ),
    );
  }
}