import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/factory/models/cart/cart.dart';
import 'package:markopi_mobile/factory/models/order/user_detail.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';
import 'package:markopi_mobile/helpers/constants.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/pages/trades/sales/manipulate_product/manipulate_product.dart';
import 'package:markopi_mobile/resources/trades/cart/bloc/cart_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class TradeServices {
  final BuildContext context;

  TradeServices(this.context);

  Future<DocumentReference> storeProduct(
      {ManipulateProductScreenState parent}) async {
    print(parent.price);
    return await Firestore.instance.collection("product").add({
      "id": parent.id,
      "name": parent.name,
      "price": parent.price,
      "type": parent.type,
      "description": parent.description,
      "units": parent.units,
      "total_goods": parent.totalGoods,
      "user_id": parent.user.uid,
      "created_at": Timestamp.now(),
    });
  }


  Future cancelOrder(String docId)async{
    await Firestore.instance.collection("transaction").document(docId).updateData({
      "status":ORDER_CANCELLED,
      "status_text":Converter.getStatusOrder(ORDER_CANCELLED),
      "order_status":ORDER_COMPLETED,
      "order_status_text":Converter.getStatusOrderSpecifically(ORDER_COMPLETED),
    });
  }

  Future<DocumentReference> storeTransaction(
      {UserOrderDetailModel userDetail, CartModel cart,List<ProductModel> singleProducts,int shippingPrice}) async {
    int newId = await generateNewTransactionId();
    if(singleProducts.length>0){
      var data = await Firestore.instance.collection("transaction").add({
        "id": newId,
        "user_id": userDetail.user.id,
        "status": ORDER_ON_PROGRESS,
        "status_text": Converter.getStatusOrder(ORDER_ON_PROGRESS),
        "created_at": Timestamp.now(),
        "address_title": userDetail.chosenAddress.addressTitle,
        "address": userDetail.chosenAddress.address,
        "email": userDetail.user.email,
        "images":"",
        "shipping_price":shippingPrice,
        "order_status":ORDER_PROCESSING,
        "order_status_text":Converter.getStatusOrderSpecifically(ORDER_PROCESSING),
        "payment_status":PAYMENT_UNPAID,
        "payment_status_text":Converter.getPaymentPaidStatus(PAYMENT_UNPAID),
        "phone_number": userDetail.chosenAddress.phoneNumber,
        "user_name": userDetail.user.name,
        "subtotal": singleProducts.fold(0, (previousValue, element) => previousValue+element.price),
        "total_price": singleProducts.fold(0, (previousValue, element) => previousValue+element.price)+shippingPrice,
        "delivery_name": userDetail.chosenAddress.deliveryName,
        "estimated_day": userDetail.chosenShippingMethod.estimatedDay,
        "courier": userDetail.chosenShippingMethod.name,
        "customer_notes": userDetail.notes,
      });
      await Firestore.instance
          .collection("transaction")
          .document(data.documentID)
          .collection("items")
          .add({
        "product_id":singleProducts[0].productId,
        "amount": singleProducts.length,
        "product_name":singleProducts[0].name,
        "product_units":singleProducts[0].units,
        "product_price":singleProducts[0].price,
        "total_price": singleProducts.fold(0, (previousValue, element) => previousValue+element.price),
      });
      return data;
    } else {

      var data = await Firestore.instance.collection("transaction").add({
        "id": newId,
        "user_id": userDetail.user.id,
        "status": ORDER_ON_PROGRESS,
        "status_text": Converter.getStatusOrder(ORDER_ON_PROGRESS),
        "created_at": Timestamp.now(),
        "address_title": userDetail.chosenAddress.addressTitle,
        "address": userDetail.chosenAddress.address,
        "email": userDetail.user.email,
        "shipping_price":shippingPrice,
        "order_status":ORDER_PROCESSING,
        "order_status_text":Converter.getStatusOrderSpecifically(ORDER_PROCESSING),
        "images":"",
        "payment_status":PAYMENT_UNPAID,
        "payment_status_text":Converter.getPaymentPaidStatus(PAYMENT_UNPAID),
        "phone_number": userDetail.chosenAddress.phoneNumber,
        "user_name": userDetail.user.name,
        "subtotal": cart.totalPrice,
        "total_price": cart.totalPrice+shippingPrice,
        "delivery_name": userDetail.chosenAddress.deliveryName,
        "estimated_day": userDetail.chosenShippingMethod.estimatedDay,
        "courier": userDetail.chosenShippingMethod.name,
        "customer_notes": userDetail.notes,
      });
      await Future.wait(
          List.generate(cart.products.toSet().length, (index) async {
            ProductModel curProduct = cart.products.toSet().toList()[index];
        await Firestore.instance
            .collection("transaction")
            .document(data.documentID)
            .collection("items")
            .add({
          "product_id":curProduct.productId,
          "amount": cart.products
              .where((element) =>
                  element.id == curProduct.id)
              .toList()
              .length,
          "product_name":curProduct.name,
          "product_units":curProduct.units,
          "product_price":curProduct.price,
          "total_price": cart.products
              .where((element) =>
                  element.id == curProduct.id)
              .toList()
              .fold(0, (previousValue, element) => previousValue + element.price),
        });
      }));
      return data;

    }
  }

  Future<int> generateNewProductId() async {
    var getCurrentDocuments = await Firestore.instance
        .collection("product")
        .orderBy("id")
        .getDocuments();
    var currentDocuments = getCurrentDocuments.documents;
    var newProductId = 0;
    if (currentDocuments.isNotEmpty) {
      newProductId = currentDocuments.last['id'] + 1;
    } else
      newProductId = currentDocuments.length + 1;
    return newProductId;
  }

  Future<int> generateNewTransactionId() async {
    var getCurrentDocuments = await Firestore.instance
        .collection("transaction")
        .orderBy("id")
        .getDocuments();
    var currentDocuments = getCurrentDocuments.documents;
    var newTransactionId = 0;
    if (currentDocuments.isNotEmpty) {
      newTransactionId = currentDocuments.last['id'] + 1;
    } else
      newTransactionId = currentDocuments.length + 1;
    return newTransactionId;
  }

  Future<void> approveTransaction({String docId})async{
    return await Firestore.instance.collection("transaction").document(docId).updateData({
      "order_status":ORDER_COMPLETED,
      "order_status_text":Converter.getStatusOrderSpecifically(ORDER_COMPLETED),
      "status":ORDER_SUCCESS,
      "status_text":Converter.getStatusOrder(ORDER_SUCCESS),
      "updated_at":Timestamp.now(),
    });
  }

  Future updateTransactionPayments({String docId})async{
    await Firestore.instance.collection("transaction").document(docId).updateData({
      "payment_status":PAYMENT_PAID,
      "payment_status_text":Converter.getPaymentPaidStatus(PAYMENT_PAID),
      "order_status":ORDER_PROCESSING,
      "order_status_text":Converter.getStatusOrderSpecifically(ORDER_PROCESSING),
      "status":ORDER_ON_PROGRESS,
      "status_text":Converter.getStatusOrder(ORDER_ON_PROGRESS),
      "updated_at":Timestamp.now(),
    });
  }

  Future<void> uploadImagesIntoFirebase({
    List<String> imageList,
    String singleImage,
    String collection = "product",
    @required documentID,
  }) async {
    print("Uploading images...");
    await Firestore.instance
        .collection(collection)
        .document(documentID)
        .updateData({
      "updated_at": Timestamp.now(),
      "images": imageList ?? singleImage,
    });
  }

  Future<List<String>> uploadImages(
      List<Asset> images, ProgressDialog pr) async {
    List<String> imagesName = [];
    try {
      await Future.wait(
          images.map((image) async {
            ByteData byteData = await image.getByteData();

            List<int> imageData = byteData.buffer.asUint8List();
            if (byteData.lengthInBytes / 1024 / 1000 > 5) {
              return;
            }
            final ext = image.name.split(".").last;
            final now = DateTime.now().millisecondsSinceEpoch;
            final uuid = Uuid().v4();
            final completeName = "${uuid}_$now.$ext";
            StorageReference reference = FirebaseStorage.instance
                .ref()
                .child("product_images/$completeName");

            StorageUploadTask uploadTask = reference.putData(imageData);
            pr.update(
              progress: 50.0,
              message:
                  "Uploading image ${images.indexOf(image)}/${images.length}",
              progressWidget: Container(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()),
              maxProgress: 100.0,
              progressTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600),
            );
            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            if (snapshot.error == null) {
              imagesName.add(completeName);
              pr.update(
                message:
                    "Uploading image ${imagesName.length}/${images.length}",
              );
              print('Upload Image Success...');
            } else {
              print('Error from image repo ${snapshot.error.toString()}');
              throw ('This file is not an image');
            }
          }),
          eagerError: true,
          cleanUp: (_) {
            print('eager cleaned up');
          });
    } catch (_) {
      print(_.toString());
      CustomWidget.showFlushBar(context, "Upload Image error");
    }

    return imagesName;
  }

  Future<String> uploadImage(File file) async {
    final ext = file.path.split(".").last;
    final now = DateTime.now().millisecondsSinceEpoch;
    final uuid = Uuid().v4();
    final completeName = "${uuid}_$now.$ext";
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("transaction_images/$completeName");

    StorageUploadTask uploadTask = reference.putData(file.readAsBytesSync());
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      print('Upload Image Success...');
      return completeName;
    } else {
      print('Error from image repo ${snapshot.error.toString()}');
      throw ('This file is not an image');
    }
  }

  Future<Map<String, dynamic>> pickMultipleImage(List<Asset> pickedImages,
      {int limitImage}) async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: limitImage,
        enableCamera: true,
        selectedAssets: pickedImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    return {"result": resultList, "error": error};
  }

  Future<void> deleteImages({@required List removedImages}) async {
    if (removedImages.length > 0) {
      await Future.wait(removedImages.map((e) async {
        await FirebaseStorage.instance
            .ref()
            .child("product_images")
            .child(e)
            .delete();
      }));
    } else {
      print("No deleted image(s)");
    }
  }

  Future<void> updateProduct({
    ManipulateProductScreenState parent,
    ProgressDialog progressDialog,
  }) async {
    print(parent.price);
    print("Updating product data...");
    await Firestore.instance
        .collection("product")
        .document(parent.productId)
        .updateData({
      "name": parent.name,
      "description": parent.description,
      "price": parent.price,
      "total_goods": parent.totalGoods,
      "type": parent.type,
      "units": parent.units,
      "updated_at": Timestamp.now(),
    });

    var removedImages = [];
    parent.immutablePickedImagesFromServer.forEach((element) {
      if (!parent.pickedImagesFromServer.contains(element)) {
        removedImages.add(element);
      }
    });

    final list = await uploadImages(parent.pickedImages, progressDialog);
    if (parent.pickedImagesFromServer.length > 0) {
      parent.pickedImagesFromServer.forEach((element) {
        list.add(element);
      });
    }

    parent.pickedImagesFromServer = list;
    await deleteImages(removedImages: removedImages);
    await uploadImagesIntoFirebase(imageList: list, documentID: parent.productId);
  }

  Future<void> deleteProduct({
    @required String docId,
  }) async {
    try {
      var relatedImages = [];
      var res =
          await Firestore.instance.collection("product").document(docId).get();
      relatedImages = res.data['images'];
      await Firestore.instance.collection("product").document(docId).delete();
      await deleteImages(removedImages: relatedImages);
    } catch (e) {
      CustomWidget.showFlushBar(context, "An error Occured");
      print(e);
    }
  }
}
