import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/components/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = new GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _email;
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
      print("test");
      try {
        _firebaseAuth.sendPasswordResetEmail(
          email: _email
        );
        setState(() {
          _isLoading = false;
        });
        _showForgotPasswordSentDialog();
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
        appBar: HeaderBack(),
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

  void _showForgotPasswordSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Email Forgot Password"),
          content: new Text(
              "Link untuk mengubah password sudah dikirim ke email anda. Silahkan cek email anda untuk melakukan perubahan password."),
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
              _header(),
              _showText(),
              _showEmailInput(),
              _showPrimaryButton(),
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
          child: new Text('Forgot Password',
              style: new TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3b444f))),
        ));
  }

  Widget _showText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Text(
          'Masukkan email akun anda yang sudah pernah terdaftar, agar sistem dapat mengirimkan link perubahan password ke email anda.',
          style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: Colors.black)),
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

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
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

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: SizedBox(
          height: 47.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Color(0xFF2696D6),
            child: new Text('Kirim Email Perubahan Password',
                style: new TextStyle(fontSize: 16.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }
}
