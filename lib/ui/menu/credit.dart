import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:url_launcher/url_launcher.dart';

class Credit extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: Container(
            child: Stack(
          children: <Widget>[_showBody()],
        )));
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(12.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              // _showLogo(),
              _header(),
              _logoApp(),
              _textAboutUs(),
              Divider(),
              _license()
            ],
          ),
        ));
  }

  Widget _header() {
    return Container(
        constraints: new BoxConstraints(
          minHeight: 50.0,
          minWidth: 5.0,
          maxHeight: 50.0,
          maxWidth: 30.0,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFF0F6FE),
          // border: Border.all(),
        ),
        child: Align(
          alignment: Alignment.center,
          child: new Text('Tentang Kami',
              style: new TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3b444f))),
        ));
  }

  Widget _logoApp() {
    return Image.asset(
      'assets/logo.png',
      width: 250,
      height: 250,
    );
  }

  Widget _textAboutUs() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 0.0),
      child: Column(
        children: <Widget>[
          Text(
            'Aplikasi markopi dikembangkan oleh tim markopi Institut Teknologi Del.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _license() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 5.0, 0.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("Copyright"),
                new Icon(Icons.copyright),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          new Text("License"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: RichText(
                  text: TextSpan(
                      children: [
                        new TextSpan(text: "1. Avatar ", style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),),
                        new TextSpan(text: "(www.sketchappsources.com)", style: new TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff297cbb),
                      ),)
                      ]),
                ),
                onTap: () async {
                  if (await canLaunch("https://www.sketchappsources.com")) {
                    await launch("https://www.sketchappsources.com");
                  }
                },
              ),
              InkWell(
                child: RichText(
                  text: TextSpan(
                      children: [
                        new TextSpan(text: "2. Icons ", style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),),
                        new TextSpan(text: "(www.sketchappsources.com)", style: new TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff297cbb),
                      ),)
                      ]),
                ),
                onTap: () async {
                  if (await canLaunch("https://www.sketchappsources.com")) {
                    await launch("https://www.sketchappsources.com");
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
