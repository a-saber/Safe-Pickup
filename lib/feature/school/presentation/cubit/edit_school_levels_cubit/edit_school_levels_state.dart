part of 'edit_school_levels_cubit.dart';

abstract class EditSchoolLevelsState {}

class EditSchoolLevelsInitial extends EditSchoolLevelsState {}

class EditSchoolLevelsLoading extends EditSchoolLevelsState {}
class EditSchoolLevelsSuccess extends EditSchoolLevelsState {}
class EditSchoolLevelsError extends EditSchoolLevelsState
{
  String error;
  EditSchoolLevelsError(this.error);
}

