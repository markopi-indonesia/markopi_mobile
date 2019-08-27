import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/resources/firebase_provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();

  Future<String> uploadImageToStorage(File imageFile) => _firebaseProvider.uploadImageToStorage(imageFile);

  Future<String> uploadVideoToStorage(File videoFile) => _firebaseProvider.uploadVideoToStorage(videoFile);

  Future<void> updatePhoto(String photoUrl, String uid) => _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> addPhoto(String photoUrl, String id) => _firebaseProvider.addPhoto(photoUrl, id);

  Future<void> addImage(String photoUrl, String id) => _firebaseProvider.addImage(photoUrl, id);

  Future<void> addVideo(String videoUrl, String id) => _firebaseProvider.addVideo(videoUrl, id);

  Future<String> saveImage(Asset asset) => _firebaseProvider.saveImage(asset);

  Future<void> addKTP(String photoUrl, String id) => _firebaseProvider.addKTP(photoUrl, id);

  Future<void> addSelfie(String photoUrl, String id) => _firebaseProvider.addSelfie(photoUrl, id);

  Future<void> addSertifikat(String photoUrl, String id) => _firebaseProvider.addSertifikat(photoUrl, id);

}