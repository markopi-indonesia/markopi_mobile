import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/pages/crud_informasi/add.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/pages/crud_informasi/detail.dart';

class InformasiAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _InformasiState();
}

class _InformasiState extends State<InformasiAdmin> {
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
        body: _buildBody(context),
        floatingActionButton: buildAddInformasiFab());
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('informasi')
          .where("userID", isEqualTo: userID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Center(child: CircularProgressIndicator(),);
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
    final informasi = InformasiModel.fromSnapshot(data);
    String nama;
    Firestore.instance
        .collection('profile')
        .where("userID", isEqualTo: informasi.userID)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => [
              nama = doc["nama"],
            ]));
    return Padding(
      key: ValueKey(informasi.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: new ListTile(
          leading: new CircleAvatar(
            radius: 30.0,
            child: Icon(Icons.label),
            backgroundColor: Colors.green,
          ),
          title: new Text(informasi.title),
          onTap: () => _detail(
              context,
              data.documentID,
              informasi.cover,
              // informasi.categoryID,
              informasi.cover,
              informasi.deskripsi,
              informasi.images,
              informasi.images,
              // informasi.ownerRole,
              informasi.title,
              informasi.userID,
              nama,
              informasi.video),
        ),
      ),
    );
  }

  buildAddInformasiFab() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
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

  void _detail(
    BuildContext context,
    String documentID,
    String categoryID,
    String cover,
    String deskripsi,
    String images,
    String ownerRole,
    String title,
    String userID,
    String nama,
    String video,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailInformasi(
          documentID: documentID,
          categoryID: categoryID,
          cover: cover,
          deskripsi: deskripsi,
          images: images,
          ownerRole: ownerRole,
          title: title,
          userID: userID,
          nama: nama,
          video: video,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
