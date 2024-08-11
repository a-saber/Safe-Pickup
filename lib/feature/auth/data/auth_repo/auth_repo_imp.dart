import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/login_response_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_kid_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/models/school_parent_verify_model.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/shared_functions/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repo.dart';


class AuthRepoImplementation extends AuthRepo {

  @override
  Future<Either<Failure, void>> registerSchool({
    required SchoolModel schoolModel,
  }) async {
    try {
      // Firebase Auth Create User
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: schoolModel.email!,
        password: schoolModel.password!,
      );

      // Assign User ID
      schoolModel.id = response.user!.uid;

      // Send Email Verification
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // Upload Image if exists
      if(schoolModel.image != null) {
        var responseURL = await FirebaseManager.uploadImage(image: schoolModel.image!);
        responseURL.fold((l) {return left(l);}, (r) {schoolModel.imagePath = r;});
      }

      // Save Account Data
      final batch = FirebaseFirestore.instance.batch();

      // Save School Data
      batch.set(
          FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
              .doc(schoolModel.id),
          schoolModel.toJsonRegister()
      );

      // Save Levels Data
      for (var element in schoolModel.levels) {
        var levelDoc = FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
            .doc(schoolModel.id).collection(CollectionManager.levelsCollection).doc();
        element.id = levelDoc.id;
        batch.set(
            levelDoc,
            element.toJson()
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

  // @override
  // Future<Either<Failure, void>> registerSuperParent
  //     ({required ParentModel parentModel}) async
  // {
  //   try {
  //     FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
  //
  //     // Firebase Auth Create User
  //     var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: parentModel.email!,
  //       password: parentModel.password!,
  //     );
  //
  //     // Assign User ID
  //     parentModel.id = response.user!.uid;
  //
  //     // Send Email Verification
  //     await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  //
  //     // Save Account Data
  //     final batch = fireStoreInstance.batch();
  //
  //     // Save Parent Data
  //     parentModel.fullAccess = true;
  //     parentModel.isSuperParent = true;
  //     parentModel.superParentId = parentModel.id;
  //     batch.set(
  //         fireStoreInstance.collection(CollectionManager.parentsCollection)
  //           .doc(parentModel.id),
  //         parentModel.toJson()
  //     );
  //
  //     Future.forEach(parentModel.kidsModels, (kid)
  //     {
  //       kid.name = kid.nameController.text;
  //       kid.id = fireStoreInstance.collection(CollectionManager.kidsCollection).doc().id;
  //       kid.superParentId = parentModel.id;
  //       batch.set(
  //           fireStoreInstance.collection(CollectionManager.kidsCollection)
  //               .doc(kid.id),
  //           kid.toJson()
  //       );
  //       Future.forEach(kid.schools, (school)async
  //       {
  //         SchoolKidModel schoolKidModel = SchoolKidModel(
  //           id: '${school.id}${kid.id}',
  //           schoolId: school.id,
  //           kidId: kid.id,
  //           verified: false
  //         );
  //
  //
  //         var schoolCheckExist = await fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
  //             .doc(schoolKidModel.id).get();
  //         if(!schoolCheckExist.exists)
  //         {
  //           batch.set(
  //               fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
  //                   .doc(schoolKidModel.id),
  //               schoolKidModel.toJson()
  //           );
  //         }
  //         var levelCheckExist = await fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
  //             .doc(schoolKidModel.id).collection(CollectionManager.levelsCollection)
  //             .doc(school.kidLevelModel!.id).get();
  //         if(!levelCheckExist.exists)
  //         {
  //           batch.set(
  //               fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
  //                   .doc(schoolKidModel.id).collection(CollectionManager.levelsCollection)
  //                   .doc(school.kidLevelModel!.id),
  //               {'levelId': school.kidLevelModel!.id}
  //           );
  //         }
  //
  //         SchoolParentVerifyModel schoolParentVerifyModel = SchoolParentVerifyModel(
  //             id: fireStoreInstance.collection(CollectionManager.schoolParentVerifyCollection).doc().id,
  //             schoolId: school.id,
  //             superParentId: parentModel.id,
  //             kidId: kid.id,
  //             isVerified: false
  //         );
  //         batch.set(
  //           fireStoreInstance.collection(CollectionManager.schoolParentVerifyCollection).doc(schoolParentVerifyModel.id),
  //           schoolParentVerifyModel.toJson()
  //         );
  //       });
  //     });
  //     await batch.commit();
  //     return right(null);
  //   } catch (e) {
  //     print(e.toString());
  //     if (e is FirebaseAuthException) {
  //       return left(FirebaseFailure.fromFirebaseAuthException(e));
  //     }
  //     return left(FirebaseFailure(e.toString()));
  //   }
  // }
  @override
  Future<Either<Failure, void>> registerSuperParent({required ParentModel parentModel}) async {
    try {
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;

      // Firebase Auth Create User
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: parentModel.email!,
        password: parentModel.password!,
      );

      // Assign User ID
      parentModel.id = response.user!.uid;

      // Send Email Verification
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // Save Account Data
      final batch = fireStoreInstance.batch();

      // Save Parent Data
      parentModel.fullAccess = true;
      parentModel.isSuperParent = true;
      parentModel.superParentId = parentModel.id;
      batch.set(
          fireStoreInstance.collection(CollectionManager.parentsCollection)
              .doc(parentModel.id),
          parentModel.toJson()
      );

      for (var kid in parentModel.kidsModels) {
        kid.name = kid.nameController.text;
        kid.id = fireStoreInstance.collection(CollectionManager.kidsCollection).doc().id;
        kid.superParentId = parentModel.id;
        batch.set(
            fireStoreInstance.collection(CollectionManager.kidsCollection)
                .doc(kid.id),
            kid.toJson()
        );

        for (var school in kid.schools)  {
          SchoolKidModel schoolKidModel = SchoolKidModel(
              id: '${school.id}${kid.id}',
              schoolId: school.id,
              kidId: kid.id,
              verified: false
          );

          var schoolCheckExist = await fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
              .doc(schoolKidModel.id).get();
          if (!schoolCheckExist.exists) {
            batch.set(
                fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
                    .doc(schoolKidModel.id),
                schoolKidModel.toJson()
            );
          }

          var levelCheckExist = await fireStoreInstance.collection(CollectionManager.schoolKidsCollection)
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
              id: '${school.id}${parentModel.id}',
              schoolId: school.id,
              superParentId: parentModel.id,
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
  Future<Either<Failure, LoginResponse>> login({required String email, required String password}) async
  {
    try {
      var loginResponse = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        return left(DataFailure("Please Verify Your Email First\nPlease Check Your Email"));
      }

      var schoolResponse = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection)
          .doc(loginResponse.user!.uid)
          .get();
      
      if(schoolResponse.exists)
      {
        return right(LoginResponse(isSchool: true, json: schoolResponse.data()!));
      }
      else
      {
        var parentResponse = await FirebaseFirestore.instance
            .collection(CollectionManager.parentsCollection)
            .doc(loginResponse.user!.uid)
            .get();
        if(parentResponse.exists)
        {
          return right(LoginResponse(isSchool: false, json: parentResponse.data()!));
        }
        else
        {
          return left(DataFailure('Sorry Something Went Wrong'));
        }
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
  Future<Either<Failure, void>> forgetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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
  Future<Either<Failure, SchoolModel>> getSchool() async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      return right(SchoolModel.fromJson(response.data()!));
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ParentModel>> getParent() async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionManager.parentsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      return right(ParentModel.fromJson(response.data()!));
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        return left(FirebaseFailure.fromFirebaseAuthException(e));
      }
      return left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> getUser() async {
    try {
      var response = await FirebaseFirestore.instance
          .collection(CollectionManager.schoolsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if(response.exists)
      {
        return right(LoginResponse(isSchool: true, json: response.data()!));
      }
      else
      {
        var parentResponse = await FirebaseFirestore.instance
            .collection(CollectionManager.parentsCollection)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if(parentResponse.exists)
        {
          return right(LoginResponse(isSchool: false, json: parentResponse.data()!));
        }
        else
        {
          return left(DataFailure('Account Not Found'));
        }
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
  Future<Either<Failure, void>> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
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
            SchoolModel schoolModel = SchoolModel.fromJson(element.data());
            var levelsResponse = await FirebaseFirestore.instance
                .collection(CollectionManager.schoolsCollection).doc(schoolModel.id)
                .collection(CollectionManager.levelsCollection).get();
            await Future.forEach(levelsResponse.docs, (levelMap)
            {
              LevelModel levelModel = LevelModel.fromJson(levelMap.data());
              levelModel.id = levelMap.id;
              schoolModel.levels.add(levelModel);
            });
            schools.add(schoolModel);
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


}
