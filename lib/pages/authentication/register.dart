import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:markopi_mobile/controllers/profile_controller.dart';
import 'package:markopi_mobile/pages/authentication/login.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = new GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email;
  String _password;
  String _confirmPassword;
  String _errorMessage;

  // Initial form is login form
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

  // Perform signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        if (_password != _confirmPassword) {
          _showUnconfirmed();
          setState(() {
            _isLoading = false;
          });
        } else {
          FirebaseUser user =
              await _firebaseAuth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          var string = user.email;
          var nama = string.split("@");
          ProfileController.addProfile(
              user.uid,
              nama[0],
              "https://firebasestorage.googleapis.com/v0/b/markopi.appspot.com/o/1558608508082?alt=media&token=7117934e-c055-4839-8e00-cac507de918b",
              "Fasilitator",
              "",
              "",
              "",
              "",
              "",
              "",
              "");
          user.sendEmailVerification();
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
          Navigator.of(context).pushNamed("/home");
          _showVerifyEmailSentDialog();
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
              "Anda sudah terdaftar dan sudah dapat masuk ke akun anda.\nLink untuk verifikasi akun sudah dikirim ke email anda.\nSilahkan verifikasi akun anda."),
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

  void _showUnconfirmed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Konfirmasi kata sandi salah"),
          content: new Text(
              "Kata sandi dan Konfirmasi kata sandi tidak sesuai. Silahkan masukkan kata sandi yang sesuai"),
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
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showConfirmPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
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

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
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

  Widget _showConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Konfirmasi Kata Sandi',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return "Konfirmasi kata sandi tidak boleh kosong";
          } else if (value.length < 6) {
            return "Konfirmasi kata sandi harus lebih dari 6 karakter";
          }
        },
        onSaved: (value) => _confirmPassword = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: new Text('Sudah punya akun? Masuk di sini',
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              color: Colors.blueAccent)),
      onPressed: () => _navigateToLogin(),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            color: Colors.blueAccent,
            child: new Text('DAFTAR',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Login(),
        fullscreenDialog: true,
      ),
    );
  }
}
