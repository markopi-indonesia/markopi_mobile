import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/add.dart';
import 'package:markopi_mobile/models/pengajuan_fasilitator.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/detail_fasilitator.dart';
import 'package:markopi_mobile/models/profile.dart';

class PengajuanFasilitator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PengajuanFasilitatorState();
}

class _PengajuanFasilitatorState extends State<PengajuanFasilitator> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userID = "";
  final Firestore _firestore = Firestore.instance;
  var _isVisible = false;

  @override
  void initState() {
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userID = user?.uid;
          this.retrieveUserDetails(user).then((profile) {
            if (profile.role == "Petani") {
              setState(() {
                _isVisible = true;
              });
            }
          });
        }
      });
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
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: Stack(children: <Widget>[
          _build1(),
          _buildBody(),
        ]),
        floatingActionButton: buildAddPengajuanFab());
  }

  Widget _build1() {
    return new Container(
      height: 150.0,
      margin: new EdgeInsets.all(10.0),
      padding: EdgeInsets.all(18),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          gradient: new LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.lightBlue[100]],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp)),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                  padding: new EdgeInsets.only(left: 10.0, right: 40.0)),
              Align(
                alignment: Alignment.topCenter,
                child: new Text("Fasilitator",
                    style: new TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black)),
              ),
              Padding(padding: new EdgeInsets.only(top: 10.0)),
              Align(
                  alignment: Alignment.topLeft,
                  child: new Text(
                    '  - Membantu para petani kopi ',
                    style: new TextStyle(fontSize: 15.0, color: Colors.white70),
                  )),
              new Text(
                '  - Memberikan informasi kepada petani kopi',
                style: new TextStyle(fontSize: 15.0, color: Colors.white70),
              ),
              new Text(
                '  - Memberikan pelatihan kepada petani kopi',
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.white70,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('pengajuan')
          .where("userID", isEqualTo: userID)
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
    return ListView(
      padding: const EdgeInsets.only(top: 200.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final informasi = PengajuanFasilitatorModel.fromSnapshot(data);
    Color status;
    if (informasi.status == "Menunggu") {
      status = Color(0xFF99a9b3);
    } else if (informasi.status == "Disetujui") {
      status = Color(0xFF16C98D);
    } else {
      status = Color(0xFFD90600);
    }
    return Column(children: <Widget>[
      new Text(
        'Status Pengajuan',
        style: new TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.w300, color: Colors.black),
      ),
      Padding(
        key: ValueKey(informasi.dateTime),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: status,
          ),
          child: new ListTile(
            title: new Text(
              informasi.status + " - " + informasi.dateTime.toDate().toString(),
              style: TextStyle(color: Colors.white),
            ),
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
      ),
    ]);
  }

  buildAddPengajuanFab() {
    return new Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape: CircleBorder(),
          onPressed: () {
            _navigateToAddPengajuan();
          },
          child: Icon(Icons.add),
        ));
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
