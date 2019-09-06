import 'package:cloud_firestore/cloud_firestore.dart';

class PengajuanFasilitatorModel {
  String userID;
  String ktp;
  String selfie;
  String pengalaman;
  String sertifikat;
  String status;
  String pesan;
  Timestamp dateTime;

  final DocumentReference reference;

  PengajuanFasilitatorModel.fromMap(Map<String, dynamic> map, {this.reference}){
        this.userID = map['userID'];
        this.ktp = map['ktp'];
        this.selfie = map['selfie'];
        this.pengalaman = map['pengalaman'];
        this.sertifikat = map['sertifikat'];
        this.status = map['status'];
        this.pesan = map['pesan'];
        this.dateTime = map['dateTime'];
  }

  PengajuanFasilitatorModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => userID + ktp + selfie;
}
