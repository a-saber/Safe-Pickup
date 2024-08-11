import 'package:call_son/core/errors/failures.dart';

abstract class AddKidState {}

class AddKidInitial extends AddKidState {}

class AddKidLoading extends AddKidState {}

class AddKidSuccess extends AddKidState {}

class AddKidFailure extends AddKidState {
  final Failure failure;
  AddKidFailure({required this.failure});
}