
import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/login_response_model.dart';
abstract class LoginState {}

class SchoolLoginInitial extends LoginState {}

class SchoolLoginLoading extends LoginState {}

class SchoolLoginSuccess extends LoginState {
  LoginResponse loginResponse;
  SchoolLoginSuccess({required this.loginResponse});
}

class SchoolLoginFailure extends LoginState {
  Failure failure;
  SchoolLoginFailure({required this.failure});
}