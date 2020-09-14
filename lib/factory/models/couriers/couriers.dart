

import 'package:equatable/equatable.dart';

class CourierModel extends Equatable{
  int id;
  String name;
  String estimatedDay;
  int price;

  CourierModel({this.id,this.name,this.estimatedDay,this.price});

  factory CourierModel.fromJson(Map<String,dynamic> json)=>CourierModel(
    id: json['id'],
    name: json["name"],
    estimatedDay: json['estimated_day'],
    price:json['price'],
  );

  toJson()=>{
    "id":id,
    "name":name,
    "estimated_day":estimatedDay,
    "price":price,
  };

  @override
  List<Object> get props => [id,name,estimatedDay];}