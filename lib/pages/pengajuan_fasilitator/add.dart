import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:markopi_mobile/components/header_back.dart';

class AddPengajuanDialog extends StatefulWidget {
  @override
  _AddPengajuanDialogState createState() => _AddPengajuanDialogState();
}

class _AddPengajuanDialogState extends State<AddPengajuanDialog> {
  final _formAddPengajuanKey = GlobalKey<FormState>();
  String _name;
  String _color;
  String _image;
  String _errorMessage;
//  Future<File> _imageFile;
  bool _isIos;
  bool _isLoading;

  List<AssetImage> listIcons = [];

  Color currentColor = Colors.amber;

  String currentAsset = "";

  void changeColor(Color color) => setState(() => currentColor = color);

  void _setIconPengajuan(String asset) => setState(() => currentAsset = asset);

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
    if (_validateAndSave()) {
      try {
        addPengajuan();
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
    final docRef = await Firestore.instance.collection('Pengajuan').add({
      'name'  : _name,
      'color' : currentColor.value.toString(),
      "image" : currentAsset
    });
    print(docRef.documentID);
  }

  void _loadIconAsset() {
    setState(() {
      listIcons.add(AssetImage('assets/Pengajuan_icon/bag-2.png'));
      listIcons.add(AssetImage('assets/Pengajuan_icon/coffee-plant-2.png'));
      listIcons.add(AssetImage('assets/Pengajuan_icon/food-4.png'));
      listIcons.add(AssetImage('assets/Pengajuan_icon/maps-and-location-2.png'));
      listIcons.add(AssetImage('assets/Pengajuan_icon/mug-copy.png'));
      listIcons.add(AssetImage('assets/Pengajuan_icon/plant-3.png'));
    });
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _loadIconAsset();
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
                            "Form Tambah Pengajuan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Nama Pengajuan",
                              labelText: "Nama Pengajuan",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          validator: (value) => value.isEmpty
                              ? 'Nama Pengajuan tidak boleh kosong'
                              : null,
                          onSaved: (value) => _name = value,
                        ),

                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
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
                            child: const Text('Pilih warna Pengajuan'),
                            color: currentColor,
                            textColor: useWhiteForeground(currentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          ),
                        ),
                        // new Padding(padding: new EdgeInsets.only(top: 20.0)),
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
                                      content: AspectRatio(
                                        aspectRatio: 12 / 20,
                                        child: GridView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                                8.0, 20.0, 8.0, 20.0),
                                            itemCount: listIcons.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  _setIconPengajuan(listIcons[index]
                                                      .assetName.toString());

                                                  print("=== ${currentAsset}");
                                                },
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Color(0xffE3EFFF),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          child: Image(
                                                            image: listIcons[index],
                                                          ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    );
                                  });
                            },
                            child: const Text('Pilih ikon Pengajuan'),
                            color: currentColor,
                            textColor: useWhiteForeground(currentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          ),
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
                                child: new Text('Simpan Pengajuan',
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

class IconPengajuan {
  String name;

  IconPengajuan(this.name);

  static IconPengajuan getJsonParser(dynamic json) {
    String name = json['name'];

    return new IconPengajuan(name);
  }
}
