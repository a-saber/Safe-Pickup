
import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/login_response_model.dart';

abstract class GetUserState {}

class GetUserInitial extends GetUserState {}

class GetUserLoading extends GetUserState {}

class GetUserSuccess extends GetUserState {
  LoginResponse loginModel;
  GetUserSuccess({required this.loginModel});
}

class GetUserFailure extends GetUserState {
  Failure failure;
  GetUserFailure({required this.failure});
}