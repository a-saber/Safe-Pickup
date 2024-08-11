part of 'school_register_cubit.dart';

abstract class SchoolRegisterState {}

class SchoolRegisterInitial extends SchoolRegisterState {}

class SchoolRegisterLoading extends SchoolRegisterState {}
class SchoolRegisterSuccess extends SchoolRegisterState {}
class SchoolRegisterError extends SchoolRegisterState
{
  String error;
  SchoolRegisterError(this.error);
}

