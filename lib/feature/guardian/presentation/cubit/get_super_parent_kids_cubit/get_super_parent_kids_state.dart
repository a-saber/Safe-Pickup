

abstract class GetAllParentKidsState {}

class GetAllParentKidsInitial extends GetAllParentKidsState {}

class GetAllParentKidsLoading extends GetAllParentKidsState {}
class GetAllParentKidsSuccess extends GetAllParentKidsState
{}
class GetAllParentKidsError extends GetAllParentKidsState
{
  String error;
  GetAllParentKidsError(this.error);
}

