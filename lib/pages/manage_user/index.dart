import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/models/profile.dart';
import 'package:markopi_mobile/pages/manage_user/detail.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class ManageUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('profile').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              List<ProfileModel> listProfile = [];

              snapshot.data.documents.forEach(
                  (data) => listProfile.add(ProfileModel.fromSnapshot(data)));
              return ListView.builder(
                itemCount: listProfile.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => _navigateToProfile(
                          context, listProfile[index].userID),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Slidable(
                          key: ValueKey(listProfile[index].noHP),
                          actionPane: SlidableStrechActionPane(),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete_forever,
                                onTap: () => showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Hapus Akun'),
                                        content: const Text(
                                            'Anda yakin akan menghapus akun ini?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: const Text('Tidak'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(ConfirmAction.CANCEL);
                                            },
                                          ),
                                          FlatButton(
                                            child: const Text('Ya'),
                                            onPressed: () {
                                              deleteUser(listProfile[index]
                                                  .reference
                                                  .documentID);
                                              Navigator.of(context)
                                                  .pop(ConfirmAction.ACCEPT);
                                            },
                                          )
                                        ],
                                      );
                                    }))
                          ],
                          child: ListTile(
                            title: Text(
                              listProfile[index].nama,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}

void deleteUser(String docId) {
  Firestore.instance.collection('profile').document(docId).delete();
}

void _navigateToProfile(BuildContext context, String userID) {
  Navigator.pop(context);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DetailProfile(
        userID: userID,
      ),
      fullscreenDialog: true,
    ),
  );
}
