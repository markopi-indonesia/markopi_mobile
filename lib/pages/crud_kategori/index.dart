import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/controllers/category_controller.dart';
import 'package:markopi_mobile/models/category.dart';
import 'package:markopi_mobile/pages/crud_kategori/add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: _buildBody(context),
        floatingActionButton: buildAddCategoryFab());
  }

  buildAddCategoryFab() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        _navigateToAddCategory();
      },
      child: Icon(Icons.add),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('category').snapshots(),
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
    final category = CategoryModel.fromSnapshot(data);

    return Padding(
      key: ValueKey(category.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Slidable(
          key: ValueKey(category.name),
          actionPane: SlidableScrollActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () => _updateData(context, data.documentID, category.name),
              // closeOnTap: false,
            ),
            IconSlideAction(
              caption: 'Hapus',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _buildConfirmationDialog(context, data.documentID),
            ),
          ],
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            onWillDismiss: (actionType) {
              return showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete'),
                    content: Text('Item will be deleted'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          child: ListTile(
            title: Text(category.name),
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
                  CategoryController.removeCategory(documentID);
                  Navigator.of(context).pop(true);
                }),
          ],
        );
      },
    );
  }

  void _navigateToAddCategory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCategoryDialog(),
        fullscreenDialog: true,
      ),
    );
  }

  void _updateData(BuildContext context, String documentID, String _name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCategoryDialog(
              docId: documentID,
              name: _name,
            ),
        fullscreenDialog: true,
      ),
    );
  }
}
