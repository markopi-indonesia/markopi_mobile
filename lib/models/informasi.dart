import 'package:cloud_firestore/cloud_firestore.dart';

class InformasiModel {
  final String title;
  final String menuID;
  final String menuName;
  final String subMenuID;
  final String subMenuName;
  final String deskripsi;
  // final String cover;
  final String images;
  final String video;
  final String userID;

  final DocumentReference reference;

  InformasiModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null &&
            map['menuID'] != null &&
            map['menuName'] != null &&
            map['subMenuID'] != null &&
            map['subMenuName'] != null &&
            map['deskripsi'] != null &&
            // map['cover'] != null &&
            map['images'] != null &&
            map['video'] != null &&
            map['userID'] != null),
        title = map['title'],
        menuID = map['menuID'],
        menuName = map['menuName'],
        subMenuID = map['subMenuID'],
        subMenuName = map['subMenuName'],
        deskripsi = map['deskripsi'],
        // cover = map['cover'],
        images = map['images'],
        video = map['video'],
        userID = map['userID'];

  InformasiModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => title  + deskripsi;
}
