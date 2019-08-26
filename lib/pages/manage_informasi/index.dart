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
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('informasi').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            List<InformasiModel> listInformasi = [];

            snapshot.data.documents.forEach(
                (data) => listInformasi.add(InformasiModel.fromSnapshot(data)));

            if (listInformasi.isEmpty) {
              print('informasi is empty');
            }

            return ListView.builder(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => _detail(
                        context,
                        listInformasi[index].reference.documentID,
                        listInformasi[index].categoryID,
                        listInformasi[index].cover,
                        listInformasi[index].deskripsi,
                        listInformasi[index].images,
                        listInformasi[index].ownerRole,
                        listInformasi[index].title,
                        listInformasi[index].userID,
                        nama,
                        listInformasi[index].video),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Slidable(
                        key: ValueKey(listInformasi[index].title),
                        actionPane: SlidableStrechActionPane(),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                              caption: 'Edit',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () => _update(
                                  context,
                                  listInformasi[index].reference.documentID,
                                  listInformasi[index].categoryID,
                                  listInformasi[index].cover,
                                  listInformasi[index].deskripsi,
                                  listInformasi[index].images,
                                  listInformasi[index].ownerRole,
                                  listInformasi[index].title,
                                  listInformasi[index].userID,
                                  listInformasi[index].video)),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete_outline,
                            onTap: () => deleteArticle(
                                listInformasi[index].reference.documentID),
                          )
                        ],
                        child: ListTile(
                          title: Text(
                            listInformasi[index].title,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
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

  void deleteArticle(String docId) {
    Firestore.instance.collection('informasi').document(docId).delete();
  }
}
