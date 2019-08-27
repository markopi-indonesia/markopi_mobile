import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:markopi_mobile/models/submenu.dart';
import 'package:markopi_mobile/pages/crud_submenu/add.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/ui/menu/informasi.dart';

class SubMenu extends StatefulWidget {
  final String color;
  final String menuId;
  final String role;

  SubMenu({this.menuId, this.color, this.role});
  @override
  State<StatefulWidget> createState() => new _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  int x = 2;
  int color_num;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: HeaderBack(),
      body: _buildBody(context),
      floatingActionButton: new Visibility(
        visible: widget.role == "Admin" ? true : false,
        child: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddSubMenuDialog(
                  menuId: widget.menuId,
                ),
                fullscreenDialog: true,
              ),
            );
          },
          child: new Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('submenu')
          .where("menuId", isEqualTo: widget.menuId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      // shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final submenu = SubMenuModel.fromSnapshot(data);
    x = x + x;
    color_num = int.parse(widget.color) + x;
    return Padding(
      key: ValueKey(submenu.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(color_num),
        ),
        child: ListTile(
          onTap: () => _navigateCategory(
              context, submenu.reference.documentID, color_num.toString()),
          title: Text(
            submenu.name,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _navigateCategory(
      BuildContext context, String documentID, String _color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Informasi(
          documentID: documentID,
          color: _color,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
