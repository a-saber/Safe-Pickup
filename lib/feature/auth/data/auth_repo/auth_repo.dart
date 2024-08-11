import 'package:call_son/core/models/login_response_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:dartz/dartz.dart';

import 'package:call_son/core/errors/failures.dart';

abstract class AuthRepo
{
  Future<Either<Failure, void>> registerSchool({required SchoolModel schoolModel,});
  Future<Either<Failure, void>> registerSuperParent({required ParentModel parentModel,});
  Future<Either<Failure, LoginResponse>> login( {required String email, required String password});
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> forgetPassword({required String email});
  Future<Either<Failure, SchoolModel>> getSchool();
  Future<Either<Failure, ParentModel>> getParent();
  Future<Either<Failure, LoginResponse>> getUser();
  Future<Either<Failure, List<SchoolModel>>> getSchools();
}

