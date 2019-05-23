import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  static Stream<QuerySnapshot> profileStream =
      Firestore.instance.collection('profile').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('profile');
  

  static addProfile(
      String userID,
      String nama,
      String photoURL,
      String role,
      String profesi,
      String noHP,
      String provinsi,
      String kabupaten,
      String kecamatan,
      String alamat,
      String bio) {
    // Firestore.instance.runTransaction((Transaction transaction) async {
    //   await reference.add({
    //     "userID": userID,
    //     "nama": nama,
    //     "role": role,
    //     "profesi": profesi,
    //     "noHP": noHP,
    //     "provinsi": provinsi,
    //     "kabupaten": kabupaten,
    //     "kecamatan": kecamatan,
    //     "alamat": alamat,
    //     "bio": bio
    //   });
    // });
    final Firestore _firestore = Firestore.instance;
    _firestore.collection("profile").document(userID).setData({
      "userID": userID,
      "nama": nama,
      "photoURL": photoURL,
      "role": role,
      "profesi": profesi,
      "noHP": noHP,
      "provinsi": provinsi,
      "kabupaten": kabupaten,
      "kecamatan": kecamatan,
      "alamat": alamat,
      "bio": bio
    });
  }

  static updateProfile(
      String id,
      String newNama,
      // String newPhotoURL,
      String newProfesi,
      String newNoHP,
      String newProvinsi,
      String newKabupaten,
      String newKecamatan,
      String newAlamat,
      String newBio) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "nama": newNama,
        "profesi": newProfesi,
        "noHP": newNoHP,
        "provinsi": newProvinsi,
        "kabupaten": newKabupaten,
        "kecamatan": newKecamatan,
        "alamat": newAlamat,
        "bio": newBio
      }).catchError((error) {
        print(error);
      });
    });
  }
}
