import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';

class BottomCartNavBarOrg extends StatelessWidget {
  final FirebaseUser user;
  final BuildContext context;
  final TabController tabController;
  final int index;
  const BottomCartNavBarOrg ({Key key, this.context, this.tabController, this.index, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle getTextStyle(int pos) {
      return TextStyle(
        fontFamily: FontNameDefault,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: index == null
            ? Colors.blue
            : index == pos ? Colors.blue : Colors.blue.withOpacity(0.5),
      );
    }

    return SafeArea(
      bottom: true,
      child: Container(
        height: 55,
        padding: EdgeInsets.only(top: 5),
        child: BottomAppBar(
          color: Colors.white,
          child: TabBar(

            key: new GlobalKey(),
            onTap: (i) {
              if (i == 0) {
                if (index != 0) {
                  if(user!=null){
                    Navigator.pushNamed(context, AppRoute.TRANSACTION_ROUTE,arguments: {"isAdmin":false});
                  }else {
                    CustomWidget.showFlushBar(
                        context, "Anda belum login, Silahkan login terlebih dahulu");
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamed(context, '/login', arguments: {"isEdit": false});
                    });
                  }
                }
              } else if (i == 1) {
                if (index != 1) {
                  if(user!=null){
                    Navigator.pushNamed(context, AppRoute.CART_ROUTE);
                  }else {
                    CustomWidget.showFlushBar(
                        context, "Anda belum login, Silahkan login terlebih dahulu");
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamed(context, '/login', arguments: {"isEdit": false});
                    });
                  }
                }
              }
            },
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            controller: tabController,
            tabs: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.content_paste,
                      size: 22,
                      color: index == null
                          ? Colors.blue
                          : index == 0
                              ? Colors.blue
                              : Colors.blue.withOpacity(0.5)),
                  Text('Transaksi', style: getTextStyle(0)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 22,
                    color: index == null
                        ? Colors.blue
                        : index == 1
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.5),
                  ),
                  Text('Keranjang', style: getTextStyle(1)),
                ],
              ),
//                Column(
//                  children: <Widget>[
//                    Icon(Icons.collections_bookmark,
//                        size: 22, color: index==2? Colors.blue:Colors.blue.withOpacity(0.5)),
//                    Text(
//                      'Whislists',
//                      style: getTextStyle(2),
//                    ),
//                  ],
//                ),
//                Column(
//                  children: <Widget>[
//                    Icon(Icons.person, size: 22, color: index==3? Colors.blue:Colors.blue.withOpacity(0.5)),
//                    Text(
//                      'Profile',
//                      style: getTextStyle(3),
//                    ),
//                  ],
//                ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
