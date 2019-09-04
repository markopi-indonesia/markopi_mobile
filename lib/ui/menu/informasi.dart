import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/models/profile.dart';
import 'package:markopi_mobile/pages/crud_informasi/add.dart';
import 'package:markopi_mobile/ui/menu/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/pages/crud_submenu/edit.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Informasi extends StatefulWidget {
  final String menuID;
  final String subMenuID;
  final String color;
  final String subMenuName;

  Informasi({
    this.menuID,
    this.subMenuID,
    this.color,
    this.subMenuName,
  });
  @override
  State<StatefulWidget> createState() => new InformasiState();
}

class InformasiState extends State<Informasi> {
  var _isVisible = false;
  var _isAdmin = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      if (user != null) {
        this.retrieveUserDetails(user).then((profile) {
          if (profile.role == "Admin") {
            setState(() {
              _isVisible = true;
              _isAdmin = true;
            });
          } else if (profile.role == "Fasilitator") {
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
      body: Stack(
        children: <Widget>[
          _header(),
          _buildBody(context),
        ],
      ),
      // floatingActionButton: new Visibility(
      //   visible: _isVisible,
      //   child: new FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => AddInformasiDialog(
      //               menuID: widget.menuID, subMenuID: widget.subMenuID),
      //           fullscreenDialog: true,
      //         ),
      //       );
      //     },
      //     child: new Icon(Icons.add),
      //     backgroundColor: Colors.blue,
      //   ),
      // ),
      floatingActionButton: _isAdmin
          ? SpeedDial(
              marginRight: 18,
              marginBottom: 20,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              visible: _isVisible,
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              tooltip: 'Speed Dial',
              heroTag: 'speed-dial-hero-tag',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 8.0,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.add),
                    backgroundColor: Colors.blue,
                    label: 'Tambah Informasi',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddInformasiDialog(
                                menuID: widget.menuID,
                                subMenuID: widget.subMenuID),
                            fullscreenDialog: true,
                          ),
                        )),
                SpeedDialChild(
                  child: Icon(Icons.brush),
                  backgroundColor: Colors.green,
                  label: 'Ubah Sub Menu',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditSubMenuDialog(
                        namaSubMenu: widget.subMenuName,
                        subMenuId: widget.subMenuID,
                      ),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SpeedDialChild(
                  child: Icon(Icons.delete),
                  backgroundColor: Colors.red,
                  label: 'Hapus Sub Menu',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () =>
                      _buildConfirmationDialog(context, widget.subMenuID),
                ),
              ],
            )
          : new Visibility(
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

  Widget _header() {
    return new Padding(
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
            widget.subMenuName,
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3b444f)),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('informasi')
          .where("subMenuID", isEqualTo: widget.subMenuID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 80.0),
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
    return Column(
      children: <Widget>[
        Padding(
            key: ValueKey(informasi.title),
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Container(
                child: ListTile(
              onTap: () => _detail(
                  context,
                  informasi.reference.documentID,
                  informasi.deskripsi,
                  informasi.images,
                  informasi.title,
                  informasi.userID,
                  nama,
                  informasi.video),
              title: Text(
                informasi.title,
                style: TextStyle(color: Color(0xff000000)),
              ),
            ))),
        Divider(),
      ],
    );
  }

  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance
  //         .collection('informasi')
  //         .where("subMenuID", isEqualTo: widget.subMenuID)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData)
  //         return new Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       List<InformasiModel> listInformasi = [];

  //       snapshot.data.documents.forEach(
  //           (data) => listInformasi.add(InformasiModel.fromSnapshot(data)));

  //       return ListView.separated(
  //           itemCount: listInformasi.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             String nama;
  //             Firestore.instance
  //                 .collection('profile')
  //                 .where("userID", isEqualTo: listInformasi[index].userID)
  //                 .snapshots()
  //                 .listen((data) => data.documents.forEach((doc) => [
  //                       nama = doc["nama"],
  //                     ]));

  //             return Padding(
  //                 key: ValueKey(listInformasi[index].title),
  //                 padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
  //                 child: GestureDetector(
  //                   onTap: () => _detail(
  //                       context,
  //                       listInformasi[index].reference.documentID,
  //                       listInformasi[index].deskripsi,
  //                       listInformasi[index].images,
  //                       listInformasi[index].title,
  //                       listInformasi[index].userID,
  //                       nama,
  //                       listInformasi[index].video),
  //                   child: Container(
  //                       margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
  //                       child: Text(
  //                         listInformasi[index].title,
  //                         style:
  //                             TextStyle(fontSize: 18, color: Color(0xff3b444f)),
  //                       )),
  //                 ));
  //           },
  //           separatorBuilder: (BuildContext context, int index) =>
  //               Divider(color: Colors.black));
  //     },
  //   );
  // }

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

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus'),
          content: Text('Apakah anda ingin menghapus sub menu ini?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Ya'),
                onPressed: () => {
                      Firestore.instance
                          .collection('submenu')
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
