part of 'parent_register_cubit.dart';

abstract class ParentRegisterState {}

class ParentRegisterInitial extends ParentRegisterState {}

class ParentRegisterLoading extends ParentRegisterState {}
class ParentRegisterSuccess extends ParentRegisterState {}
class ParentRegisterError extends ParentRegisterState
{
  String error;
  ParentRegisterError(this.error);
}
class ParentRegisterDuplicateError extends ParentRegisterState
{
  String error;
  ParentRegisterDuplicateError(this.error);
}
