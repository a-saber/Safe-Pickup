import 'package:call_son/core/errors/failures.dart';

abstract class SearchSchoolsState {}

class SearchSchoolsInitial extends SearchSchoolsState {}

class SearchSchoolsLoading extends SearchSchoolsState {}

class SearchSchoolsSuccess extends SearchSchoolsState {}

class SearchSchoolsFailure extends SearchSchoolsState {
  final Failure failure;
  SearchSchoolsFailure({required this.failure});
}