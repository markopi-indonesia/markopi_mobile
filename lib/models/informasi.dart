import 'package:cloud_firestore/cloud_firestore.dart';

class InformasiModel {
  final String title;
  final String categoryID;
  final String deskripsi;
  final String ownerRole;

  final DocumentReference reference;

  InformasiModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null && map['categoryID'] != null && map['deskripsi'] != null && map['ownerRole'] != null),
        title = map['title'], categoryID = map['categoryID'], deskripsi = map['deskripsi'], ownerRole = map['ownerRole'];

  InformasiModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => title + categoryID + deskripsi;
}