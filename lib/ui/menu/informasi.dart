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
  final String menuID;
  final String subMenuID;
  final String color;

  Informasi({
    Key key,
    @required this.menuID,
    @required this.subMenuID,
    @required this.color,
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
                builder: (context) => AddInformasiDialog(
                    menuID: widget.menuID, subMenuID: widget.subMenuID),
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
          .where("subMenuID", isEqualTo: widget.subMenuID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: CircularProgressIndicator(),
          );
        List<InformasiModel> listInformasi = [];

        snapshot.data.documents.forEach(
            (data) => listInformasi.add(InformasiModel.fromSnapshot(data)));

        return ListView.separated(
            itemCount: listInformasi.length,
            itemBuilder: (BuildContext context, int index) {
              String nama;
              Firestore.instance
                  .collection('profile')
                  .where("userID", isEqualTo: listInformasi[index].userID)
                  .snapshots()
                  .listen((data) => data.documents.forEach((doc) => [
                        nama = doc["nama"],
                      ]));

              return Padding(
                  key: ValueKey(listInformasi[index].title),
                  padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                  child: GestureDetector(
                    onTap: () => _detail(
                        context,
                        listInformasi[index].reference.documentID,
                        listInformasi[index].deskripsi,
                        listInformasi[index].images,
                        listInformasi[index].title,
                        listInformasi[index].userID,
                        nama,
                        listInformasi[index].video),
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Text(
                          listInformasi[index].title,
                          style:
                              TextStyle(fontSize: 18, color: Color(0xff3b444f)),
                        )),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.black));
      },
    );
  }

  void _detail(
    BuildContext context,
    String documentID,
    String deskripsi,
    String images,
    String title,
    String userID,
    String nama,
    String video,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailInformasi(
          documentID: documentID,
          deskripsi: deskripsi,
          images: images,
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
