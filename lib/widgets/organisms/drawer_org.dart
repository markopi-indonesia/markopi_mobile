

import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/colors.dart';

class OrgDrawer  {
  BuildContext context;
  OrgDrawer(this.context);
  Widget drawer(){
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white.withOpacity(0.9),
        ),
        child: Drawer(
            child: DrawerHeader(
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: CustomColor.mainColor
                      ),
                      accountEmail: Text("markopi_mobile@gmail.com"),
                      accountName: Text("markopi_mobile"),
                      currentAccountPicture: Image.asset("assets/sample/coffee.jpg",fit: BoxFit.cover,),
                    )
                  ],
                )
            )
        )
    );
  }
}
