import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController {
  static Stream<QuerySnapshot> categoryStream =
      Firestore.instance.collection('category').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('category');

  static addCategory(String name) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "name": name,
      });
    });
  }

  static removeCategory(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateCategory(String id, String newName) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "name": newName,
      }).catchError((error) {
        print(error);
      });
    });
  }
}