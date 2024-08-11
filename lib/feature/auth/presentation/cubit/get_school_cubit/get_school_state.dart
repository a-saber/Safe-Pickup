
import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/school_model.dart';

abstract class GetSchoolState {}

class GetSchoolInitial extends GetSchoolState {}

class GetSchoolLoading extends GetSchoolState {}

class GetSchoolSuccess extends GetSchoolState {
  SchoolModel schoolModel;
  GetSchoolSuccess({required this.schoolModel});
}

class GetSchoolFailure extends GetSchoolState {
  Failure failure;
  GetSchoolFailure({required this.failure});
}