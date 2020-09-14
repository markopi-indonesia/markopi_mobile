

class TransactionProductModel{
  String productId;
  int amount;
  String name;
  String units;
  int price;
  int totalPrice;

  TransactionProductModel( {this.name, this.units, this.price, this.totalPrice,this.productId, this.amount});

  factory TransactionProductModel.fromJson(Map<String,dynamic> json) => TransactionProductModel(
    productId: json["product_id"],
    name: json['product_name'],
    price: json['product_price'],
    totalPrice: json['total_price'],
    units: json['product_units'],
    amount: json['amount'],
  );

}