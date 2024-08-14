import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:dartz/dartz.dart';
import 'package:call_son/core/errors/failures.dart';

abstract class GuardianRepo {
  Future<Either<Failure, void>> updateParentData({required ParentModel parent});

  Future<Either<Failure, List<KidModel>>> getAllParentKids(
      {required String superParentId});

  Future<Either<Failure, List<SchoolModel>>> getKidData(
      {required String kidId});

  Future<Either<Failure, List<LevelModel>>> getLevels(
      {required String schoolId});

  Future<Either<Failure, List<SchoolModel>>> getSchools();

  Future<Either<Failure, List<SchoolModel>>> searchSchools({required String schoolName});

  Future<Either<Failure, List<SchoolModel>>> getNearBySchools(context, {required double distanceInKm});

  Future<Either<Failure, void>> editKidLevel(
  {
    required String kidId,
    required String schoolId,
    required String oldLevelId,
    required String newLevelId
  });

  Future<Either<Failure, void>> editKidData(
  {
    required KidModel kid
  });

  Future<Either<Failure, void>> deleteKidSchoolLevel(
  {
    required String kidId,
    required String schoolId,
    required String levelId,
  });

  Future<Either<Failure, void>> addKidSchoolLevel(
  {
    required String kidId,
    required String schoolId,
    required String levelId,
  });

  Future<Either<Failure, void>> newKid(
  {
    required KidModel kid
  });


  Future<Either<Failure, String>> callUp(
      {required String kidId, required SchoolModel schoolModel});
}
