import 'package:cloud_firestore/cloud_firestore.dart';

class PengajuanFasilitatorModel {
  final String userID;
  final String ktp;
  final String selfie;
  final String pengalaman;
  final String sertifikat;
  final String status;
  final String pesan;
  final Timestamp dateTime;

  final DocumentReference reference;

  PengajuanFasilitatorModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['userID'] != null && map['ktp'] != null && map['selfie'] != null && map['pengalaman'] != null && map['sertifikat'] != null && map['status'] != null&& map['pesan'] != null&& map['dateTime'] != null),
        userID = map['userID'], ktp = map['ktp'], selfie = map['selfie'], pengalaman = map['pengalaman'], sertifikat = map['sertifikat'], status = map['status'], pesan = map['pesan'], dateTime = map['dateTime'];

  PengajuanFasilitatorModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => userID + ktp + selfie;
}