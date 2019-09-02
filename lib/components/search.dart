import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/ui/menu/detail.dart';

class SearchState extends StatefulWidget {
  final String documentID;

  const SearchState({Key key, this.documentID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchState> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  InformasiModel post;
  
  List<String> listTitle = List();
  
  String filter;
  Timer debounceTimer;
  DocumentReference documentReference =
      Firestore.instance.document('informasi');

  _SearchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }

      debounceTimer = Timer(Duration(milliseconds: 200), () {
        if (this.mounted) {
          filter = _searchQuery.text.toLowerCase();
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      print('===query empty====');
      setState(() {
        
      });
      return;
    }

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextField(
          autofocus: true,
          controller: _searchQuery,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 16.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              hintText: "Cari Informasi . . . ",
              hintStyle: TextStyle(color: Colors.black)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('informasi').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          List<InformasiModel> resultArticle = [];
          
          bool flag = false;
          if (filter != null && filter != "") {
            flag = true;
            snapshot.data.documents.forEach((f) async {
              String menuName = f['menuName'].toString().toLowerCase();
              String subMenuName = f['subMenuName'].toString().toLowerCase();
              String judul = f['title'].toString().toLowerCase();
              String deskripsi = f['deskripsi'].toString().toLowerCase();
              if (deskripsi.contains(filter) ||
                  judul.contains(filter) ||
                  menuName.contains(filter) ||
                  subMenuName.contains(filter)) {
                resultArticle.add(InformasiModel.fromSnapshot(f));
              }
            });
          } else {
            snapshot.data.documents.forEach((f) {
              resultArticle.add(InformasiModel.fromSnapshot(f));
            });
          }

          if (resultArticle.isEmpty == true) {
            return Center(
              child: Text('Data Tidak Ditemukan!'),
            );
          }
          return ListView.builder(
              itemExtent: 60.0,
              itemCount: flag? resultArticle.length:10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    String nama;
                    Firestore.instance
                        .collection('informasi')
                        .where("title", isEqualTo: resultArticle[index].title)
                        .snapshots()
                        .listen((data) => data.documents.forEach((doc) =>
                            Firestore.instance
                                .collection('profile')
                                .where("userID", isEqualTo: doc["userID"])
                                .snapshots()
                                .listen(
                                    (data) => data.documents.forEach((coba) => [
                                          nama = coba["nama"],
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailInformasi(
                                                        title: doc["title"],
                                                        cover: doc["cover"],
                                                        deskripsi:
                                                            doc["deskripsi"],
                                                        documentID:
                                                            doc.documentID,
                                                        images: doc["images"],
                                                        userID: doc["userID"],
                                                        nama: nama,
                                                        video: doc["video"],
                                                      )))
                                        ]))));
                  },
                  leading: new CircleAvatar(
                      child: Icon(Icons.library_books),
                      // ClipOval(
                      //   child: Image.network(
                      //     "${resultArticle[index].images}",
                      //     width: 100,
                      //     height: 100,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      backgroundColor: Colors.transparent),
                  title: RichText(
                    text: TextSpan(
                        text: resultArticle[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                );
              });
        },
      ),
    );
  }
}
