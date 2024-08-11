import 'package:call_son/core/errors/failures.dart';

abstract class GetAllSchoolsState {}

class GetAllSchoolsInitial extends GetAllSchoolsState {}

class GetAllSchoolsLoading extends GetAllSchoolsState {}

class GetAllSchoolsSuccess extends GetAllSchoolsState {}

class GetAllSchoolsFailure extends GetAllSchoolsState {
  final Failure failure;
  GetAllSchoolsFailure({required this.failure});
}