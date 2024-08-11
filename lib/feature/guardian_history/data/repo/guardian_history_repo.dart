import 'package:call_son/core/models/call_model.dart';
import 'package:dartz/dartz.dart';
import 'package:call_son/core/errors/failures.dart';


abstract class GuardianHistoryRepo
{
  Future<Either<Failure, CallData>> getCalls();
}