import 'package:call_son/core/models/school_model.dart';
import 'package:flutter/material.dart';


class KidModel
{
  String? id;
  String? name;
  String? superParentId;

  // data for ui not stored in firebase
  List<SchoolModel> schools=[];
  TextEditingController nameController = TextEditingController();

  KidModel({
    this.id,
    this.name,
    this.superParentId,
    List<SchoolModel>? schools
  }){this.schools = schools??[];
  nameController.text = name??'';}


  KidModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    superParentId = json['superParentId'];
    nameController.text = name??'';
  }

  Map<String, dynamic> toJson()
  {
    return
      {
        'id' : id,
        'name' : name,
        'superParentId' : superParentId,
      };
  }

  Map<String, dynamic> toJsonUpdate()
  {
    return
      {
        'name' : name,
      };
  }

}