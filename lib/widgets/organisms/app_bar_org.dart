import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';

class OrgAppBar {
  BuildContext context;

  OrgAppBar(this.context) : assert(context != null);

  Widget appBar(
      {@required String title,
      Widget action,
      bool hasBackButton = true,
      bool hasDrawer = false,
      bool hasSearch = false,
      bool blueMode = true,
      bool useCustomOnBackPressed = false,
      VoidCallback onPressedSearch,
      VoidCallback onPressedBackButton,
      double elevation = 2,
      VoidCallback onPressedDrawer}) {
    Widget getLeading() {
      if (hasBackButton && !hasDrawer) {
        return IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColor.darkBlueColor,
          ),
          iconSize: 20,
          onPressed: () {
            if(useCustomOnBackPressed){
              onPressedBackButton();

            }else
              Navigator.pop(context);
          },
        );
      }
      if (hasDrawer) {
        return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: onPressedDrawer);
      }

      return null;
    }

    return AppBar(
      brightness: Brightness.dark,
      backgroundColor: blueMode?CustomColor.mainColor:Colors.white,
      elevation: elevation,
      actions: <Widget>[
        hasSearch
            ? IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey[900],
                ),
                iconSize: 20,
                onPressed: onPressedSearch,
              )
            : action != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: action,
                  )
                : Container()
      ],
      leading: getLeading(),
      automaticallyImplyLeading:
          hasBackButton ? false : hasDrawer ? false : true,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: hasBackButton ? 0 : 15),
        child: Text(
          title,
          style: blueMode?Style20WhiteBold:Style20Black,
        ),
      ),
    );
  }
}
