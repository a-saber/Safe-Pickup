import 'package:call_son/core/models/kid_model.dart';

class ParentModel
{
  String? id;
  String? name;
  String? phone;
  String? email;
  String? ssn;
  bool? fullAccess;
  bool? isSuperParent;
  String? superParentId;

  // not stored in firebase
  List<KidModel> kidsModels=[];
  String? password;


  ParentModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.ssn,
    this.fullAccess,
    this.isSuperParent,
    this.superParentId,
  });


  ParentModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    ssn = json['ssn'];
    fullAccess = json['fullAccess'];
    isSuperParent = json['isSuperParent'];
    superParentId = json['superParentId'];
  }

  Map<String, dynamic> toJson()
  {
    return
      {
        'name' : name,
        'id' : id,
        'phone' : phone,
        'email' : email,
        'ssn' : ssn,
        'fullAccess' : fullAccess,
        'isSuperParent' : isSuperParent,
        'superParentId' : superParentId,
      };
  }

  Map<String, dynamic> toJsonUpdateData()
  {
    return
      {
        'name' : name,
        'phone' : phone,
        'ssn' : ssn,
      };
  }
}
