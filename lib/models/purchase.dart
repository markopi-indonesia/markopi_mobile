import 'package:markopi_mobile/factory/models/products/product.dart';
import 'package:markopi_mobile/models/user.dart';

class PurchaseModel {
  String id;
  ProductModel product;
  UserModel user;
  String orderDate;
  int status;
  int orderAmount;
  String notes;
  int totalPrice;

  PurchaseModel(
      {this.id,ProductModel product, this.user,this.status,this.orderDate, this.orderAmount, this.notes, this.totalPrice}):product=product??new ProductModel();

  @override
  String toString() {
    return ""
        "\nUser\t: ${user==null?"null":user.toJson()}"
        "\nOrder Amount\t: ${orderAmount??"null"}"
        "\nNotes\t: ${notes??""}"
        "\nTotal Prices\t: ${totalPrice??""}";
  }
}
