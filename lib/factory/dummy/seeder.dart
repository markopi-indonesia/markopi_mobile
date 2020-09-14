
import 'package:markopi_mobile/factory/models/products/product.dart';

class Seeder{

  static seedProduct(){
    List<Product> _products=[];
    _products.add(Product(
      name: "Kopi Roubsta",
      subName: "Green Bean",
      price: 75000,
      perAmount: "Kg",
      image: "https://as2.ftcdn.net/jpg/00/60/32/95/500_F_60329515_GjQiSUdiTzVUU9gBeoMIOzML6IWOidWo.jpg"
    ));

    _products.add(Product(
      name: "Kopi Luwak",
      subName: "Green Bean",
      price: 50000,
      perAmount: "Kg",
      image: "https://as2.ftcdn.net/jpg/02/17/33/97/500_F_217339703_f8t8l574PCixzcWy4i1O64LR2MXQScYx.jpg"
    ));
    _products.add(Product(
      name: "Kopi Luwak",
      subName: "Green Bean",
      price: 50000,
      perAmount: "Kg",
      image: "https://as2.ftcdn.net/jpg/02/17/33/97/500_F_217339703_f8t8l574PCixzcWy4i1O64LR2MXQScYx.jpg"
    ));
    _products.add(Product(
      name: "Kopi Luwak",
      subName: "Green Bean",
      price: 50000,
      perAmount: "Kg",
      image: "https://as2.ftcdn.net/jpg/02/17/33/97/500_F_217339703_f8t8l574PCixzcWy4i1O64LR2MXQScYx.jpg"
    ));

    return _products;
  }
}