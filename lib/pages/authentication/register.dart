import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';

class Register extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
      );
    }
}