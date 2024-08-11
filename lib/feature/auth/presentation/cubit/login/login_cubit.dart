import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final AuthRepoImplementation schoolAuthRepoImp;
  static LoginCubit get(context) => BlocProvider.of(context);

  LoginCubit(this.schoolAuthRepoImp) : super(SchoolLoginInitial());
  void login({required String email, required String password}) async {
    emit(SchoolLoginLoading());
    final result = await schoolAuthRepoImp.login(email: email, password: password);
    result.fold((l) => emit(SchoolLoginFailure(failure: l)),
            (r) => emit(SchoolLoginSuccess(loginResponse: r)));
  }
}