

import 'package:markopi_mobile/factory/models/couriers/couriers.dart';

class Couriers{
  static List<CourierModel> couriers = [
    CourierModel(
      id: 1,
      name: "J&T",
      estimatedDay:"Express(3 hari)",
      price: 25000
    ),
    CourierModel(
      id:2,
      name: "TIKI",
      estimatedDay: "Express(3 hari)",
      price: 25000
    ),
    CourierModel(
      id: 3,
      name: "Sicepat",
      price: 25000,
      estimatedDay: "Express(3 hari)"
    )
  ];
}