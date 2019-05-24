import 'package:flutter/material.dart';
import 'package:markopi_mobile/ui/menu/detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/models/informasi.dart';
import 'package:markopi_mobile/ui/menu/detail.dart';

class SubMenu extends StatefulWidget {
  final String title;
  final String documentID;
  final Image image;

  SubMenu(
      {Key key,
      @required this.documentID,
      @required this.title,
      @required this.image})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new SubMenuState();
}

class SubMenuState extends State<SubMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: _buildBody(context),

//       body: Row(
//         children: <Widget>[
//           Flexible(
//               flex: 3,
//               child: Container(
//                 child: Center(
//                   child: new FractionallySizedBox(
//                     widthFactor: 1.0,
//                     heightFactor: 0.9,
//                     child: new Container(
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.rectangle,
// //                        color: Colors.orange,
//                       ),
//                       child: Column(
//                         children: <Widget>[
//                           Text(widget.title,
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 22.0,
//                                   fontWeight: FontWeight.w900)),
//                           Padding(
//                             padding: EdgeInsets.only(top: 20.0),
//                             child: Column(
//                               children: <Widget>[
//                                 Container(
//                                   height:
//                                       MediaQuery.of(context).size.height / 3,
//                                   child: widget.image,
//                                 ),
//                                 _buildBody(context)
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
// //              Center(
// //                  child: Text(
// //                    "Size ${media.width} * ${media.height}",
// //                    style: Theme.of(context).textTheme.title,
// //                  )
// //              ),
//               )),
//         ],
//       ),
        );
  }

  

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('informasi')
          .where("categoryID", isEqualTo: widget.documentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      child: ListView(
        // shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final informasi = InformasiModel.fromSnapshot(data);

    return Padding(
      key: ValueKey(informasi.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: new ListTile(
          leading: new CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(informasi.cover),
          ),
          title: new Text(informasi.title),
          onTap: () => _detail(
              context,
              data.documentID,
              informasi.categoryID,
              informasi.cover,
              informasi.deskripsi,
              informasi.images,
              informasi.ownerRole,
              informasi.title,
              informasi.userID,
              informasi.video),
        ),
      ),
    );
  }

  void _detail(
    BuildContext context,
    String documentID,
    String categoryID,
    String cover,
    String deskripsi,
    String images,
    String ownerRole,
    String title,
    String userID,
    String video,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailInformasi(
              documentID: documentID,
              categoryID: categoryID,
              cover: cover,
              deskripsi: deskripsi,
              images: images,
              ownerRole: ownerRole,
              title: title,
              userID: userID,
              video: video,
            ),
        fullscreenDialog: true,
      ),
    );
  }
}

// class SubMenuImageAsset extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AssetImage assetImage = AssetImage('assets/pola_tanam.jpeg');
//     Image image = Image(image: assetImage);
//     return image;
//   }
// }

// class SubMenuButton extends StatelessWidget {
//   SubMenuButton({this.name});

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Container(
//             width: 300.0,
//             height: 50.0,
//             margin: EdgeInsets.only(top: 30.0),
//             child: OutlineButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0)),
//               borderSide: BorderSide(color: Colors.black),
//               child: Text(this.name, style: TextStyle(color: Colors.redAccent)),
//               color: Colors.white,
//               splashColor: Colors.blueGrey,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => DetailMenu()));
//               },
//             ))
//       ],
//     );
//   }
// }
