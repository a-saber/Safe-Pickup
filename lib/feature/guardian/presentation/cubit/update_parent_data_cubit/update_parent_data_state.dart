
abstract class UpdateParentState {}

class UpdateParentInitial extends UpdateParentState {}

class UpdateParentLoading extends UpdateParentState {}
class UpdateParentSuccess extends UpdateParentState {}
class UpdateParentError extends UpdateParentState
{
  String error;
  UpdateParentError(this.error);
}

