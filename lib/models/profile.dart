import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String userID;
  String nama;
  String role;
  String photoUrl;
  String profesi;
  String noHP;
  String provinsi;
  String kabupaten;
  String kecamatan;
  String alamat;
  String bio;

  ProfileModel(
      {this.userID,
      this.nama,
      this.role,
      this.photoUrl,
      this.profesi,
      this.noHP,
      this.provinsi,
      this.kabupaten,
      this.kecamatan,
      this.alamat,
      this.bio});

  // final DocumentReference reference;

  // ProfileModel.fromMap(Map<String, dynamic> map, {this.reference})
  //     : assert(map['userID'] != null && map['nama'] != null && map['role'] != null && map['profesi'] != null
  //     && map['noHP'] != null && map['provinsi'] != null && map['kabupaten'] != null && map['alamat'] != null
  //     && map['photoUrl'] != null && map['bio'] != null),
  //       userID = map['userID'], nama = map['nama'], role = map['role'], noHP = map['noHP'], profesi = map['profesi'], provinsi = map['provinsi'],
  //       kabupaten = map['kabupaten'], kecamatan = map['kecamatan'], alamat = map['alamat'], photoUrl = map['photoUrl'],
  //       bio = map['bio'];

  // ProfileModel.fromSnapshot(DocumentSnapshot snapshot)
  //     : this.fromMap(snapshot.data, reference: snapshot.reference);

  ProfileModel.fromMap(Map<String, dynamic> map) {
    this.userID = map['userID'];
    this.nama = map['nama'];
    this.role = map['role'];
    this.noHP = map['noHP'];
    this.profesi = map['profesi'];
    this.provinsi = map['provinsi'];
    this.kabupaten = map['kabupaten'];
    this.kecamatan = map['kecamatan'];
    this.alamat = map['alamat'];
    this.photoUrl = map['photoURL'];
    this.bio = map['bio'];
  }

  @override
  String toString() =>
      nama +
      role +
      profesi +
      photoUrl +
      noHP +
      provinsi +
      kabupaten +
      kecamatan +
      alamat +
      bio;
}
