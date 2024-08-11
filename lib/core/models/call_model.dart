import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum CallStatus {accepted, waiting, rejected}
class CallData
{
  List<CallModel> waitingCalls = [];
  List<CallModel> acceptedCalls = [];
  List<CallModel> rejectedCalls = [];
}

class CallModel
{

  String? id;
  String? schoolId;
  String? parentId;
  String? superParentId;
  String? kidId;
  String? levelId;
  double? parentLong;
  double? parentLat;
  Timestamp? createdAt;
  Timestamp? editedAt;
  int? status;
  String? rejectReason;

  // data not stored in firebase
  SchoolModel? schoolModel;
  ParentModel? parentModel;
  KidModel? kidModel;

  CallModel({
    this.id,
    this.schoolId,
    this.kidId,
    this.parentId,
    this.superParentId,
    this.parentLong,
    this.parentLat,
    this.createdAt,
    this.editedAt,
    this.status,
    this.levelId,
    this.rejectReason
  });

  // 0 => rejected
  // 2 => waiting
  // 1 => accepted

  CallModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    schoolId = json['schoolId'];
    parentId = json['parentId'];
    superParentId = json['superParentId'];
    kidId = json['kidId'];
    parentLong = json['parentLong'];
    parentLat = json['parentLat'];
    createdAt = json['createdAt'];
    editedAt = json['editedAt'];
    status = json['status'];
    rejectReason = json['rejectReason'];
    levelId = json['levelId'];
  }

  Map<String, dynamic> toJson()
  {
    return
      {
        'schoolId' : schoolId,
        'id' : id,
        'parentId' : parentId,
        'kidId' : kidId,
        'parentLong' : parentLong,
        'parentLat' : parentLat,
        'createdAt' : createdAt,
        'editedAt' : editedAt,
        'status' : status??2,
        'rejectReason' : rejectReason,
        'levelId' : levelId,
      };
  }

}