import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:dartz/dartz.dart';

import 'package:call_son/core/errors/failures.dart';

abstract class SchoolRepo
{
  Future<Either<Failure, void>> updateData({required SchoolModel schoolModel,});

  Future<Either<Failure, void>> updateLocationData({required SchoolModel schoolModel,});

  Future<Either<Failure, void>> editLevels({required List<LevelModel> levels,});

  Future<Either<Failure, List<LevelModel>>> getLevels();

  Future<Either<Failure, List<ParentModel>>> getVerifiedGuardians();

  Future<Either<Failure, List<ParentModel>>> getNotVerifiedGuardians();

  Future<Either<Failure, void>> changeGuardianVerification({
    required String guardianId,
    required bool isVerify,
  });

  Future<Either<Failure, bool>> changeCallStatus({
    required String callId,
    required bool accepted,
    String? reply
  });

  Future<Either<Failure, CallData>> getCalls();


}