import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logout_state.dart';



class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepoImplementation authRepoImp;
  static LogoutCubit get(context) => BlocProvider.of(context);

  LogoutCubit(this.authRepoImp) : super(LogoutInitial());

  void logout () async {
    emit(LogoutLoading());
    final result = await authRepoImp.logout();
    result.fold((l) => emit(LogoutFailure(failure: l)), (r) =>
        emit(LogoutSuccess()));
  }
}