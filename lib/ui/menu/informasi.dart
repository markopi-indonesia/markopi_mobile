import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/models/profile.dart';
import 'package:markopi_mobile/pages/crud_informasi/add.dart';
import 'package:markopi_mobile/ui/menu/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/models/informasi.dart';

class Informasi extends StatefulWidget {
  // final String title;
  // final String nama;
  final String color;
  final String documentID;
  // final Image image;

  Informasi({
    Key key,
    @required this.documentID,
    @required this.color,
    // @required this.title,
    // @required this.nama,
    // @required this.image
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => new InformasiState();
}

class InformasiState extends State<Informasi> {
  var _isVisible = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      if (user != null) {
        this.retrieveUserDetails(user).then((profile) {
          if (profile.role == "Admin" || profile.role == "Fasilitator") {
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
      body: _buildBody(context),
      floatingActionButton: new Visibility(
        visible: _isVisible,
        child: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddInformasiDialog(),
                fullscreenDialog: true,
              ),
            );
          },
          child: new Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('informasi')
          .where("categoryID", isEqualTo: widget.documentID)
          .snapshots(),
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
    return Container(
      child: ListView(
        // shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
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
          // leading: Icon(Icons.label_important),
          title: new Text(informasi.title),
          onTap: () => _detail(
              context,
              data.documentID,
              informasi.categoryID,
              informasi.cover,
              informasi.deskripsi,
              informasi.images,
              informasi.ownerRole,
              informasi.title,
              informasi.userID,
              nama,
              informasi.video),
        ),
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