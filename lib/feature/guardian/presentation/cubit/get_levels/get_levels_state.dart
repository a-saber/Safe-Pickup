import 'package:call_son/core/errors/failures.dart';

abstract class GetLevelsState {}

class GetLevelsInitial extends GetLevelsState {}

class GetLevelsLoading extends GetLevelsState {}

class GetLevelsSuccess extends GetLevelsState {}

class GetLevelsFailure extends GetLevelsState {
  final Failure failure;
  GetLevelsFailure({required this.failure});
}