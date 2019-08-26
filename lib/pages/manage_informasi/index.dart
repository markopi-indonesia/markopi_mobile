import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/pages/crud_informasi/edit.dart';
import 'package:markopi_mobile/pages/manage_informasi/edit.dart';
import 'package:markopi_mobile/ui/menu/detail.dart';

class ManageInformasi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageInformasiState();
}

class _ManageInformasiState extends State<ManageInformasi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: DrawerPage(),
      body: Container(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('informasi').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
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
      child: GestureDetector(
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
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Slidable(
            key: ValueKey(informasi.title),
            actionPane: SlidableStrechActionPane(),
            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: 'Edit',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () => _update(
                      context,
                      data.documentID,
                      informasi.categoryID,
                      informasi.cover,
                      informasi.deskripsi,
                      informasi.images,
                      informasi.ownerRole,
                      informasi.title,
                      informasi.userID,
                      informasi.video)),
            ],
            child: ListTile(
              title: Text(
                informasi.title,
              ),
            ),
          ),
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

  void _update(
    BuildContext context,
    String documentID,
    String categoryID,
    String cover,
    String deskripsi,
    String images,
    String ownerRole,
    String title,
    String userID,
    String video,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditInformasiAdmin(
          documentID: documentID,
          categoryID: categoryID,
          cover: cover,
          deskripsi: deskripsi,
          images: images,
          ownerRole: ownerRole,
          title: title,
          userID: userID,
          video: video,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
