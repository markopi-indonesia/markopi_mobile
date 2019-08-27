import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:markopi_mobile/pages/authentication/register.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = new GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email;
  String _password;
  String _errorMessage;

  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        setState(() {
          _isLoading = false;
        });

        if (user.uid.length > 0 && user.uid != null) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed("/home");
          print(user.email);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: Header(),
        drawer: DrawerPage(),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verifikasi Akun Anda"),
          content: new Text(
              "Link untuk verifikasi akun sudah dikirim ke email anda.\n Silahkan verifikasi akun anda."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              _showFacebookButton(),
              _showSecondaryButton(),
              _showEmailInput(),
              _showPasswordInput(),
              _showLupaPasswordButton(),
              _showPrimaryButton(),
              
              _showErrorMessage(),
            ],
          ),
        ));
  }


Widget _header() {
    // return new Padding(
    //     padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
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
        child:Align(
        alignment: Alignment.center,
    child: new Text(
      'Login',
          style: new TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w300,
              color: Colors.black)),
    )
      );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  // Widget _showLogo() {
  //   return new Hero(
  //     tag: 'hero',
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
  //       child: CircleAvatar(
  //         backgroundColor: Colors.transparent,
  //         radius: 70.0,
  //         child: Image.asset('assets/logo.png'),
  //       ),
  //     ),
  //   );
  // }

Widget _showFacebookButton() {
  return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: SizedBox(
          height: 47.0,
     child: RaisedButton(
       
       child: new Text(
      'LOG IN DENGAN FACEBOOK',
      style: new TextStyle(fontSize: 13.0, color: Colors.white),),
       
       color: Color(0xFF3B5998),
       onPressed: (){
       }
      )
        ));    
  }
  
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return "Email tidak boleh kosong";
          } else if (!value.contains("@") && !value.contains(".")) {
            return "Format email salah";
          }
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Kata Sandi',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
            
        validator: (value) {
          if (value.isEmpty) {
            return "Kata sandi tidak boleh kosong";
          } else if (value.length < 6) {
            return "Kata sandi harus lebih dari 6 karakter";
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(245.0, 5.0, 0.0, 0.0),
      child: Stack(
      children: <Widget>[
     FlatButton(
      child: new Text('DAFTAR',
      textAlign: TextAlign.left,
          style: new TextStyle(
            decoration: TextDecoration.underline,
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
              color: Colors.black),
              ),
      onPressed: () => _navigateToRegister(),
    ),
      // Text('Sign in manual',
      // textAlign: TextAlign.center,
      //     style: new TextStyle(
      //         fontSize: 15.0,
      //         fontWeight: FontWeight.w300,
      //         color: Colors.black),
      //         ),
              ],
    ));
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 47.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(2.0)),
            color: Color(0xFF2696D6),
            child: new Text('LOG IN',
            
                style: new TextStyle(fontSize: 16.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

    Widget _showLupaPasswordButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(216.0, 5.0, 0.0, 0.0),
    child: new FlatButton(
      child: new Text('Lupa password?',
      textAlign: TextAlign.left,
          style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: Colors.black),
              ),
      onPressed: () => _navigateToRegister(),
    )

    );
  }

  _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Register(),
        fullscreenDialog: true,
      ),
    );
  }
}
