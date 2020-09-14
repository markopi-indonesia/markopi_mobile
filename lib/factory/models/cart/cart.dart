
import 'package:equatable/equatable.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';

class CartModel extends Equatable{
  final List<ProductModel> products;
  CartModel.fromJson(Map<String,dynamic> data):
        products=data['carts'];

  toJson(){
    List<Map<String,dynamic>> data=[];
    products.forEach((element) {
      data.add(element.tojson());
    });

    return data;
  }

  CartModel({this.products});

  int get totalPrice=> products.fold(0, (previousValue, element) =>previousValue+ element.price);

  @override
  List<Object> get props => [products];


}