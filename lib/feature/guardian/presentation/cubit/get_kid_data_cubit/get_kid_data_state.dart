
import 'package:call_son/core/models/school_model.dart';

abstract class GetKidDataState {}

class GetKidDataInitial extends GetKidDataState {}

class GetKidDataLoading extends GetKidDataState {}
class GetKidDataSuccess extends GetKidDataState{}
class GetKidDataError extends GetKidDataState
{
  String error;
  GetKidDataError(this.error);
}

