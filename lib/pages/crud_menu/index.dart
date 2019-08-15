import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/controllers/menu_controller.dart';
import 'package:markopi_mobile/models/menu.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markopi_mobile/pages/crud_menu/add.dart';
import 'package:markopi_mobile/pages/crud_menu/edit.dart';
import 'package:markopi_mobile/pages/crud_submenu/index.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: _buildBody(context),
        floatingActionButton: buildAddMenuFab());
  }

  buildAddMenuFab() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _navigateToAddMenu();
      },
      child: Icon(Icons.add),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('menu').snapshots(),
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
    final menu = MenuModel.fromSnapshot(data);

    return Padding(
      key: ValueKey(menu.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => _navigateSubMenu(context, data.documentID, menu.color),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color(int.parse(menu.color)),
          ),
          child: Slidable(
            key: ValueKey(menu.name),
            actionPane: SlidableStrechActionPane(),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: () => _updateData(context, data.documentID, menu.name, menu.color, menu.image),
                // onTap: () => Navigator.of(context).push(),
                // closeOnTap: false,
              ),
              // IconSlideAction(
              //   caption: 'Hapus',
              //   color: Colors.red,
              //   icon: Icons.delete,
              //   onTap: () => _buildConfirmationDialog(context, data.documentID),
              // ),
            ],
            child: ListTile(
              title: Text(
                menu.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus'),
          content: Text('Anda yakin ingin menghapus kategori?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Hapus'),
                onPressed: () {
                  MenuController.removeMenu(documentID);
                  Navigator.of(context).pop(true);
                }),
          ],
        );
      },
    );
  }

  void _navigateSubMenu(BuildContext context, String documentID, String _color){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubMenu(
          menuId: documentID,
          color: _color,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _navigateToAddMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMenuDialog(),
        fullscreenDialog: true,
      ),
    );
  }

  void _updateData(BuildContext context, String documentID, String _name, String _color, String _image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditMenuDialog(
              docId: documentID,
              name: _name,
              color: _color,
              image: _image
            ),
        fullscreenDialog: true,
      ),
    );
  }
}
