import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:markopi_mobile/models/submenu.dart';
import 'package:markopi_mobile/pages/crud_submenu/add.dart';
import 'package:markopi_mobile/pages/crud_menu/edit.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/ui/menu/informasi.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SubMenu extends StatefulWidget {
  final String color;
  final String menuId;
  final String role;
  final String menuName;
  final String image;

  SubMenu({this.menuId, this.color, this.role, this.menuName, this.image});
  @override
  State<StatefulWidget> createState() => new _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
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
      // floatingActionButton: new Visibility(
      //   visible: widget.role == "Admin" ? true : false,
      //   child: new FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => AddSubMenuDialog(
      //             menuId: widget.menuId,
      //           ),
      //           fullscreenDialog: true,
      //         ),
      //       );
      //     },
      //     child: new Icon(Icons.add),
      //     backgroundColor: Colors.blue,
      //   ),
      // )
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: widget.role == "Admin" ? true : false,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
              label: 'Tambah Sub Menu',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSubMenuDialog(
                        menuId: widget.menuId,
                      ),
                      fullscreenDialog: true,
                    ),
                  )),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.green,
            label: 'Ubah Menu',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditMenuDialog(
                  color: widget.color,
                  docId: widget.menuId,
                  image: widget.image,
                  name: widget.menuName,
                ),
                fullscreenDialog: true,
              ),
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            label: 'Hapus Menu',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _buildConfirmationDialog(context, widget.menuId),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 0.0),
        child: Container(
          constraints: new BoxConstraints(
            minHeight: 40.0,
            minWidth: 320.0,
            maxHeight: double.infinity,
            maxWidth: 1000.0,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF0F6FE),
          ),
          child: Text(
            widget.menuName,
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3b444f)),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
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
      padding: const EdgeInsets.only(top: 80.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final submenu = SubMenuModel.fromSnapshot(data);
    return Padding(
      key: ValueKey(submenu.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(int.parse(widget.color)),
        ),
        child: ListTile(
          onTap: () => _navigateSubMenu(context, widget.menuId,
              submenu.reference.documentID, widget.color, submenu.name),
          title: Text(
            submenu.name,
            style: TextStyle(color: Color(0xffffffff)),
          ),
        ),
      ),
    );
  }

  void _navigateSubMenu(BuildContext context, String menuID, String subMenuID,
      String _color, String subMenuName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Informasi(
            menuID: menuID,
            subMenuID: subMenuID,
            color: _color,
            subMenuName: subMenuName),
        fullscreenDialog: true,
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
          content: Text('Apakah anda ingin menghapus menu ini?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Ya'),
                onPressed: () => {
                      Firestore.instance
                          .collection('menu')
                          .document(documentID)
                          .delete()
                          .catchError((e) {
                        print(e);
                      }),
                      Navigator.pop(context),
                      Navigator.pop(context),
                    }),
          ],
        );
      },
    );
  }
}
