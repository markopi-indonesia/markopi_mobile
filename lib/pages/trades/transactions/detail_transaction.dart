import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/factory/models/transaction/edit_transaction_product.dart';
import 'package:markopi_mobile/factory/models/transaction/transaction.dart';
import 'package:markopi_mobile/factory/models/transaction/transaction_product.dart';
import 'package:markopi_mobile/helpers/constants.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/style.dart';
import 'package:markopi_mobile/pages/trades/purchases/payment/payment_screen.dart';
import 'package:markopi_mobile/pages/trades/show_product/show_photo_screen.dart';
import 'package:markopi_mobile/services/trades/trade_services.dart';
import 'package:markopi_mobile/widgets/molecules/buttons/button_mol.dart';
import 'package:markopi_mobile/widgets/molecules/buttons/manipulate_product_mol.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DetailTransactionScreen extends StatefulWidget {
  final String transactionId;
  final bool isAdmin;
  const DetailTransactionScreen({Key key, this.transactionId, this.isAdmin})
      : super(key: key);
  @override
  _DetailTransactionScreenState createState() =>
      _DetailTransactionScreenState();
}

class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
  ProgressDialog pr;
  bool isEditMode = false;

  TextEditingController editedAddress;
  TextEditingController editedNotes;

  List<EditTransactionProductModel> editedProduct = [];

  int totalPriceEditProduct = 0;
  int totalEditedShippingPrice = 0;

  Future<QuerySnapshot> orderedItemsFuture;
  Future<DocumentSnapshot> orderedItemFuture;

  List<TransactionProductModel> orderedItems;
  QuerySnapshot orderedItemsSnapshot;
  TransactionModel transactionInformation;
  String transactionInformationDocId;
  bool _loading=true;

  getTotalShippingPrice(String docId){
    int temp =0;
    if(editedProduct.length>0){
      editedProduct.forEach((element) {
          if (element.product.units.toLowerCase() == "kilogram") {
            temp += element.product.amount * 45000;
          } else {
            temp +=
                (element.product.amount / 1000).ceil() * 45000;
          }
      });
    }
    this.totalEditedShippingPrice=temp;
  }
  getTotalGoodsPrice(){
    totalPriceEditProduct=transactionInformation.subTotal;
  }

  bool isEditedProductNull() {
    try {
      return editedProduct.length == 0;
    } catch (e) {
      return editedProduct.length == 0;
    }
  }

  bool hasDataInEditedProduct(String productId) {
    bool isAnyProduct = false;
    try {
      editedProduct.forEach((element) {
        if (element.product.productId == productId) {
          isAnyProduct = true;
        }
      });
    } catch (e) {
      isAnyProduct = false;
    }
    return isAnyProduct;
  }

  EditTransactionProductModel dataInEditedProduct(String productId) {
    return editedProduct.firstWhere((e) => e.product.productId == productId);
  }

  @override
  void initState() {
    editedAddress = new TextEditingController();
    editedNotes = new TextEditingController();
    getTransactionData();
    super.initState();
    initTotalPrice();
  }
  getTransactionData()async{
    setState(() {
      _loading=true;
    });
    DocumentSnapshot data = await Firestore.instance
        .collection("transaction")
        .document(widget.transactionId)
        .get();
    if(data!=null){
      setState(() {
        transactionInformationDocId = data.documentID;
        transactionInformation=TransactionModel.fromJson(data.data);
        getTotalGoodsPrice();
      });
    }
    QuerySnapshot items = await Firestore.instance
        .collection("transaction")
        .document(widget.transactionId)
        .collection("items")
        .getDocuments();
    if(data!=null){
      setState(() {
        if(items.documents.length>0){
          items.documents.forEach((element) {
            editedProduct.add(EditTransactionProductModel(
              docId: element.documentID,
              product: TransactionProductModel.fromJson(element.data),
            ));
            getTotalShippingPrice(element.documentID);
          });
        }
        orderedItemsSnapshot=items;

      });
    }
    setState(() {
      _loading=false;
    });
  }

  initTotalPrice() async {
    var initData = await Firestore.instance
        .collection("transaction")
        .document(widget.transactionId)
        .get();
    editedNotes.text = initData.data['customer_notes'];
    editedAddress.text = initData.data['address'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Tunggu sebentar ya...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: HeaderBack(),
      body: _loading?Center(child: CircularProgressIndicator(),) : ListView(
              padding: EdgeInsets.all(15),
              children: [
                _buildOrderIdAndStatus(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildOrderDate(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildOrderAddress(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildOrderNotes(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildShippingPrice(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildOrderSummary(transactionInformation, transactionInformationDocId),
                CustomWidget.emptyVSpace(10.0),
                _buildPaymentStatusDetail(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildPaymentProof(transactionInformation),
                CustomWidget.emptyVSpace(10.0),
                _buildOrderOptionsButton(transactionInformation, transactionInformationDocId),
              ],),

    );
  }

  Widget _buildOrderIdAndStatus(TransactionModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Kode Belanja - ${data.id}",
          style: Style14BlackBold,
        ),
        Text("Status - ${Converter.getStatusOrder(data.status)}")
      ],
    );
  }

  Widget _buildOrderDate(TransactionModel data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Text(
                "Tanggal Order : ",
                style: Style14BlackBold,
              ),
              Text(
                Converter.timeToStringIndo(DateTime.fromMillisecondsSinceEpoch(
                    data.createdAt.millisecondsSinceEpoch)),
                style: Style14Black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderAddress(TransactionModel data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alamat : ",
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
          CustomWidget.emptyVSpace(10.0),
          if (isEditMode)
            TextFormField(
              minLines: 2,
              maxLines: 3,
              controller: editedAddress,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  hintStyle: Style12Grey,
                  hintText: "${data.address}"),
            )
          else
            Container(),
        ],
      ),
    );
  }

  Widget _buildOrderNotes(TransactionModel data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catatan : ",
                style: Style14BlackBold,
              ),
              Expanded(
                child: Text(
                  data.customerNotes != null
                      ? data.customerNotes.length > 0 ? data.customerNotes : "-"
                      : "-",
                  style: Style14Black,
                ),
              ),
            ],
          ),
          CustomWidget.emptyVSpace(10.0),
          if (isEditMode)
            TextFormField(
              controller: editedNotes,
              minLines: 2,
              maxLines: 3,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  hintStyle: Style12Grey,
                  hintText: "${data.customerNotes}"),
            )
          else
            Container(),
        ],
      ),
    );
  }
  Widget _buildShippingPrice(TransactionModel data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Biaya Antar : ",
                style: Style14BlackBold,
              ),
              Text(Converter().priceFormat(45000.0)+" /Kg",
                style: Style14Black,
              ),
            ],
          ),
          CustomWidget.emptyVSpace(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total : ",
                style: Style14BlackBold,
              ),
              Text(Converter().priceFormat(totalEditedShippingPrice.toDouble()),
                style: Style14Black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(TransactionModel data, String productId) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Text(
              "Ringkasan Pesanan",
              style: Style14BlackBold,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: _loading?Center(child: CircularProgressIndicator(),): ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      itemCount: orderedItemsSnapshot.documents.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        TransactionProductModel product =TransactionProductModel.fromJson(orderedItemsSnapshot.documents[index].data);
                        String docId = orderedItemsSnapshot.documents[index].documentID;
                        return Container(
                          child: Row(
                            children: [
                              Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${!isEditedProductNull() ? hasDataInEditedProduct(product.productId) ? dataInEditedProduct(product.productId).product.amount : product.amount : product.amount}x",
                                    style: Style16BlackBold,
                                  )),
                              CustomWidget.emptyHSpace(10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${product.name} (${product.amount} ${Converter.getUnit(product.units)})",
                                      style: Style14BlackBold,
                                    ),
                                    CustomWidget.emptyVSpace(5.0),
                                    Text(
                                        "${Converter().priceFormat(product.price.toDouble())} /${Converter.getUnit(product.units)}")
                                  ],
                                ),
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    !isEditedProductNull()
                                        ? !hasDataInEditedProduct(
                                                product.productId)
                                            ? Text(Converter().priceFormat(
                                                product.totalPrice.toDouble()))
                                            : Text(Converter().priceFormat(
                                                (dataInEditedProduct(product.productId)
                                                            .product
                                                            .amount *
                                                        dataInEditedProduct(product
                                                                .productId)
                                                            .product
                                                            .price)
                                                    .toDouble()))
                                        : Text(Converter().priceFormat(
                                            product.totalPrice.toDouble())),
                                    isEditMode
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ManipulateProductButtonMol(
                                              onAddPressed: () {
                                                setState(() {

                                                  if (editedProduct.length >
                                                      0) {
                                                    if (hasDataInEditedProduct(
                                                        product.productId)) {
                                                      var temp = editedProduct
                                                          .firstWhere((e) =>
                                                              e.product
                                                                  .productId ==
                                                              product
                                                                  .productId);

                                                      temp.product.amount += 1;
                                                      totalPriceEditProduct +=
                                                          product.price;
                                                      getTotalShippingPrice(docId);

                                                    } else {
                                                      var temp = product;
                                                      temp.amount += 1;
                                                      totalPriceEditProduct +=
                                                          product.price;
                                                      editedProduct.add(
                                                          EditTransactionProductModel(
                                                              docId: docId,
                                                              product:
                                                                  product));
                                                      getTotalShippingPrice(docId);

                                                    }
                                                  } else {
                                                    var temp = product;
                                                    temp.amount += 1;
                                                    totalPriceEditProduct +=
                                                        product.price;
                                                    editedProduct.add(
                                                        EditTransactionProductModel(
                                                            docId: docId,
                                                            product: product));
                                                    getTotalShippingPrice(docId);

                                                  }
                                                });
                                              },
                                              onRemovePressed: () {
                                                setState(() {
                                                  if (editedProduct.length >
                                                      0) {
                                                    if (hasDataInEditedProduct(
                                                        product.productId)) {
                                                      if (dataInEditedProduct(
                                                                  product
                                                                      .productId)
                                                              .product
                                                              .amount !=
                                                          1) {
                                                        var temp = editedProduct
                                                            .firstWhere((e) =>
                                                                e.product
                                                                    .productId ==
                                                                product
                                                                    .productId);

                                                        temp.product.amount -=
                                                            1;
                                                        totalPriceEditProduct -=
                                                            product.price;
                                                        getTotalShippingPrice(docId);

                                                      }
                                                    } else {
                                                      if (product.amount != 1) {
                                                        var temp = product;
                                                        temp.amount -= 1;
                                                        totalPriceEditProduct -=
                                                            product.price;
                                                        editedProduct.add(
                                                            EditTransactionProductModel(
                                                                docId: docId,
                                                                product:
                                                                    product));
                                                        getTotalShippingPrice(docId);

                                                      }
                                                    }
                                                  } else {
                                                    if (product.amount != 1) {
                                                      var temp = product;
                                                      temp.amount -= 1;
                                                      totalPriceEditProduct -=
                                                          product.price;
                                                      editedProduct.add(
                                                          EditTransactionProductModel(
                                                              docId: docId,
                                                              product:
                                                                  product));
                                                      getTotalShippingPrice(docId);

                                                    }
                                                  }
                                                });
                                              },
                                              totalGoods: !isEditedProductNull()
                                                  ? hasDataInEditedProduct(
                                                          product.productId)
                                                      ? dataInEditedProduct(
                                                              product.productId)
                                                          .product
                                                          .amount
                                                      : product.amount
                                                  : product.amount,
                                            ),
                                          )
                                        : Container(),
                                  ]),
                            ],
                          ),
                        );
                      }),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pembayaran",
                  style: Style14BlackBold,
                ),
                Text(
                    "${Converter().priceFormat((totalPriceEditProduct+totalEditedShippingPrice).toDouble())}"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentStatusDetail(TransactionModel data) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          Converter.getPaymentPaidStatus(data.paymentStatus),
          style: TextStyle(
              color: data.paymentStatus == PAYMENT_PAID
                  ? Colors.green
                  : Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPaymentProof(TransactionModel data) {
    return widget.isAdmin
        ? data.image.length > 0
            ? Container(
                child: FutureBuilder(
                    future: FirebaseStorage.instance
                        .ref()
                        .child("transaction_images")
                        .child(data.image)
                        .getDownloadURL(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      if (snapshot.data == null)
                        return Center(
                          child: Text("Error"),
                        );
                      return MolButton(context)
                          .blueButton(
                          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ShowPhotoScreen(imageUrl: snapshot.data,))),
                          child: Text("Lihat bukti bayar",style: Style12WhiteBold,));
                    }),
              )
            : Container()
        : Container();
  }

  Widget _buildOrderOptionsButton(TransactionModel data, String docId) {
    return Column(
      children: [
        widget.isAdmin && data.orderStatus == ORDER_PROCESSING
            ? Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  width: double.maxFinite,
                  height: 40,
                  child: MolButton(context).greenButton(
                    onPressed: () {
                      CustomWidget.showCustomDialog(
                          title: "Terima Pembelian",
                          context: context,
                          content: "Apakah anda yakin akan menerima order ini?",
                          onPressed: () {
                            _approveTransaction(docId: docId);
                          });
                    },
                    child: Text(
                      "Terima Pembelian",
                      style: Style14WhiteBold,
                    ),
                  ),
                ),
              )
            : Container(),
        data.orderStatus == ORDER_PROCESSING &&
                data.paymentStatus == PAYMENT_UNPAID &&
                !widget.isAdmin
            ? Container(
                width: double.maxFinite,
                height: 40,
                child: MolButton(context).blueButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PurchasePaymentScreen(
                                  transactionId: widget.transactionId,
                                )));
                  },
                  child: Text(
                    "Upload Bukti Pembayaran",
                    style: Style14WhiteBold,
                  ),
                ),
              )
            : Container(),
        CustomWidget.emptyVSpace(5.0),
        data.orderStatus == ORDER_PROCESSING &&
                data.paymentStatus == PAYMENT_UNPAID
            ? Container(
                width: double.maxFinite,
                height: 40,
                child: MolButton(context).blueButton(
                  onPressed: () async {
                    setState(() {
                      if (isEditMode) {
                        CustomWidget.showCustomDialog(
                            title: "Ubah Order",
                            context: context,
                            content: "Apakah anda yakin akan mengubah order?",
                            onPressed: () {
                              _updateTransaction();
                            });
                      } else
                        isEditMode = true;
                    });
                  },
                  child: Text(
                    isEditMode ? "Simpan" : "Ubah",
                    style: Style14WhiteBold,
                  ),
                ),
              )
            : Container(),
        CustomWidget.emptyVSpace(20.0),
        data.orderStatus == ORDER_PROCESSING
            ? data.paymentStatus == PAYMENT_UNPAID
                ? Container(
                    width: double.maxFinite,
                    height: 40,
                    child: MolButton(context).redButton(
                      onPressed: () async {
                        CustomWidget.showCustomDialog(
                            title: "Batalkan Order",
                            context: context,
                            content:
                                "Apakah anda yakin akan membatalkan order?",
                            onPressed: () {
                              _handleCancelButton(docId);
                            });
                      },
                      child: Text(
                        "Batalkan Order",
                        style: Style14WhiteBold,
                      ),
                    ),
                  )
                : Container()
            : Container(),
      ],
    );
  }

  Future _approveTransaction({String docId}) async {
    Navigator.pop(context);
    pr.show();

    try {
      await TradeServices(context)
          .approveTransaction(docId: docId)
          .then((value) {

      });
      CustomWidget.showFlushBar(context, "Berhasil Diubah");
      pr.hide();
    } catch (e) {
      pr.hide();
      print(e.toString());
      CustomWidget.showFlushBar(context, "Gagal");
      return;
    }
  }

  Future _updateTransaction() async {
    Navigator.pop(context);
    pr.show();
    try {
      await Future.wait(List.generate(1, (index) async {
        await Firestore.instance
            .collection("transaction")
            .document(widget.transactionId)
            .updateData({
          "customer_notes": editedNotes.text,
          "address": editedAddress.text,
          "shipping_price":totalEditedShippingPrice,
          "subtotal":totalPriceEditProduct,
          "total_price": totalPriceEditProduct+totalEditedShippingPrice,
        });
        if (!isEditedProductNull()) {
          await Future.wait(editedProduct.map((e) async {
            await Firestore.instance
                .collection("transaction")
                .document(widget.transactionId)
                .collection("items")
                .document(e.docId)
                .updateData({
              "amount": e.product.amount,
              "total_price": e.product.totalPrice,
            });
          }));
        }
      })).then((value) {
        pr.hide();
        (context as Element).reassemble();
        isEditMode = false;
        CustomWidget.showFlushBar(context, "Berhasil Diubah");
      });
    } catch (e) {
      pr.hide();
      print(e.toString());
      CustomWidget.showFlushBar(context, "Gagal");
      isEditMode = false;
      return;
    }
  }

  void _handleCancelButton(String docId) async {
    Navigator.pop(context);
    pr.show();
    try {
      await TradeServices(context).cancelOrder(docId).then((value) {
        pr.hide();
        Navigator.pop(context);
        CustomWidget.showFlushBar(context, "Berhasil Diubah");
      });
    } catch (e) {
      CustomWidget.showFlushBar(context, "Gagal");
      pr.hide();
      print(e);
      isEditMode = false;
      return;
    }
  }
}
