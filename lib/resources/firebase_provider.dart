import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FirebaseProvider {
  final Firestore _firestore = Firestore.instance;
  StorageReference _storageReference;

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<String> uploadVideoToStorage(File videoFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(videoFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<String> saveImage(Asset asset) async {
    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = ref.putData(imageData);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['photoURL'] = photoUrl;
    return _firestore.collection("profile").document(uid).updateData(map);
  }

  Future<void> addPhoto(String photoUrl, String id) async {
    Map<String, dynamic> map = Map();
    map['cover'] = photoUrl;
    return _firestore.collection("informasi").document(id).updateData(map);
  }

  Future<void> addImage(String photoUrl, String id) async {
    Map<String, dynamic> map = Map();
    map['images'] = photoUrl;
    return _firestore.collection("informasi").document(id).updateData(map);
  }

  Future<void> addVideo(String videoUrl, String id) async {
    Map<String, dynamic> map = Map();
    map['video'] = videoUrl;
    return _firestore.collection("informasi").document(id).updateData(map);
  }

  Future<void> addKTP(String photoUrl, String id) async {
    Map<String, dynamic> map = Map();
    map['ktp'] = photoUrl;
    return _firestore.collection("pengajuan").document(id).updateData(map);
  }

  Future<void> addSelfie(String photoUrl, String id) async {
    Map<String, dynamic> map = Map();
    map['selfie'] = photoUrl;
    return _firestore.collection("pengajuan").document(id).updateData(map);
  }

  Future<void> addSertifikat(String photoUrl, String id) async {
    Map<String, dynamic> map = Map();
    map['sertifikat'] = photoUrl;
    return _firestore.collection("pengajuan").document(id).updateData(map);
  }
}
