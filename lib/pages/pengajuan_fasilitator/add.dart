import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:markopi_mobile/resources/repository.dart';

class AddPengajuanDialog extends StatefulWidget {
  @override
  _AddPengajuanDialogState createState() => _AddPengajuanDialogState();
}

class _AddPengajuanDialogState extends State<AddPengajuanDialog> {
  final _formAddPengajuanKey = GlobalKey<FormState>();
  var _repository = Repository();
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  File ktp;
  File selfie;
  String pengalaman;
  String sertifikat;
  String status;
  String pesan;
  DateTime dateTime;
  String _errorMessage;
  String urls = "";
//  Future<File> _imageFile;
  bool _isIos;
  bool _isLoading;
  FirebaseUser currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userID = "";
  String ownerRole = "";
  StorageReference _storageReference;
  TextEditingController _controller = new TextEditingController();

  void _openFileExplorer() async {
    try {
      _path = null;
      _paths = await FilePicker.getMultiFilePath();
      print("test");
      print(_extension);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

    setState(() {
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  bool _validateAndSave() {
    final form = _formAddPengajuanKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    print("A");
    if (_validateAndSave()) {
      try {
        print("B");
        addPengajuan();
        print("C");
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addPengajuan() async {
    print("D");
    final docRef =
        await Firestore.instance.collection('pengajuan').add({
      'userID': userID,
      'ktp': '',
      "selfie": '',
      'pengalaman': pengalaman,
      'sertifikat': '',
      'status': 'Menunggu',
      'pesan': '',
      'dateTime': DateTime.now(),
    });
    
    print(docRef.documentID);
    _repository.uploadImageToStorage(ktp).then((url) {
      _repository.addKTP(url, docRef.documentID).then((v) {});
    });
    _repository.uploadImageToStorage(selfie).then((url) {
      _repository.addSelfie(url, docRef.documentID).then((v) {});
    });
    uploadToFirebase(docRef.documentID);
  }

  uploadToFirebase(String docID) async{
    _paths.forEach((fileName, filePath) => {upload(fileName, filePath, docID)});
  }

  upload(fileName, filePath, docID) async {
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$FileType.ANY/$_extension',
      ),
    );
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    if (urls.isEmpty) {
      urls = url;
    } else {
      urls = urls + ";" + url;
    }
    print(urls);
    _repository.addSertifikat(urls, docID);
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currentUser = user;
          userID = user?.uid;
        }
      });
    });
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        // drawer: DrawerPage(),
        body: Stack(
          children: <Widget>[
            _showForm(),
            // _builder(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showForm() {
    return new Form(
      key: _formAddPengajuanKey,
      autovalidate: false,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Pengajuan').snapshots(),
          builder: (context, snapshot) {
            return new ListView(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Center(
                          child: Text(
                            "Form Tambah Pengajuan Fasilitator",
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',fontWeight: FontWeight.bold, fontSize: 20.0,color:Color(0xFF3B444F)),
                          ),
                        ),
                        Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "1. Unggah Gambar Kartu Tanda Penduduk",
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',fontWeight: FontWeight.bold, fontSize: 15.0,color:Color(0xFF3B444F)),
                          ),
                        ),
                         Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SizedBox(
                               height: 43.0,
                               width: 420.0,
                               child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(3.0)),
                            color: Color(0xFFABDCFF),
                            // child: new Image.asset('assets/camera.png'),
                            child: new Text('Unggah Gambar KTP',
                                style: new TextStyle(
                                    fontFamily: 'SF Pro Text', fontSize: 15.0,color:Color(0xFF3B444F))
                                    ),
                            onPressed: _showKTPDialog,
                          ),
                          ),
                         ),
                          // onTap: loadAssets,
                        
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "2. Unggah Gambar Selfie",
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',fontWeight: FontWeight.bold, fontSize: 15.0,color:Color(0xFF3B444F)),
                          ),
                        ),
                        
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SizedBox(
                               height: 43.0,
                               width: 420.0,
                               child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(3.0)),
                            color: Color(0xFFABDCFF),
                            // child: new Image.asset('assets/camera.png'),
                            child: new Text('Unggah Gambar Selfie',
                                style: new TextStyle(
                                    fontFamily: 'SF Pro Text', fontSize: 15.0,color:Color(0xFF3B444F))
                                    ),
                            onPressed: _showSelfieDialog,
                          ),
                          ),
                         ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "3. Masukan Pengalaman Anda",
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',fontWeight: FontWeight.bold, fontSize: 15.0,color:Color(0xFF3B444F)),
                          ),
                        ),
                        new TextFormField(
                          maxLines: 10,
                          decoration: new InputDecoration(
                              hintText: "Pengalaman",
                              labelText: "Pengalaman",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          validator: (value) => value.isEmpty
                              ? 'Pengalaman Pengajuan tidak boleh kosong'
                              : null,
                          onSaved: (value) => pengalaman = value,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "4. Unggah Gambar Sertifikat Anda",
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',fontWeight: FontWeight.bold, fontSize: 15.0,color:Color(0xFF3B444F)),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: SizedBox(
                               height: 43.0,
                               width: 420.0,
                          child: new RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            color: Color(0xFFABDCFF),
                            child: new Text('Unggah Sertifikat',
                                style: new TextStyle(
                                    fontFamily: 'SF Pro Text', fontSize: 15.0,color:Color(0xFF3B444F))
                                    ),
                            onPressed: () => _openFileExplorer(),
                          ),
                          // onTap: loadAssets,
                        ),
                      ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: SizedBox(
                              height: 40.0,
                              child: new RaisedButton(
                                elevation: 5.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                color: Color(0xFF2696D6),
                                child: new Text('Simpan Pengajuan',
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                                onPressed: () =>  _validateAndSubmit(),
                              ),
                            ))
                      ],
                    )),
              ],
            );
          }),
    );
  }

  Widget _builder() {
    return new Builder(
      builder: (BuildContext context) => _path != null || _paths != null
          ? new Container(
              padding: const EdgeInsets.only(bottom: 30.0),
              height: MediaQuery.of(context).size.height * 0.50,
              child: new Scrollbar(
                  child: new ListView.separated(
                itemCount:
                    _paths != null && _paths.isNotEmpty ? _paths.length : 1,
                itemBuilder: (BuildContext context, int index) {
                  final bool isMultiPath = _paths != null && _paths.isNotEmpty;
                  final String name = 'File $index: ' +
                      (isMultiPath
                          ? _paths.keys.toList()[index]
                          : _fileName ?? '...');
                  final path = isMultiPath
                      ? _paths.values.toList()[index].toString()
                      : _path;

                  return new ListTile(
                    title: new Text(
                      name,
                    ),
                    subtitle: new Text(path),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    new Divider(),
              )),
            )
          : new Container(),
    );
  }

  _showKTPDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Pilih dari Galeri',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 17),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      ktp = selectedImage;
                      // _isLoading = true;
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Ambil dari Kamera',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 17),
                ),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      ktp = selectedImage;
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Batal',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showSelfieDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Pilih dari Galeri',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 17),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      selfie = selectedImage;
                      // _isLoading = true;
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Ambil dari Kamera',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 17),
                ),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      selfie = selectedImage;
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Batal',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }
}
