import 'package:call_son/core/errors/failures.dart';

abstract class AddKidLevelState {}

class AddKidLevelInitial extends AddKidLevelState {}

class AddKidLevelLoading extends AddKidLevelState {}

class AddKidLevelSuccess extends AddKidLevelState {}

class AddKidLevelFailure extends AddKidLevelState {
  final Failure failure;
  AddKidLevelFailure({required this.failure});
}