

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';

class ManipulateProductTabTwo extends StatefulWidget {
  @override
  _ManipulateProductTabTwoState createState() => _ManipulateProductTabTwoState();
}

class _ManipulateProductTabTwoState extends State<ManipulateProductTabTwo> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        CustomWidget.emptyVSpace(25.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text("Tambahkan gambar",style: Style14Black,),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomWidget.emptyVSpace(20.0),
              Container(
                height: 45,
                child: MolButton(context).blueButton(
                    onPressed: _addImage,
                    child: Text("Tambah gambar",style: Style14WhiteBold,)
                ),
              ),
              CustomWidget.emptyVSpace(2.0),
              Text("*Maksimal 10 gambar",style: Style12Grey,)
            ],
          ),
        ),
        CustomWidget.emptyVSpace(25.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text("Pratinjau gambar",style: Style14Black,),
        ),
        CustomWidget.emptyVSpace(15.0),
        Container(
          height: 170,
          width: double.maxFinite,
          color:Color(0xFFF0F6FE),

          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal:17),
            scrollDirection: Axis.horizontal,
            children: sample(),
          ),
        )
      ],
    );
  }

  List<Widget> sample(){
    List<Widget> temp=[];
    for(int i=0;i<8;i++){
      temp.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: i%2==0?
                "https://as2.ftcdn.net/jpg/02/17/33/97/500_F_217339703_f8t8l574PCixzcWy4i1O64LR2MXQScYx.jpg"
                :"https://as2.ftcdn.net/jpg/00/60/32/95/500_F_60329515_GjQiSUdiTzVUU9gBeoMIOzML6IWOidWo.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }
    return temp;
  }

  void _addImage(){

  }
}
