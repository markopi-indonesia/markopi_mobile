import 'package:flutter/cupertino.dart';
import 'package:markopi_mobile/controllers/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markopi_mobile/components/header_back.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_colorpicker/utils.dart';

class EditMenuDialog extends StatefulWidget {
  final String docId;
  final String name;
  final String color;
  final String image;

  EditMenuDialog({
    this.docId,
    this.name,
    this.color,
    this.image,
  });
  @override
  _EditMenuDialogState createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  final _formAddMenuKey = GlobalKey<FormState>();
  String _name;
  String _docId;
  String _color;
  String _image;
  String _errorMessage;
//  Future<File> _imageFile;
  bool _isIos;
  bool _isLoading;

  Color currentColor = Colors.amber;

  void changeColor(Color color) => setState(() => currentColor = color);

  bool _validateAndSave() {
    final form = _formAddMenuKey.currentState;
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
        addMenu();
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

  void addMenu() async {
    final docRef = await Firestore.instance.collection('menu').add({
      'name': _name,
      'color': currentColor.value.toString(),
      "image": _image
    });
    print(docRef.documentID);
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        // drawer: DrawerPage(),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showForm() {
    return new Form(
      key: _formAddMenuKey,
      autovalidate: false,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('menu').snapshots(),
          builder: (context, snapshot) {
            return new ListView(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Center(
                          child: Text(
                            "Form Tambah Menu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Nama Menu",
                              labelText: "Nama Menu",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          validator: (value) => value.isEmpty
                              ? 'Nama menu tidak boleh kosong'
                              : null,
                          onSaved: (value) => _name = value,
                        ),

                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        // new TextFormField(
                        //   decoration: new InputDecoration(
                        //       hintText: "Warna Menu",
                        //       labelText: "Pilih warna",
                        //       border: new OutlineInputBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(5.0))),
                        //   validator: (value) =>
                        //       value.isEmpty ? 'Warna tidak boleh kosong' : null,
                        //   onSaved: (value) => _color = value,
                        // ),
                        Center(
                          child: RaisedButton(
                            elevation: 3.0,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    titlePadding: const EdgeInsets.all(0.0),
                                    contentPadding: const EdgeInsets.all(0.0),
                                    content: SingleChildScrollView(
                                      child: MaterialPicker(
                                        pickerColor: currentColor,
                                        onColorChanged: changeColor,
                                        enableLabel: true,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Pilih warna'),
                            color: currentColor,
                            textColor: useWhiteForeground(currentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                            elevation: 3.0,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Pilih warna'),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: currentColor,
                                        onColorChanged: changeColor,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Pilih warna'),
                            color: currentColor,
                            textColor: useWhiteForeground(currentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Gambar",
                              labelText: "Gambar",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          validator: (value) => value.isEmpty
                              ? 'Nama Gambar tidak boleh kosong'
                              : null,
                          onSaved: (value) => _image = value,
                        ),
                        // new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: SizedBox(
                              height: 40.0,
                              child: new RaisedButton(
                                elevation: 5.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                color: Colors.green,
                                child: new Text('Simpan Menu',
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
