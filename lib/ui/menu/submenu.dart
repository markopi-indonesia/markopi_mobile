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
  final String menuName;

  SubMenu({this.menuId, this.color, this.role, this.menuName});
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
        body: Stack(
          children: <Widget>[
            _header(),
            _buildBody(context),
          ],
        ),
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
        ));
  }

  Widget _header() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 0.0),
        child: Container(
          constraints: new BoxConstraints(
            minHeight: 50.0,
            minWidth: 320.0,
            maxHeight: 50.0,
            maxWidth: 1000.0,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF0F6FE),
          ),
          child: Text(
            widget.menuName,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3b444f)),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
        ));
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
      padding: const EdgeInsets.only(top: 80.0),
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
          onTap: () => _navigateSubMenu(
              context, widget.menuId , submenu.reference.documentID, color_num.toString()),
          title: Text(
            submenu.name,
            style: TextStyle(color: Color(0xff3b444f)),
          ),
        ),
      ),
    );
  }

  void _navigateSubMenu(
      BuildContext context, String menuID, String subMenuID, String _color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Informasi(
          menuID: menuID,
          subMenuID: subMenuID,
          color: _color,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
