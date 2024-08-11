import 'package:call_son/core/errors/failures.dart';

abstract class ParentEditKidLevelState {}

class ParentEditKidLevelInitial extends ParentEditKidLevelState {}

class ParentEditKidLevelLoading extends ParentEditKidLevelState {}

class ParentEditKidLevelSuccess extends ParentEditKidLevelState {}

class ParentEditKidLevelFailure extends ParentEditKidLevelState {
  final Failure failure;
  ParentEditKidLevelFailure({required this.failure});
}