
import 'package:call_son/core/errors/failures.dart';

abstract class SchoolForgetPassState {}

class SchoolForgetPassInitial extends SchoolForgetPassState {}

class SchoolForgetPassLoading extends SchoolForgetPassState {}

class SchoolForgetPassSuccess extends SchoolForgetPassState {}

class SchoolForgetPassFailure extends SchoolForgetPassState {
  Failure failure;
  SchoolForgetPassFailure({required this.failure});
}