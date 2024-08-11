
import 'package:call_son/core/models/parent_model.dart';

abstract class GetNotVerifiedGuardiansState {}

class GetGuardiansInitial extends GetNotVerifiedGuardiansState {}

class GetGuardiansLoading extends GetNotVerifiedGuardiansState {}

class GetGuardiansSuccess extends GetNotVerifiedGuardiansState
{
  List<ParentModel> guardians;
  GetGuardiansSuccess(this.guardians);
}

class GetGuardiansError extends GetNotVerifiedGuardiansState
{
  String error;
  GetGuardiansError(this.error);
}
