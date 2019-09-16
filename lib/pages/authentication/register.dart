import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markopi_mobile/controllers/profile_controller.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = new GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email;
  String _nama;
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
          // var string = user.email;
          var nama = _nama;
          ProfileController.addProfile(
              user.uid, nama, "assets/avatars/1.png", "Petani", "", "", "", "", "", "", "");
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
              // _showLogo(),
              _header(),
              _showText(),
              _showEmailInput(),
              _showNamaInput(),
              _showPasswordInput(),
              _showConfirmPasswordInput(),
              _showPrimaryButton(),
              // _showText2(),
              // _showFacebookButton(),
              // _showSecondaryButton(),
              _showErrorMessage(),
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
          child: new Text('Register',
              style: new TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
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

  Widget _showFacebookButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
        child: SizedBox(
            height: 47.0,
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'assets/f.png',
                      scale: 6.5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    new Text(
                      'LOG IN DENGAN FACEBOOK',
                      style: new TextStyle(fontSize: 13.0, color: Colors.white),
                    )
                  ],
                ),
                color: Color(0xFF1d508d),
                onPressed: () {})));
  }

  Widget _showText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Text(
          'Jika belum punya akun daftarkan diri Anda dengan mengisi form di bawah ini.',
          style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: Colors.black)),
    );
  }

  Widget _showText2() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: Align(
          alignment: Alignment.center,
          child: new Text('ATAU',
              style: new TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black)),
        ));
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: Color(0xff868686)),
          hintText: 'markopi@gmail.com',
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Color(0xff868686)),
          ),
        ),
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

  Widget _showNamaInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          labelText: 'Nama',
          labelStyle: TextStyle(color: Color(0xff868686)),
          hintText: 'Markopi Nusantara',
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Color(0xff868686)),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Nama tidak boleh kosong";
          }
        },
        onSaved: (value) => _nama = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Color(0xff868686)),
          hintText: '*******',
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Color(0xff868686)),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Password tidak boleh kosong";
          } else if (value.length < 6) {
            return "Password harus lebih dari 6 karakter";
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          labelText: 'Konfirmasi Password',
          labelStyle: TextStyle(color: Color(0xff868686)),
          hintText: '*******',
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Color(0xff868686)),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Konfirmasi password tidak boleh kosong";
          } else if (value.length < 6) {
            return "Konfirmasi password harus lebih dari 6 karakter";
          }
        },
        onSaved: (value) => _confirmPassword = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
        child: SizedBox(
          height: 47.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Color(0xFF2696D6),
            child: new Text('REGISTER',
                style: new TextStyle(fontSize: 13.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }
}
