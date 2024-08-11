
import 'package:call_son/core/errors/failures.dart';

abstract class GetNearBySchoolsState {}

class GetNearBySchoolsInitial extends GetNearBySchoolsState {}

class GetNearBySchoolsLoading extends GetNearBySchoolsState {}

class GetNearBySchoolsSuccess extends GetNearBySchoolsState {}

class GetNearBySchoolsFailure extends GetNearBySchoolsState {
  final Failure failure;
  GetNearBySchoolsFailure({required this.failure});
}