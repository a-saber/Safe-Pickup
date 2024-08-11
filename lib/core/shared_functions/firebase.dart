import 'dart:io';

import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../resources_manager/constants_manager.dart';

class FirebaseManager
{

  static Future<Either<Failure, String>> uploadImage({required XFile image}) async {
    try {
      var response = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(image.path).pathSegments.last}')
          .putFile(File(image.path));
      String url = await response.ref.getDownloadURL();
      return right(url);
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }




  static Future<SchoolModel?> getSchoolById(String id) async
  {
    try
    {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
          .doc(id).get();
      return SchoolModel.fromJson(response.data()!);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  static Future<ParentModel?> getGuardianById(String id) async
  {
    try
    {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
          .doc(id).get();
      return ParentModel.fromJson(response.data()!);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  static Future<KidModel?> getKidById(String id) async
  {
    try
    {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
          .doc(id).get();
      return KidModel.fromJson(response.data()!);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  static Future<LevelModel?> getKidSchoolLevel({required String schoolId, required String kidId}) async
  {
    try
    {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
          .doc(kidId).collection(CollectionManager.schoolsCollection).doc(schoolId).get();
      LevelModel? level = await getLevelById(schoolId: schoolId, levelId: response.data()!['levelId']);
      return level;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  static Future<LevelModel?> getLevelById({required String schoolId, required String levelId}) async
  {
    try
    {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
          .doc(schoolId).collection(CollectionManager.levelsCollection).doc(levelId).get();
      LevelModel level = LevelModel.fromJson(response.data()!);
      level.id = response.id;
      return level;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  static Future<CallModel?> getCallById(String id) async
  {
    try
    {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.callCollection)
          .doc(id).get();
      return CallModel.fromJson(response.data()!);
    }
    catch(e)
    {
      return null;
    }
  }

  static Future<void> addDoc({required String collection, required model}) async
  {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(model.id)
        .set(model.toJsonRegister());
  }
  static Future<String> sendCode({
    required String phone,
    required BuildContext context,
    required String route,
  }) async
  {
    String code='';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        code=verificationId;
        //GoRouter.of(context).push(route);
        print("*****************************$code****************************");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},

    );
    return code;
  }
  static Future<UserCredential> verifyCode({
    required String code,
    required String smsCode,
  }) async
  {
    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(
      verificationId: code,
      smsCode: smsCode,
    );
    final FirebaseAuth auth=FirebaseAuth.instance;
    UserCredential userModel=await auth.signInWithCredential(credential);
    return userModel;
  }
}