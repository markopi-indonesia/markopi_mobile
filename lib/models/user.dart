

class UserModel{
  String id;
  String email;
  String name;
  String phoneNumber;

  UserModel( {this.id, this.email,this.name,this.phoneNumber});

  factory UserModel.fromJson(Map<String,dynamic> json)=>UserModel(
    id: json['id']??null,
    email: json['email']??null,
    name: json['name']??null,
    phoneNumber: json['phone_number']??null,
  );

  Map<String,dynamic> toJson()=>{
    "id":id??null,
    "email":email??null,
    "name":name??null,
    "phone_number":phoneNumber??null,
  };

}