import 'package:cloud_firestore/cloud_firestore.dart';

class Menu{
  String name;
  String color;
  String image;

  DocumentReference reference;

  Menu(this.name, this.color, this.image);

  Menu.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map['name'] != null),
    assert(map['color'] != null),
    assert(map['image'] != null),
    name = map['name'],
    color = map['color'],
    image = map['image'];

  Menu.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);

  static List<Menu> mapJsonStringToList(List<dynamic> jsonList){
    return jsonList.map(
      (m) => Menu(
       m['name'],
       m['color'],
       m['image'],
      )
    ).toList();
  }

  @override
  String toString() => "Menu<$name>";
}