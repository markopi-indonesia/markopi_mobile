


import 'package:equatable/equatable.dart';

class ShippingMethodModel extends Equatable{
  String name;
  String estimatedDays;

  ShippingMethodModel({this.name, this.estimatedDays});

  @override
  List<Object> get props => [name,estimatedDays];

  factory ShippingMethodModel.fromJson(Map<String,dynamic> json)=>ShippingMethodModel(
    name: json['name']??"",
    estimatedDays: json['estimated_day']??"",
  );

  toJson()=>{
    "name":name??"",
    "estimated_day":estimatedDays??"",
  };
}