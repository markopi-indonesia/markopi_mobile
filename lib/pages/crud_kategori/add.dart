import 'package:flutter/cupertino.dart';
import 'package:markopi_mobile/controllers/category_controller.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class AddCategoryDialog extends StatefulWidget {
  final String name;
  final String docId;

  AddCategoryDialog({this.name, this.docId});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formAddCategoryKey = GlobalKey<FormState>();
  String _name;
//  Future<File> _imageFile;

  String validateName(String value) {
    if (value.isEmpty) {
      return "Nama kategori tidak boleh kosong.";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              final form = _formAddCategoryKey.currentState;
              if (form.validate()) {
                form.save();
                if (widget.name != null && widget.name.isNotEmpty) {
                  CategoryController.updateCategory(widget.docId, _name);
                } else {
                  CategoryController.addCategory(_name);
                }
                Navigator.pop(context);
              }
            },
            child: Text(
              widget.name != null && widget.name.isNotEmpty ? "UBAH" : 'SIMPAN',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formAddCategoryKey,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Nama Kategori',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            keyboardType: TextInputType.text,
            initialValue: widget.name != null && widget.name.isNotEmpty
                ? widget.name
                : "",
            validator: (value) {
              return validateName(value);
            },
            onSaved: (value) => _name = value,
          ),
        ),
      ),
    );
  }
}