part of 'get_school_levels_cubit.dart';

abstract class GetSchoolLevelsState {}

class GetSchoolLevelsInitial extends GetSchoolLevelsState {}

class GetSchoolLevelsLoading extends GetSchoolLevelsState {}
class GetSchoolLevelsSuccess extends GetSchoolLevelsState
{
  List<LevelModel> levels;
  GetSchoolLevelsSuccess({required this.levels});
}
class GetSchoolLevelsError extends GetSchoolLevelsState
{
  String error;
  GetSchoolLevelsError(this.error);
}

