import 'package:cloud_firestore/cloud_firestore.dart';

class InformasiController {
  static Stream<QuerySnapshot> informasiStream =
      Firestore.instance.collection('informasi').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('informasi');

  static addInformasi(String title, String categoryID, String deskripsi,
      String userID, String ownerRole) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "title": title,
        "categoryID": categoryID,
        "deskripsi": deskripsi,
        "userID": userID,
        "ownerRole": ownerRole,
      });
    });
  }

  static removeInformasi(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateInformasi(
      String id, String newTitle, String newCategoryID, String newDeskripsi) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "title": newTitle,
        "categoryID": newCategoryID,
        "deskripsi": newDeskripsi,
      }).catchError((error) {
        print(error);
      });
    });
  }
}
