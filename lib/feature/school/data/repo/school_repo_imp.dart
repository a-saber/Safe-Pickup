import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/shared_functions/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'school_repo.dart';

class SchoolRepoImplementation extends SchoolRepo
{
  @override
  Future<Either<Failure, void>> updateData({
    required SchoolModel schoolModel,
  }) async {
    try {
      // Upload Image if exists
      if(schoolModel.image != null) {
        var responseURL = await FirebaseManager.uploadImage(image: schoolModel.image!);
        responseURL.fold((l) {return left(l);}, (r) {schoolModel.imagePath = r;});
      }

      // Update Account Data
      await FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
          .doc(schoolModel.id).update(schoolModel.toJsonUpdate());

      return right(null);
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocationData({
    required SchoolModel schoolModel,
  }) async {
    try {

      await FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
          .doc(schoolModel.id).update(schoolModel.toJsonUpdateLocation());

      return right(null);
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, void>> editLevels({
    required List<LevelModel> levels,
  }) async {
    try {

      final batch = FirebaseFirestore.instance.batch();
      var levelFire = FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(CollectionManager.levelsCollection);
      for (var level in levels)
      {
        if(level.isNew)
        {
          level.name = level.controller.text;
          level.id = levelFire.doc().id;
          batch.set(
              levelFire.doc(level.id),
              level.toJson()
          );
        }
        else if(level.isDeleted)
        {
          batch.delete(levelFire.doc(level.id));
        }
        else
        {
          level.name = level.controller.text;
          batch.update(
              levelFire.doc(level.id),
              level.toJson()
          );
        }


      }
      await batch.commit();
      return right(null);
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LevelModel>>> getLevels() async
  {
    try {

      final response = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(CollectionManager.levelsCollection)
          .get();
      List<LevelModel> levels = [];
      Future.forEach(response.docs, (element) {
        levels.add(LevelModel.fromJson(element.data()));
      });
      return right(levels);

    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, void>> changeGuardianVerification({required String guardianId, required bool isVerify}) {
    // TODO: implement changeGuardianVerification
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CallData>> getCalls() {
    // TODO: implement getCalls
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ParentModel>>> getNotVerifiedGuardians() {
    // TODO: implement getNotVerifiedGuardians
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ParentModel>>> getVerifiedGuardians() {
    // TODO: implement getVerifiedGuardians
    throw UnimplementedError();
  }



  @override
  Future<Either<Failure, bool>> changeCallStatus({
    required String callId,
    required bool accepted,
    String? reply
  }) async
  {
    try{
    await FirebaseFirestore.instance.
    collection(CollectionManager.callCollection).doc(callId)
    .update({
      "status": accepted ? 1 : 0,
      "rejectReason": reply ,
      "editedAt":Timestamp.fromDate(DateTime.now())
    });
    return right(accepted);
    }
    catch(e)
    {
      print(e.toString());
      if (e is FirebaseAuthException)
      {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, void>> changeGuardianVerification({
  //   required String guardianId,
  //   required bool isVerify
  // }) async
  // {
  //   try {
  //     await FirebaseFirestore.instance.
  //     collection(CollectionManager.schoolCollection).doc(SchoolParent.schoolModel.id)
  //         .collection(CollectionManager.guardianCollection).doc(guardianId)
  //         .update({
  //       "verified": isVerify,
  //     });
  //     return right(0);
  //   }
  //   catch(e)
  //   {
  //     print(e.toString());
  //     if (e is FirebaseAuthException) {
  //       return left(FirebaseFailure.fromFirebaseAuthException(e));
  //     }
  //     return left(FirebaseFailure(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, List<GuardianModel>>> getVerifiedGuardians() async
  // {
  //   try
  //   {
  //     var response = await FirebaseFirestore.instance.collection(CollectionManager.schoolCollection)
  //         .doc(SchoolParent.schoolModel.id).collection(CollectionManager.guardianCollection)
  //         .where('verified', isEqualTo: true).get();
  //     if(response.docs.isNotEmpty)
  //     {
  //       List<GuardianModel> guardians=[];
  //       response.docs.forEach((element) async
  //       {
  //         print(element.id);
  //         GuardianModel? guardianModel = await FirebaseManager.getGuardianById(element.id);
  //         if(guardianModel != null)
  //         {
  //           guardians.add(guardianModel);
  //         }
  //       });
  //       return right(guardians);
  //     }
  //     else
  //     {
  //       return left(DataFailure('No Data'));
  //     }
  //   }
  //   catch(e)
  //   {
  //     print(e.toString());
  //     if (e is FirebaseAuthException)
  //     {
  //       return left(FirebaseFailure.fromFirebaseAuthException(e));
  //     }
  //     return left(FirebaseFailure(e.toString()));
  //
  //   }
  //
  // }
  //
  // @override
  // Future<Either<Failure, List<GuardianModel>>> getNotVerifiedGuardians() async
  // {
  //   try
  //   {
  //     var response = await FirebaseFirestore.instance.collection(CollectionManager.schoolCollection)
  //     .doc(SchoolParent.schoolModel.id).collection(CollectionManager.guardianCollection)
  //     .where('verified', isEqualTo: false).get();
  //     if(response.docs.isNotEmpty)
  //     {
  //       List<GuardianModel> guardians=[];
  //       response.docs.forEach((element) async
  //       {
  //         GuardianModel? guardianModel = await FirebaseManager.getGuardianById(element.id);
  //         if(guardianModel != null)
  //         {
  //           guardians.add(guardianModel);
  //         }
  //       });
  //       return right(guardians);
  //     }
  //     else
  //     {
  //       return left(DataFailure('No Data'));
  //     }
  //   }
  //   catch(e)
  //   {
  //     print(e.toString());
  //     if (e is FirebaseAuthException)
  //     {
  //       return left(FirebaseFailure.fromFirebaseAuthException(e));
  //     }
  //     return left(FirebaseFailure(e.toString()));
  //
  //   }
  // }
  //
  //
  //
  // @override
  // Future<Either<Failure, CallData>> getCalls() async
  // {
  //   try
  //   {
  //     CallData callData= CallData();
  //     var schoolCallsResponse = await FirebaseFirestore.instance
  //         .collection(CollectionManager.callCollection)
  //         .where('schoolId', isEqualTo: SchoolParent.schoolModel.id)
  //         .orderBy('dateTime', descending: true).snapshots()
  //         .listen((event) async {
  //           await Future.forEach(
  //               event.docs,
  //                   (callResponse) async{
  //                 CallModel? call = CallModel.fromJson(callResponse.data());
  //                 call.guardianModel = await FirebaseManager.getGuardianById(call.guardianId!);
  //                 call.kidModel = await FirebaseManager.getKidById(call.kidId!);
  //                 call.kidModel!.levelModel = await FirebaseManager.getKidSchoolLevel(
  //                     schoolId: SchoolParent.schoolModel.id!,
  //                     kidId: call.kidId!
  //                 );
  //                 if(call.status == '0')
  //                 {
  //                   callData.rejectedCalls.add(call);
  //                 }
  //                 else if(call.status == '1')
  //                 {
  //                   callData.acceptedCalls.add(call);
  //                 }
  //                 else
  //                 {
  //                   callData.waitingCalls.add(call);
  //                 }
  //               });
  //         });
  //     return right(callData);
  //   }
  //     catch(e)
  //     {
  //       print(e.toString());
  //       if (e is FirebaseAuthException)
  //       {
  //         return left(FirebaseFailure.fromFirebaseAuthException(e));
  //       }
  //       return left(FirebaseFailure(e.toString()));
  //
  //     }
  //
  // }

}
