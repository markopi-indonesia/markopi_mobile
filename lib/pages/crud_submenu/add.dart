import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markopi_mobile/components/header_back.dart';

class AddSubMenuDialog extends StatefulWidget {
  final String menuId;

  AddSubMenuDialog({this.menuId});
  @override
  _AddSubMenuDialogState createState() => _AddSubMenuDialogState();
}

class _AddSubMenuDialogState extends State<AddSubMenuDialog> {
  final _formAddSubMenuKey = GlobalKey<FormState>();
  String _name;
  bool _isLoading;

  bool _validateAndSave() {
    final form = _formAddSubMenuKey.currentState;
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
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        addSubMenu();
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addSubMenu() async {
    await Firestore.instance.collection('submenu').add({
      'name': _name,
      "menuId": widget.menuId,
    });
  }

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showForm() {
    return new Form(
      key: _formAddSubMenuKey,
      autovalidate: false,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('submenu').snapshots(),
          builder: (context, snapshot) {
            return new ListView(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Center(
                          child: Text(
                            "Form Tambah SubMenu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Nama SubMenu",
                              labelText: "Nama SubMenu",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          validator: (value) => value.isEmpty
                              ? 'Nama SubMenu tidak boleh kosong'
                              : null,
                          onSaved: (value) => _name = value,
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
                                color: Colors.blue,
                                child: new Text('Simpan Sub Menu',
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
