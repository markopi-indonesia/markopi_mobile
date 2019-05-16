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
      // stream: CategoryController.categoryStream,
      // builder: (context, snapshot) {
      //   if (!snapshot.hasData) {
      //     print("gak ada data");
      //     // return LinearProgressIndicator();
      //   }
      //   else{
      //     print("ada data");
      //   }
        // if (snapshot.data.documents.length > 0) {
        //   return SingleChildScrollView(
        //     physics: BouncingScrollPhysics(),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Padding(
        //           padding: const EdgeInsets.only(
        //               left: 16, right: 16, top: 16, bottom: 8),
        //           child: Text(
        //             "Categories List",
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 36,
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //           child: Text(
        //             "${snapshot.data.documents.length.toString()} Categories",
        //             style: TextStyle(fontSize: 16),
        //           ),
        //         ),
        //         _buildCategoryList(context, snapshot.data.documents),
        //       ],
        //     ),
        //   );
        // } else {
        //   return Center(
        //     child: Text(
        //       "Tidak ada daftar kategori.",
        //       style: Theme.of(context).textTheme.title,
        //     ),
        //   );
        // }
      // },
    );
  }

  Widget _buildCategoryList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildCategoryItem(context, data)).toList(),
    );
  }

  Widget _buildCategoryItem(BuildContext context, DocumentSnapshot data) {
    final Category = CategoryModel.fromSnapshot(data);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(Category.name),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddCategoryDialog(
                        docId: data.documentID,
                        name: Category.name,
                      ),
                  fullscreenDialog: true,
                ),
              ),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Delete',
          closeOnTap: false,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _buildConfirmationDialog(context, data.documentID),
        ),
      ],
    );
    // return Card(
    //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    //   child: Slidable.builder(
    //     secondaryActionDelegate: new SlideActionBuilderDelegate(
    //         actionCount: 2,
    //         builder: (context, index, animation, renderingMode) {
    //           if (index == 0) {
    //             return new IconSlideAction(
    //               caption: 'Edit',
    //               color: Colors.blue,
    //               icon: Icons.edit,
    //               onTap: () => Navigator.of(context).push(
    //                     MaterialPageRoute(
    //                       builder: (context) => AddCategoryDialog(
    //                             docId: data.documentID,
    //                             name: Category.name,
    //                           ),
    //                       fullscreenDialog: true,
    //                     ),
    //                   ),
    //               closeOnTap: false,
    //             );
    //           } else {
    //             return new IconSlideAction(
    //               caption: 'Delete',
    //               closeOnTap: false,
    //               color: Colors.red,
    //               icon: Icons.delete,
    //               onTap: () =>
    //                   _buildConfirmationDialog(context, data.documentID),
    //             );
    //           }
    //         }),
    //     key: Key(Category.name),
    //     child: ListTile(
    //       title: Text(Category.name),
    //       onTap: () => print(Category),
    //     ),
    //   ),
    // );
  }

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Category will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Delete'),
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
}
