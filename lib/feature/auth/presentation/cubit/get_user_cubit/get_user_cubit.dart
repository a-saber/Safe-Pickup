import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_user_state.dart';


class GetUserCubit extends Cubit<GetUserState> {
  final AuthRepoImplementation userAuthRepoImp;
  static GetUserCubit get(context) => BlocProvider.of(context);
  GetUserCubit(this.userAuthRepoImp) : super(GetUserInitial());

  void getUser() async {
    emit(GetUserLoading());
    final result = await userAuthRepoImp.getUser();
    result.fold((l) => emit(GetUserFailure(failure: l)),
            (r) => emit(GetUserSuccess(loginModel: r)));
  }

}