

import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class PurchaseCourierList extends StatefulWidget {
  @override
  _PurchaseCourierListState createState() => _PurchaseCourierListState();
}

class _PurchaseCourierListState extends State<PurchaseCourierList> {
  final List<Map<String,dynamic>> _courierSample = [
    {
      "name":"J&T",
      "duration":"Express(1-2 hari)"
    },
    {
      "name":"TIKI",
      "duration":"Express(3-4 hari)"
    },
    {
      "name":"Sicepat",
      "duration":"Express(1-2 hari)"
    },
  ];

  String _picked ;
  @override
  void initState() {
    super.initState();
    _picked = _courierSample[0]['name'];
  }

  @override
  Widget build(BuildContext context) {
    return RadioButtonGroup(
        itemBuilder: (radioButton, label, index) {
          return ListTile(
            title: label,
            trailing: radioButton,
            subtitle: Text(_courierSample[index]['duration']),
          );
        },
        onSelected: (v){
          setState(() {
          _picked=v;
          });
        },
        picked: _picked,
        labels: List.from(_courierSample.map((e) => e['name'])));
  }
}
