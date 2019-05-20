import 'package:flutter/cupertino.dart';
import 'package:markopi_mobile/controllers/informasi_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddInformasiDialog extends StatefulWidget {
  @override
  _AddInformasiDialogState createState() => _AddInformasiDialogState();
}

class _AddInformasiDialogState extends State<AddInformasiDialog> {
  final _formAddCategoryKey = GlobalKey<FormState>();
  String title;
  String categoryID;
  String deskripsi;
  String _mySelection;
  String _errorMessage;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userID = "";

  bool _isIos;
  bool _isLoading;

  bool _validateAndSave() {
    final form = _formAddCategoryKey.currentState;
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
    if (_validateAndSave()) {
      try {
        setState(() {
          _isLoading = false;
        });
        InformasiController.addInformasi(title, categoryID, deskripsi, userID);
        Navigator.pop(context);
        // print("masuk");
        // print(title);
        // print(categoryID);
        // print(userID);
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
      print("tidak masuk");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    this.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userID = user?.uid;
        }
      });
    });
    super.initState();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showForm() {
    return new Form(
      key: _formAddCategoryKey,
      autovalidate: false,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('category').snapshots(),
          builder: (context, snapshot) {
            return new ListView(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Judul",
                              labelText: "Judul",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0))),
                          validator: (value) =>
                              value.isEmpty ? 'Judul tidak boleh kosong' : null,
                          onSaved: (value) => title = value,
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),

                        new FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                // icon: const Icon(Icons.color_lens),
                                // labelText: 'Kategori',
                                errorText:
                                    state.hasError ? state.errorText : null,
                              ),
                              isEmpty: categoryID == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  isDense: true,
                                  hint: new Text("Pilih Kategori"),
                                  value: _mySelection,
                                  onChanged: (String newValue) {
                                    state.didChange(newValue);
                                    print("Category ID = ");
                                    print(_mySelection);
                                    setState(() {
                                      _mySelection = newValue;
                                    });
                                  },
                                  items: snapshot.data.documents.map((map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.documentID.toString(),
                                      child: new Text(
                                        map["name"],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          validator: (_mySelection) {
                            print(_mySelection);
                            if (_mySelection == null) {
                              return "Kategori tidak boleh kosong";
                            }
                          },
                          onSaved: (value) => categoryID = value,
                        ),

                        // new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        // new TextField(
                        //   decoration: new InputDecoration(
                        //       hintText: "Foto Sampul",
                        //       labelText: "Foto Sampul",
                        //       border: new OutlineInputBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(20.0))),
                        // ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          maxLines: 6,
                          decoration: new InputDecoration(
                              hintText: "Deskripsi",
                              labelText: "Deskripsi",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0))),
                          validator: (value) => value.isEmpty
                              ? 'Deskripsi tidak boleh kosong'
                              : null,
                          onSaved: (value) => deskripsi = value,
                        ),
                        // new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        // new TextField(
                        //   decoration: new InputDecoration(
                        //       hintText: "Gambar",
                        //       labelText: "Gambar",
                        //       border: new OutlineInputBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(20.0))),
                        // ),
                        // new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        // new TextField(
                        //   decoration: new InputDecoration(
                        //       hintText: "Video",
                        //       labelText: "Video",
                        //       border: new OutlineInputBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(20.0))),
                        // ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                            child: SizedBox(
                              height: 40.0,
                              child: new RaisedButton(
                                elevation: 5.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                color: Colors.blue,
                                child: new Text('Simpan',
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                                onPressed: _validateAndSubmit,
                              ),
                            ))
                      ],
                    )),
              ],
            );
          }),
    );
  }
}
