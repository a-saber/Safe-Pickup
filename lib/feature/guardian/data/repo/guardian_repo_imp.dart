import 'dart:math';

import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/school_kid_model.dart';
import 'package:call_son/core/models/school_parent_verify_model.dart';
import 'package:call_son/core/notification_manager/push_notification_service.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/shared_functions/location.dart';
import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../core/models/parent_model.dart';
import 'guardian_repo.dart';

class GuardianRepoImplementation extends GuardianRepo {
// Function to calculate the bounding box
  Map<String, double> calculateBoundingBox(
      {required double lat,required double lon,required double distanceInKm}) {
    const double earthRadius = 6371.0; // Radius of the Earth in km
    double deltaLat = distanceInKm / earthRadius;
    double deltaLon = distanceInKm / (earthRadius * cos(pi * lat / 180.0));

    return {
      'minLat': lat - deltaLat,
      'maxLat': lat + deltaLat,
      'minLon': lon - deltaLon,
      'maxLon': lon + deltaLon,
    };
  }


  @override
  Future<Either<Failure, List<SchoolModel>>> getNearBySchools(context, {required double distanceInKm}) async
  {
    try
    {
      await LocationManager.getPermission(context: context);
      Position? currentLocation = await LocationManager.getCurrentLocation();
      // Calculate bounding box
      print(currentLocation!.longitude);
      print(currentLocation.latitude);
      final boundingBox = calculateBoundingBox(
          lat: currentLocation.latitude,
          lon: currentLocation.longitude, distanceInKm: distanceInKm
      );

      // Query FireStore within the bounding box
      var schoolsQuery = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection)
          .where('lat', isGreaterThanOrEqualTo: boundingBox['minLat'])
          .where('lat', isLessThanOrEqualTo: boundingBox['maxLat'])
          .get();

      // Filter results within the longitude range
      var nearbySchools = schoolsQuery.docs.where((doc) {
        double schoolLon = doc['long'];
        return schoolLon >= boundingBox['minLon']! && schoolLon <= boundingBox['maxLon']!;
      }).toList();
      List<SchoolModel> schools=[];
      Future.forEach(nearbySchools, (element)
      {
        schools.add( SchoolModel.fromJson(element.data()) );
      });
      return right(schools);
    }
    catch (e)
    {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<SchoolModel>>> getSchools() async
  {
    List<SchoolModel> schools=[];
    try
    {
      var schoolsResponse = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection).get();
      await Future.forEach(
          schoolsResponse.docs,
              (element) async{
            schools.add( SchoolModel.fromJson(element.data()) );
          });
      if (schools.isEmpty)
      {
        return left(DataFailure('No Schools'));
      }
      else
      {
        return right(schools);
      }
    }
    catch (e)
    {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SchoolModel>>> searchSchools({required String schoolName}) async
  {
    List<SchoolModel> schools=[];
    try
    {
      var schoolsResponse = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection)
          .where('name', isGreaterThanOrEqualTo: schoolName)
          .where('name', isLessThanOrEqualTo: schoolName + '\uf8ff').get();
      await Future.forEach(
          schoolsResponse.docs,
              (element) async{
            schools.add( SchoolModel.fromJson(element.data()) );
          });
      if (schools.isEmpty)
      {
        return left(DataFailure(TranslationKeyManager.noSchoolFound.tr));
      }
      else
      {
        return right(schools);
      }
    }
    catch (e)
    {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LevelModel>>> getLevels({required String schoolId}) async
  {
    List<LevelModel> levels=[];
    try
    {
      var levelsResponse = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection).
      doc(schoolId)
          .collection(CollectionManager.levelsCollection).get();
      await Future.forEach(levelsResponse.docs, (levelMap)
      {
        LevelModel levelModel = LevelModel.fromJson(levelMap.data());
        levelModel.id = levelMap.id;
        levels.add(levelModel);
      });
      if (levels.isEmpty)
      {
        return left(DataFailure('No Schools'));
      }
      else
      {
        return right(levels);
      }
    }
    catch (e)
    {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addKidSchoolLevel(
      {required String kidId, required String schoolId, required String levelId})
  async
  {
    try {
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      final batch = fireStoreInstance.batch();

      SchoolKidModel schoolKidModel = SchoolKidModel(
          id: '$schoolId$kidId',
          schoolId: schoolId,
          kidId: kidId,
          verified: false
      );

      var schoolCheckExist = await fireStoreInstance
          .collection(CollectionManager.schoolKidsCollection)
          .doc(schoolKidModel.id).get();
      if (!schoolCheckExist.exists) {
        batch.set(
            fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
                .doc(schoolKidModel.id),
            schoolKidModel.toJson()
        );
      }

      var levelCheckExist = await fireStoreInstance
          .collection(CollectionManager.schoolKidsCollection)
          .doc(schoolKidModel.id).collection(CollectionManager.levelsCollection)
          .doc(levelId).get();
      if (!levelCheckExist.exists) {
        batch.set(
            fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
                .doc(schoolKidModel.id).collection(CollectionManager.levelsCollection)
                .doc(levelId),
            {'levelId': levelId}
        );
      }



      String superParentId = FirebaseAuth.instance.currentUser!.uid;
      SchoolParentVerifyModel schoolParentVerifyModel = SchoolParentVerifyModel(
          id: '$schoolId$superParentId',
          schoolId: schoolId,
          superParentId: superParentId,
          isVerified: false
      );

      var parentSchoolCheckExist = await fireStoreInstance
          .collection(CollectionManager.schoolParentsCollection)
          .doc(schoolParentVerifyModel.id).get();
      if (!parentSchoolCheckExist.exists) {
        batch.set(
            fireStoreInstance.collection(CollectionManager.schoolParentsCollection).doc(schoolParentVerifyModel.id),
            schoolParentVerifyModel.toJson()
        );
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
  Future<Either<Failure, void>> deleteKidSchoolLevel({
    required String kidId, required String schoolId, required String levelId
  })
  async
  {
    try {
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      final batch = fireStoreInstance.batch();

      String schoolKidId = '$schoolId$kidId';

      batch.delete(
        fireStoreInstance
          .collection(CollectionManager.schoolKidsCollection)
          .doc(schoolKidId).collection(CollectionManager.levelsCollection)
          .doc(levelId)
      );
      var levelResponse = await fireStoreInstance
          .collection(CollectionManager.schoolKidsCollection)
          .doc(schoolKidId).collection(CollectionManager.levelsCollection)
      .get();
      if(levelResponse.docs.isEmpty)
      {
        batch.delete(
          fireStoreInstance
            .collection(CollectionManager.schoolKidsCollection)
            .doc(schoolKidId)
        );
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
  Future<Either<Failure, void>> newKid({required KidModel kid}) async
  {
    try {
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      final batch = fireStoreInstance.batch();

      kid.name = kid.nameController.text;
      kid.id = fireStoreInstance.collection(CollectionManager.kidsCollection).doc().id;
      String superParentId = FirebaseAuth.instance.currentUser!.uid;
      kid.superParentId = superParentId;
      batch.set(
          fireStoreInstance.collection(CollectionManager.kidsCollection)
              .doc(kid.id),
          kid.toJson()
      );

      for (var school in kid.schools)
      {
        SchoolKidModel schoolKidModel = SchoolKidModel(
            id: '${school.id}${kid.id}',
            schoolId: school.id,
            kidId: kid.id,
            verified: false
        );

        var schoolCheckExist = await fireStoreInstance
            .collection(CollectionManager.schoolKidsCollection)
            .doc(schoolKidModel.id).get();
        if (!schoolCheckExist.exists) {
          batch.set(
              fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
                  .doc(schoolKidModel.id),
              schoolKidModel.toJson()
          );
        }

        var levelCheckExist = await fireStoreInstance
            .collection(CollectionManager.schoolKidsCollection)
            .doc(schoolKidModel.id).collection(CollectionManager.levelsCollection)
            .doc(school.kidLevelModel!.id).get();
        if (!levelCheckExist.exists) {
          batch.set(
              fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
                  .doc(schoolKidModel.id).collection(CollectionManager.levelsCollection)
                  .doc(school.kidLevelModel!.id),
              {'levelId': school.kidLevelModel!.id}
          );
        }


        SchoolParentVerifyModel schoolParentVerifyModel = SchoolParentVerifyModel(
            id: '${school.id}$superParentId',
            schoolId: school.id,
            superParentId: superParentId,
            isVerified: false
        );

        var parentSchoolCheckExist = await fireStoreInstance.collection(CollectionManager.schoolParentsCollection)
            .doc(schoolParentVerifyModel.id).get();
        if (!parentSchoolCheckExist.exists) {
          batch.set(
              fireStoreInstance.collection(CollectionManager.schoolParentsCollection).doc(schoolParentVerifyModel.id),
              schoolParentVerifyModel.toJson()
          );
        }

      }


      // Commit the batch after all operations have been added
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
  Future<Either<Failure, void>> editKidLevel(
      {required String kidId, required String schoolId,
        required String oldLevelId, required String newLevelId})
  async
  {
    try {
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      final batch = fireStoreInstance.batch();

      String schoolKidId = '$schoolId$kidId';

      batch.delete(
          fireStoreInstance
              .collection(CollectionManager.schoolKidsCollection)
              .doc(schoolKidId).collection(CollectionManager.levelsCollection)
              .doc(oldLevelId)
      );
      batch.set(
          fireStoreInstance
              .collection(CollectionManager.schoolKidsCollection)
              .doc(schoolKidId).collection(CollectionManager.levelsCollection)
              .doc(newLevelId),
          {'levelId': newLevelId}
      );

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
  Future<Either<Failure, void>> editKidData(
      {required KidModel kid})
  async
  {
    try {
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      final batch = fireStoreInstance.batch();

      batch.update(
          fireStoreInstance
             .collection(CollectionManager.kidsCollection)
              .doc(kid.id),
          kid.toJsonUpdate()
      );

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
  Future<Either<Failure, List<SchoolModel>>> getKidData({required String kidId})async
  {
    try
    {
      var fireInstance = FirebaseFirestore.instance;
      var response = await fireInstance
      .collection(CollectionManager.schoolKidsCollection)
      .where('kidId', isEqualTo: kidId).get();
      List<SchoolModel> schools = [];
      await Future.forEach(response.docs, (doc) async
      {
        SchoolKidModel schoolKidModel = SchoolKidModel.fromJson(doc.data());
        var schoolResponse = await fireInstance
        .collection(CollectionManager.schoolsCollection).doc(schoolKidModel.schoolId).get();
        //SchoolModel schoolModel = SchoolModel.fromJson(schoolResponse.data()!);
        var levelsResponse = await fireInstance
            .collection(CollectionManager.schoolKidsCollection).doc(schoolKidModel.id)
            .collection(CollectionManager.levelsCollection).get();

        await Future.forEach(levelsResponse.docs, (level) async
        {
          SchoolModel school = SchoolModel.fromJson(schoolResponse.data()!);
          var levelResponse = await fireInstance
          .collection(CollectionManager.schoolsCollection).doc(schoolKidModel.schoolId)
          .collection(CollectionManager.levelsCollection).doc(level.id).get();
          school.kidLevelModel = LevelModel.fromJson(levelResponse.data()!);
          schools.add(school);
        });
      });
      return right(schools);

    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<KidModel>>> getAllParentKids({required String superParentId}) async
  {
    try {
      var response = await FirebaseFirestore.instance.collection(CollectionManager.kidsCollection)
      .where('superParentId', isEqualTo: superParentId).get();
      if(response.docs.isNotEmpty)
      {
        List<KidModel> kids = [];
        await Future.forEach(response.docs, (kid){
          kids.add(KidModel.fromJson(kid.data()));
        });
        return right(kids);
      }
      else
      {
        return left(DataFailure('You have no kids'));
      }
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, void>> updateParentData(
      {required ParentModel parent}) async
  {
    try {
      await FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
      .doc(parent.id).update(parent.toJsonUpdateData());
      return right(null);
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

static late ParentModel guardianModel;
  @override
  Future<Either<Failure, String>> callUp({required KidModel kid, required SchoolModel schoolModel, required ParentModel parent }) async
  {
    try {
      Position? current = await LocationManager.getCurrentLocation();
      if (
        checkLocation(
          lat1: current!.latitude,
          lon1: current.longitude,
          lon2: schoolModel.long!,
          lat2: schoolModel.lat!
        )
      )
      {
        var parentId = FirebaseAuth.instance.currentUser!.uid;
        CallModel callModel = CallModel(
          kidId: kid.id,
          parentId: parentId,
          superParentId: parentId,
          schoolId: schoolModel.id,
          levelId: schoolModel.kidLevelModel!.id,
          createdAt: Timestamp.fromDate(DateTime.now()),
          parentLat: current.latitude,
          parentLong: current.longitude,
          status: 2
        );
        var verifyResponse = await FirebaseFirestore.instance.collection(CollectionManager.schoolParentsCollection)
            .doc('${schoolModel.id}${callModel.parentId}').get();
        var verifyResponseData = verifyResponse.data()as Map<String, dynamic>;
        // if(!verifyResponseData['isVerified'])
        // {
        //   return left(DataFailure('Sorry, ${schoolModel.name} did not verify your kid join request'));
        // }
        final batch = FirebaseFirestore.instance.batch();
        callModel.id = FirebaseFirestore.instance.collection(CollectionManager.callCollection).doc().id;
        callModel.levelId = schoolModel.kidLevelModel!.id;
        batch.set(
          FirebaseFirestore.instance.collection(CollectionManager.callCollection).doc(callModel.id),
          callModel.toJson()
        );
        await batch.commit();
        await PushNotificationService.sendNotificationToUser(
          deviceToken: schoolModel.fcmToken!,
          title: TranslationKeyManager.pickup.tr,
          body: '${kid.name} ${parent.name}\n${schoolModel.kidLevelModel!.name}'
        );
        return right(callModel.id!);
      }
      else
      {
        return left(DataFailure(TranslationKeyManager.tooFar.tr));
      }
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  bool checkLocation({
    required double lat1,
    required double lon1,
    required double lon2,
    required double lat2,
  })
  {
    return LocationManager.getDistanceFromLatLonInM(lat1: lat1, lon1: lon1, lon2: lon2, lat2: lat2) < 100;
  }






}
