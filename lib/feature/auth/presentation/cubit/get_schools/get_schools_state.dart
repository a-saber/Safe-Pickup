

import 'package:call_son/core/models/school_model.dart';

abstract class GetSchoolsState {}

class GetSchoolsInitial extends GetSchoolsState {}

class GetSchoolsLoading extends GetSchoolsState {}
class GetSchoolsSuccess extends GetSchoolsState
{
  List<SchoolModel> schools;
  GetSchoolsSuccess(this.schools);
}
class GetSchoolsError extends GetSchoolsState
{
  String error;
  GetSchoolsError(this.error);
}
