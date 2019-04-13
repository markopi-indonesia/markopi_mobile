import 'package:flutter/material.dart';
import 'home.dart';
import 'colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markopi',
      theme: _markopiTheme,
      home: HomePage(),
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

