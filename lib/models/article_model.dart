import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String userId;
  String  title;
  String deskripsi;
  String coverImage;
  String ownerRole;
  String images;
  String video;
  String categoryId;

  DocumentReference reference;

  Article(this.userId, this.title, this.deskripsi, this.coverImage,
      this.ownerRole, this.images, this.video, this.categoryId);

  Article.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['userID'] != null),
        assert(map['title'] != null),
        assert(map['deskripsi'] != null),
        assert(map['cover'] != null),
        assert(map['ownerRole'] != null),
        assert(map['images'] != null),
        assert(map['video'] != null),
        assert(map['categoryID'] != null),
        userId = map['userID'],
        title = map['title'],
        deskripsi = map['deskripsi'],
        coverImage = map['cover'],
        ownerRole = map['ownerRole'],
        images = map['images'],
        video = map['video'],
        categoryId = map['categoryID'];

  Article.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  static List<Article> mapJsonStringToList(List<dynamic> jsonList) {
    return jsonList
        .map((p) => Article(
      p['userID'],
      p['title'],
      p['deskripsi'],
      p['cover'],
      p['ownerRole'],
      p['images'],
      p['video'],
      p['categoryID'],
    ))
        .toList();
  }

  @override
  String toString() => "Article<$title:$deskripsi>";
}
