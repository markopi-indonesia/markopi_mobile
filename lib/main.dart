import 'package:flutter/material.dart';
import 'package:markopi_mobile/pages/manage_informasi/index.dart';
import 'package:markopi_mobile/pages/manage_user/index.dart';
import 'package:markopi_mobile/ui/menu/home.dart';
import 'package:markopi_mobile/ui/color/colors.dart';
import 'package:markopi_mobile/pages/authentication/register.dart';
import 'package:markopi_mobile/pages/authentication/login.dart';
import 'package:markopi_mobile/pages/crud_kategori/index.dart';
import 'package:markopi_mobile/pages/crud_menu/index.dart';
import 'package:markopi_mobile/pages/crud_informasi/index.dart';
import 'package:markopi_mobile/pages/profile/index.dart';
import 'package:markopi_mobile/pages/video.dart';
import 'package:markopi_mobile/pages/pengajuan_fasilitator/index_fasilitator.dart';
import 'package:markopi_mobile/ui/menu/AnimatedSplashScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Markopi',
      theme: _markopiTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => AnimatedSplashScreen(),
        '/home': (context) => HomePage(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/video': (context) => AddVideoDialog(),
        '/menu': (context) => ManageMenu(),
        '/manage-informasi': (context) => ManageInformasi(),
        '/manage-user': (context) => ManageUser(),
        '/informasi': (context) => Informasi(),
        '/profile': (context) => IndexProfileDialog(),
        '/pengajuan_fasilitator': (context) => PengajuanFasilitator(),
      },
    );
  }
}

final ThemeData _markopiTheme = _buildMarkopiTheme();

ThemeData _buildMarkopiTheme(){
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    primaryColor: kShrineBackgroundWhite,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    errorColor: kShrineErrorRed,
    primaryIconTheme: base.iconTheme.copyWith(
        color: kShrineAltBlack
    ),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',

    displayColor: kShrineAltBlack,
    bodyColor: kShrineAltBlack,
  );

  
}

