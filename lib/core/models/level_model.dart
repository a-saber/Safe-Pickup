import 'package:flutter/material.dart';

class LevelModel
{
  String? id;
  String? name;

  // data not stored in firebase
  bool isDeleted = false;
  bool isNew = false;
  TextEditingController controller = TextEditingController();


  LevelModel({
    this.isNew = false,
    this.isDeleted = false,
    this.id,
    this.name,
  }){controller.text = name??'';}

  LevelModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    controller.text = name??'';
    id = json['id'];
  }

  Map<String, dynamic> toJson()
  {
    return
      {
        'name' : name,
        'id' : id,
      };
  }
}

