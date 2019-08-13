import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/models/article_model.dart';
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
  Article post;
  String _error;
  bool _isSearching = false;
  List<Article> _results = List();
  List<String> listTitle = List();
  List<String> _strResult = [];
  String filter;
  Timer debounceTimer;
  DocumentReference documentReference =
      Firestore.instance.document('informasi');

  _SearchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }

      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          filter = _searchQuery.text;
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      print('===query empty====');
      setState(() {
        _isSearching = false;
        _error = null;
        _results = List();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = List();
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

          List<Article> resultArticle = [];
          String _error;
          if (filter != null && filter != "") {
            snapshot.data.documents.forEach((f) {
              String deskripsi = f['deskripsi'];

              if (deskripsi.contains(filter)) {
                resultArticle.add(Article.fromSnapshot(f));
              } else {
                // resultArticle = [];
                _error = 'Data tidak ditemukan';
              }
            });
          } else {
            snapshot.data.documents.forEach((f) {
              resultArticle.add(Article.fromSnapshot(f));
            });
          }

          if (resultArticle.isEmpty == true) {
            return Center(
              child: Text('Data Tidak Ditemukan!'),
            );
          }

          return ListView.builder(
              itemExtent: 60.0,
              itemCount: resultArticle.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Firestore.instance
                        .collection('informasi')
                        .where("title", isEqualTo: resultArticle[index].title)
                        .snapshots()
                        .listen((data) => data.documents
                            .forEach(
                              (doc) => Navigator.push(context, MaterialPageRoute(
                                builder: (context) => DetailInformasi(
                                  categoryID: doc["categoryID"],
                                  title: doc["title"],
                                  cover: doc["cover"],
                                  deskripsi: doc["deskripsi"],
                                  documentID: doc.documentID,
                                  images: doc["images"],
                                  ownerRole: doc["ownerRole"],
                                  userID: doc["userID"],
                                  video: doc["video"],
                                )
                              ))
                              )
                            );
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
