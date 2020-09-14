

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markopi_mobile/factory/models/transaction/transaction_product.dart';

class TransactionModel{
  final int id;
  final String userId;
  List<TransactionProductModel> productsId;
  final Timestamp createdAt;
  final String addressTitle;
  final String address;
  final String email;
  final String phoneNumber;
  final String userName;
  final int totalPrice;
  final int subTotal;
  final String deliveryName;
  final int status;
  final String statusText;
  final String image;
  final int paymentStatus;
  final String paymentStatusText;
  final int shippingPrice;
  final int orderStatus;
  final String orderStatusText;
  final String estimatedDay;
  final String courier;
  final String customerNotes;

  TransactionModel( {this.subTotal,this.shippingPrice,   this.courier,this.image,this.orderStatus, this.orderStatusText, this.paymentStatus, this.paymentStatusText,  this.statusText,this.status, this.id, this.userId, this.productsId, this.createdAt, this.addressTitle, this.address, this.email, this.phoneNumber, this.userName, this.totalPrice, this.deliveryName, this.estimatedDay, this.customerNotes});


  factory TransactionModel.fromJson(Map<String,dynamic> json)=>TransactionModel(
    id: json['id'],
    userId: json['user_id'],
    createdAt: json['created_at'],
    addressTitle: json['address_title'],
    address: json['address'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    userName: json['user_name'],
    totalPrice: json['total_price'],
    subTotal: json['subtotal'],
    deliveryName: json['delivery_name'],
    status: json['status'],
    image: json['images'],
      paymentStatus: json['payment_status'],
      paymentStatusText: json['payment_status_text'],
    shippingPrice: json['shipping_price'],
    orderStatus: json['order_status'],
    orderStatusText: json['order_status_text'],
    statusText: json['status_text'],
    estimatedDay: json['estimated_day'],
    courier: json['courier'],
    customerNotes: json['customer_notes']
  );

}