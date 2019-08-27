import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/add.dart';
import 'package:markopi_mobile/models/pengajuan_fasilitator.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/detail_admin.dart';

class PengajuanFasilitatorAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PengajuanFasilitatorAdminState();
}

class _PengajuanFasilitatorAdminState extends State<PengajuanFasilitatorAdmin> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userID = "";

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userID = user?.uid;
        }
      });
    });
    super.initState();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Header(),
      drawer: DrawerPage(),
      body: Stack(children: <Widget>[_buildBody(context)]),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pengajuan').orderBy('status').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: CircularProgressIndicator(),
          );
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      // shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final informasi = PengajuanFasilitatorModel.fromSnapshot(data);
    Color status;
    if (informasi.status == "Menunggu") {
      status = Colors.grey;
    } else if (informasi.status == "Disetujui") {
      status = Colors.green;
    } else {
      status = Colors.red;
    }
    return Padding(
      key: ValueKey(informasi.dateTime),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
          color: status,
        ),
        child: new ListTile(
          title: new Text(informasi.status +
              " - " +
              informasi.dateTime.toDate().toString()),
          onTap: () => _detail(
            context,
            data.documentID,
            informasi.userID,
            informasi.ktp,
            informasi.selfie,
            informasi.pengalaman,
            informasi.sertifikat,
            informasi.status,
            informasi.pesan,
            informasi.dateTime.toString(),
          ),
        ),
      ),
    );
  }

  buildAddPengajuanFab() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      shape: CircleBorder(),
      onPressed: () {
        _navigateToAddPengajuan();
      },
      child: Icon(Icons.add),
    );
  }

  void _navigateToAddPengajuan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPengajuanDialog(),
        fullscreenDialog: true,
      ),
    );
  }

  void _detail(
      BuildContext context,
      String documentID,
      String userID,
      String ktp,
      String selfie,
      String pengalaman,
      String sertifikat,
      String status,
      String pesan,
      String dateTime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPengajuan(
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