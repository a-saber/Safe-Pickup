
import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/parent_model.dart';

abstract class GetParentState {}

class GetParentInitial extends GetParentState {}

class GetParentLoading extends GetParentState {}

class GetParentSuccess extends GetParentState {
  ParentModel parentModel;
  GetParentSuccess({required this.parentModel});
}

class GetParentFailure extends GetParentState {
  Failure failure;
  GetParentFailure({required this.failure});
}