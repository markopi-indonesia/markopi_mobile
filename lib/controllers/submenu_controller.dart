import 'package:cloud_firestore/cloud_firestore.dart';

class SubMenuController {
  static Stream<QuerySnapshot> subMenuStream =
      Firestore.instance.collection('submenu').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('submenu');

  static addSubMenu(String name, String menuId) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "name": name,
        "menuId": menuId,
      });
    });
  }

  static removeSubMenu(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateSubMenu(String id, String newName) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "name": newName,
      }).catchError((error) {
        print(error);
      });
    });
  }
}
