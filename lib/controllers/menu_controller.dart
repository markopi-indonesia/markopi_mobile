import 'package:cloud_firestore/cloud_firestore.dart';

class MenuController {
  static Stream<QuerySnapshot> menuStream =
      Firestore.instance.collection('menu').snapshots();

  static CollectionReference reference = Firestore.instance.collection('menu');

  static addMenu(String name, String color, String image) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "name": name,
        "color": color,
        "image": image,
      });
    });
  }

  static removeMenu(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateMenu(
      String id, String newName, String newColor, String newImage) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "name": newName,
        "color": newColor,
        "image": newImage,
      }).catchError((error) {
        print(error);
      });
    });
  }
}
