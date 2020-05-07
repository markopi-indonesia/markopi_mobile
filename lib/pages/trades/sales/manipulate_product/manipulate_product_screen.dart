

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';
import 'package:markopi_mobile/widgets/widgets.dart';

import 'manipulate_product.dart';

class ManipulateProductScreen extends StatefulWidget {
  final bool isEdit;
  ManipulateProductScreen({this.isEdit=false});
  @override
  ManipulateProductScreenState createState() => ManipulateProductScreenState(this.isEdit);
}

class ManipulateProductScreenState extends State<ManipulateProductScreen> with SingleTickerProviderStateMixin {
  ManipulateProductScreenState(this.isEdit);
  final bool isEdit;

  TabController tabController ;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    tabController.addListener(() {
      print(tabController.index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrgAppBar(context).
        appBar(
          title: widget.isEdit?"Ubah Penjualan": "Buat Penjualan",
          hasSearch: true,
          blueMode: false,
          elevation: 0,
          onPressedSearch: _searchButtonPressed,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _fakeTabBar(),
            CustomWidget.emptyVSpace(20.0),
            _stepper(),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: <Widget>[
                  ManipulateProductTabOne(parent: this,),
                  ManipulateProductTabTwo(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:_bottomButton() ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ///Functions
  void _searchButtonPressed(){
  print("search button pressed");
  }


  ///Widgets

  //fake tab bar for easily creating custom stepper
  Widget _fakeTabBar(){
    return IgnorePointer(
      ignoring: true,
      child: TabBar(
        indicator: BoxDecoration(
            color: Colors.transparent
        ),
        controller: tabController,
        tabs: <Widget>[
          Container(),
          Container(),
        ],
      ),
    );
  }

  Widget _stepper(){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: (){
                    tabController.animateTo(0);
                    setState(() {

                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: tabController.index==0?CustomColor.mainColor:Colors.white,
                      border: Border.all(color: Colors.grey,width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text("1",style: tabController.index==0?Style14White:Style14Black,)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.maxFinite,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: (){
                    tabController.animateTo(1);
                    setState(() {

                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: tabController.index==1?CustomColor.mainColor:Colors.white,
                      border: Border.all(color: Colors.grey,width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text("2",style: tabController.index==1?Style14White:Style14Black,)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
      ],
    );
  }

  Widget _bottomButton(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: 55,
      child:tabController.index==0?
      MolButton(context)
          .blueButton(
        onPressed: _nextButtonHandle,
        child: Center(child: Text("Selanjutnya",style: Style16WhiteBold,)),
      ):Row(
        children: <Widget>[
          Expanded(
            child: MolButton(context)
              .greenButton(
              onPressed: _previousButton,
              child: Center(child: Text("Kembali",style: Style16WhiteBold,)),
            )
          ),
          CustomWidget.emptyHSpace(10.0),
          Expanded(
            child: MolButton(context)
              .blueButton(
              onPressed: _nextButtonHandle,
              child: Center(child: Text( widget.isEdit?"Ubah Penjualan": "Buat Penjualan",style: Style16WhiteBold,)),
            )
          ),
        ],
      ),
    );
  }
  void _nextButtonHandle(){
    if(mounted){
      if(tabController.index==1){
        return _showDialog();
      }
      tabController.animateTo(1);
      setState(() {

      });
    }
  }
  void _previousButton(){
    if(mounted){
      tabController.animateTo(0);
      setState(() {

      });
    }
  }

  void _showDialog(){
    showDialog(
        context: context,
        child: SimpleDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          children: <Widget>[
            Center(
              child:Icon(
                Icons.info,
                size: 45,
                color: Colors.grey,
              ),
            ),
            CustomWidget.emptyVSpace(10.0),
            Text(
              widget.isEdit?"Ubah Penjulan": "Buat Penjualan?",
              style: Style16GreyBold,
              textAlign: TextAlign.center,),
            Text(
              widget.isEdit?"Apakah anda yakin akan mengubah penjualan?":"Apakah anda yakin untuk membuat penjualan ini?",
              style:Style12Black ,
              textAlign: TextAlign.center,),
            CustomWidget.emptyVSpace(15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40,
                  child: MolButton(context).button(
                      color: Color(0xFFD90500),
                      onPressed: ()=>Navigator.pop(context),
                      child: Text("Tidak",style: Style14White,)),
                ),
                Container(
                  height: 40,
                  child: MolButton(context).button(
                      color: Color(0xFF64B7FF),
                      onPressed: ()=>Navigator.pushReplacementNamed(context, AppRoute.PRODUCT_SUMMARY_ROUTE),
                      child: Text("Ya",style: Style14White,)),
                ),

              ],
            )
          ],

        )
    );
  }

}
