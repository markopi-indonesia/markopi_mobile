import 'package:cloud_firestore/cloud_firestore.dart';

class SubMenuModel {
  final String name;
  final DocumentReference reference;

  SubMenuModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  SubMenuModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => name;
}
