import 'package:call_son/core/errors/failures.dart';

abstract class EditKidState {}

class EditKidInitial extends EditKidState {}

class EditKidLoading extends EditKidState {}

class EditKidSuccess extends EditKidState {}

class EditKidFailure extends EditKidState {
  final Failure failure;
  EditKidFailure({required this.failure});
}