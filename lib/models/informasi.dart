import 'package:cloud_firestore/cloud_firestore.dart';

class InformasiModel {
  String title;
  String menuID;
  String menuName;
  String subMenuID;
  String subMenuName;
  String deskripsi;
  String images;
  String video;
  String userID;

  final DocumentReference reference;

  InformasiModel.fromMap(Map<String, dynamic> map, {this.reference}){
        title = map['title'];
        menuID = map['menuID'];
        menuName = map['menuName'];
        subMenuID = map['subMenuID'];
        subMenuName = map['subMenuName'];
        deskripsi = map['deskripsi'];
        images = map['images'];
        video = map['video'];
        userID = map['userID'];
  }

  InformasiModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => title + deskripsi;
}
