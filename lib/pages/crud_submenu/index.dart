import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:markopi_mobile/controllers/submenu_controller.dart';
import 'package:markopi_mobile/models/submenu.dart';
import 'package:markopi_mobile/pages/crud_submenu/add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markopi_mobile/components/header_back.dart';

class SubMenu extends StatefulWidget {
  final String color;
  final String menuId;

  SubMenu({this.menuId, this.color});
  @override
  State<StatefulWidget> createState() => new _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  int x = 2;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: HeaderBack(),
        body: _buildBody(context),
        floatingActionButton: buildAddSubMenuFab());
  }

  buildAddSubMenuFab() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _navigateToAddSubMenu(context, widget.menuId);
      },
      child: Icon(Icons.add),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('submenu').where("menuId", isEqualTo: widget.menuId).snapshots(),
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
    return Padding(
      key: ValueKey(submenu.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(int.parse(widget.color)+x),
        ),
        child: Slidable(
          key: ValueKey(submenu.name),
          actionPane: SlidableScrollActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              // onTap: () => _updateData(context, data.documentID, submenu.name),
              // closeOnTap: false,
            ),
            IconSlideAction(
              caption: 'Hapus',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _buildConfirmationDialog(context, data.documentID),
            ),
          ],
          child: ListTile(
            title: Text(submenu.name, style: TextStyle(color: Colors.white),),
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
          content: Text('Anda yakin ingin menghapus sub menu?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Hapus'),
                onPressed: () {
                  SubMenuController.removeSubMenu(documentID);
                  Navigator.of(context).pop(true);
                }),
          ],
        );
      },
    );
  }

  void _navigateToAddSubMenu(BuildContext context, String _menuId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddSubMenuDialog(
              menuId: _menuId,              
        ),
        fullscreenDialog: true,
      ),
    );
  }

  // void _updateData(BuildContext context, String documentID, String _name) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => AddSubMenuDialog(
  //             docId: documentID,
  //             name: _name,
  //           ),
  //       fullscreenDialog: true,
  //     ),
  //   );
  // }
}
