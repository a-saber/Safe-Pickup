part of 'update_school_data_cubit.dart';

abstract class UpdateSchoolState {}

class UpdateSchoolInitial extends UpdateSchoolState {}

class UpdateSchoolLoading extends UpdateSchoolState {}
class UpdateSchoolSuccess extends UpdateSchoolState {}
class UpdateSchoolError extends UpdateSchoolState
{
  String error;
  UpdateSchoolError(this.error);
}

