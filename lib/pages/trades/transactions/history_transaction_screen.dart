

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header_transaction.dart';
import 'package:markopi_mobile/factory/models/transaction/transaction.dart';
import 'package:markopi_mobile/helpers/constants.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/pages/trades/transactions/detail_transaction.dart';

class HistoryTransactionScreen extends StatefulWidget {
  @override
  _HistoryTransactionScreenState createState() => _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> {

  FirebaseUser user;

  Future<void> getCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    if(user!=null){
      print(user.displayName);
      setState(() {
        this.user=user;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderTransaction(isHistory:true,),
      body: StreamBuilder(
        stream: Firestore.instance.collection("transaction")
            .where("user_id",isEqualTo: user.uid)
            .where("payment_status",isEqualTo: PAYMENT_PAID)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.documents.length == 0)
            return Center(
              child: Text("Tidak ada data transaksi!"),
            );
          return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 5,),
              padding: EdgeInsets.symmetric(vertical: 15.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return _buildTransactionItem(
                    TransactionModel.fromJson(
                        snapshot.data.documents[index].data),snapshot.data.documents[index].documentID);
              }
          );

        },
      ),
    );
  }


  Widget _buildTransactionItem(TransactionModel data,String productId) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Material(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border:Border.fromBorderSide(BorderSide(color: Colors.grey.withOpacity(0.4)))),
            child: InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder:(context) => DetailTransactionScreen(transactionId: productId,isAdmin: false,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kode Belanja - ${data.id}",
                          style: Style14BlackBold,
                        ),
                        CustomWidget.emptyVSpace(5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alamat: ",
                              style: Style14BlackBold,
                            ),
                            Expanded(
                              child: Text(
                                data.address,
                                style: Style14Black,
                              ),
                            ),
                          ],
                        ),
                        CustomWidget.emptyVSpace(5.0),
                        Row(
                          children: [
                            Text(
                              "Tanggal: ",
                              style: Style14BlackBold,
                            ),
                            Text(
                              Converter.timeToStringIndo(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data.createdAt.millisecondsSinceEpoch)),
                              style: Style14Black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(10,5,10,8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total : ${Converter().priceFormat(data.totalPrice.toDouble())}",style: Style16BlackBold,),
                        Text("Status : ${Converter.getStatusOrder(data.status)}")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
