import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/models/profile.dart';
import 'package:markopi_mobile/pages/manage_user/detail.dart';
import 'package:markopi_mobile/resources/repository.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class ManageUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  var _repository = Repository();
  String _userID;
  String _nama;
  String _role;
  String _photoUrl;
  String _profesi;
  String _noHP;
  String _provinsi;
  String _kabupaten;
  String _kecamatan;
  String _alamat;
  String _bio;
  String _docID;
  String _errorMessage;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _photoUrlController = TextEditingController();
  TextEditingController _profesiController = TextEditingController();
  TextEditingController _noHPController = TextEditingController();
  TextEditingController _provinsiController = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

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

              if (listProfile.isEmpty) {
                print('profile is empty');
              }

              return ListView.builder(
                itemCount: listProfile.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => _navigateToEditProfile(context, listProfile[index].userID),
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

void _navigateToEditProfile(BuildContext context, String userID) {
    print("masuk");
    print(userID);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndexProfileAdmin(
          userID: userID,
        ),
        fullscreenDialog: true,
      ),
    );
  }