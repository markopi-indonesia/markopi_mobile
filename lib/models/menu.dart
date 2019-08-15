import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  final String name;
  final String color;
  final String image;
  final DocumentReference reference;

  MenuModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null && map['color'] != null && map['image'] != null),
        name = map['name'], color = map['color'], image = map['image'];

  MenuModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => name + color + image;
}
