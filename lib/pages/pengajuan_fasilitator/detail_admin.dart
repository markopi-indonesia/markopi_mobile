import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class DetailPengajuan extends StatefulWidget {
  final String documentID;
  final String userID;
  final String ktp;
  final String selfie;
  final String pengalaman;
  final String sertifikat;
  final String status;
  final String pesan;
  final String dateTime;
  final String nama;
  final String photo;
  final String profesi;
  final String noHP;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String alamat;
  final String bio;

  DetailPengajuan(
      {this.documentID,
      this.userID,
      this.ktp,
      this.selfie,
      this.pengalaman,
      this.sertifikat,
      this.status,
      this.pesan,
      this.dateTime,
      this.nama,
      this.photo,
      this.profesi,
      this.noHP,
      this.provinsi,
      this.kabupaten,
      this.kecamatan,
      this.alamat,
      this.bio});

  @override
  State<StatefulWidget> createState() => new _DetailPengajuanState();
}

class _DetailPengajuanState extends State<DetailPengajuan> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _photoUrlController = TextEditingController();
  TextEditingController _profesiController = TextEditingController();
  TextEditingController _noHPController = TextEditingController();
  TextEditingController _provinsiController = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final _formUpdateStatusKey = GlobalKey<FormState>();
  String _pesan;
  List<String> urls;
  @override
  void initState() {
    urls = widget.sertifikat.split(";");
    Firestore.instance
        .collection('profile')
        .where("userID", isEqualTo: widget.userID)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => [
              _namaController.text = doc["nama"],
              _photoUrlController.text = doc["photoURL"],
              _profesiController.text = doc["profesi"],
              _noHPController.text = doc["noHP"],
              _provinsiController.text = doc["provinsi"],
              _kabupatenController.text = doc["kabupaten"],
              _kecamatanController.text = doc["kecamatan"],
              _alamatController.text = doc["alamat"],
              _bioController.text = doc["bio"]
            ]));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderBack(),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              _judulProfil(),
              ClipPath(
                child: Container(color: Colors.blueGrey.withOpacity(0.8)),
                clipper: GetClipper(),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                      width: 140.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          image: DecorationImage(
                              image: widget.photo.isEmpty
                                  ? AssetImage('assets/no_user.jpg')
                                  : NetworkImage(_photoUrlController.text),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.white)
                          ])),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.nama,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                widget.profesi,
                style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                widget.noHP,
                style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Provinsi:  ",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      Text(widget.provinsi,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Column(children: <Widget>[
                    Text(
                      "Kabupaten:  ",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    Text(
                      widget.kabupaten,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Montserrat'),
                    ),
                  ]),
                  Column(children: <Widget>[
                    Text(
                      "Kecamatan:  ",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    Text(
                      widget.kecamatan,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Montserrat'),
                    ),
                  ]),
                ],
              ),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              _judulPengajuan(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Gambar KTP"),
              _fotoKTP(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Gambar Selfie"),
              _fotoSelfie(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Pengalaman"),
              _pengalaman(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              new Text("Sertifikat"),
              _sertifikat(),
              Padding(padding: new EdgeInsets.only(top: 20.0)),
              if (widget.status == "Menunggu")
                _formKonfirmasi()
              else
                _statusPengajuan(),
            ])));
  }

  Widget _judulProfil() {
    return new Center(
      child: Text(
        "Profil Pengaju",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _judulPengajuan() {
    return new Center(
      child: Text(
        "Detail Pengajuan Fasilitator",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _fotoKTP() {
    return new PinchZoomImage(
      image: Image.network(widget.ktp),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      onZoomStart: () {},
      onZoomEnd: () {},
    );
  }

  Widget _fotoSelfie() {
    return new PinchZoomImage(
      image: Image.network(
        widget.selfie,
        fit: BoxFit.fitWidth,
      ),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      onZoomStart: () {},
      onZoomEnd: () {},
    );
  }

  Widget _pengalaman() {
    return new Container(
      child: new Text(widget.pengalaman),
    );
  }

  Widget _statusPengajuan() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Text("Status Pengajuan : " + widget.status),
          Text("Pesan : " + widget.pesan)
        ],
      ),
    );
  }

  Widget _sertifikat() {
    return new Column(
        children: urls
            .map((item) => new PinchZoomImage(
                  image: Image.network(item),
                  zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  hideStatusBarWhileZooming: true,
                  onZoomStart: () {},
                  onZoomEnd: () {},
                ))
            .toList());
  }

  bool _validateAndSave() {
    final form = _formUpdateStatusKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit(String status) async {
    if (_validateAndSave()) {
      try {
        updateStatus(status);
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void updateStatus(String status) async {
    await Firestore.instance
        .collection('pengajuan')
        .document(widget.documentID)
        .updateData({
      'status': status,
      "pesan": _pesan,
    });
    if (status == "Disetujui") {
      await Firestore.instance
          .collection('profile')
          .document(widget.userID)
          .updateData({'role': "Fasilitator"});
    }
  }

  Widget _formKonfirmasi() {
    return new Form(
      key: _formUpdateStatusKey,
      autovalidate: false,
      child: new Container(
          padding: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              new Center(
                child: Text(
                  "Tambah Pesan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 20.0)),
              new TextFormField(
                maxLines: 5,
                decoration: new InputDecoration(
                    hintText: "Isi Pesan",
                    labelText: "Isi Pesan",
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0))),
                onSaved: (value) => _pesan = value,
              ),
              new Padding(padding: new EdgeInsets.only(top: 20.0)),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        child: new RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          color: Color(0xff2696D6),
                          child: new Text('Setujui',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: () => _validateAndSubmit("Disetujui"),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: new RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          color: Color(0xffD90600),
                          child: new Text('Tolak',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: () => _validateAndSubmit("Ditolak"),
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width + 120, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
