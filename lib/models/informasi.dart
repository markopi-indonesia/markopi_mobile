import 'package:cloud_firestore/cloud_firestore.dart';

class InformasiModel {
  final String title;
  final String categoryID;
  final String deskripsi;
  final String ownerRole;
  final String cover;
  final String images;
  final String video;
  final String userID;

  final DocumentReference reference;

  InformasiModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null && map['categoryID'] != null && map['deskripsi'] != null && map['ownerRole'] != null && map['cover'] != null && map['images'] != null&& map['video'] != null&& map['userID'] != null),
        title = map['title'], categoryID = map['categoryID'], deskripsi = map['deskripsi'], ownerRole = map['ownerRole'], cover = map['cover'], images = map['images'], video = map['video'], userID = map['userID'];

  InformasiModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => title + categoryID + deskripsi;
}