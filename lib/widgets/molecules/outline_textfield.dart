
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MolTextField{
  BuildContext context;

  MolTextField(this.context):assert(context!=null);

  Widget outlineTextField({
    @required controller,
    String hint,
    FormFieldValidator<String> validator,
    TextInputType textInputType = TextInputType.text,
    Widget prefix,
    int lines=1,
  }){
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: textInputType,
      maxLines: lines,
      showCursor: true,
      decoration: InputDecoration(
        prefixIcon: prefix??null,
        hintText: hint,
        border: OutlineInputBorder(),

      ),
    );
  }
}