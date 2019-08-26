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

  final DocumentReference reference;

  ProfileModel.fromMap(Map<String, dynamic> map, {this.reference}) {
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

  ProfileModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

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
