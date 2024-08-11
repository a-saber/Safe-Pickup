import 'package:call_son/core/errors/failures.dart';

abstract class DeleteKidLevelState {}

class DeleteKidLevelInitial extends DeleteKidLevelState {}

class DeleteKidLevelLoading extends DeleteKidLevelState {}

class DeleteKidLevelSuccess extends DeleteKidLevelState {}

class DeleteKidLevelFailure extends DeleteKidLevelState {
  final Failure failure;
  DeleteKidLevelFailure({required this.failure});
}