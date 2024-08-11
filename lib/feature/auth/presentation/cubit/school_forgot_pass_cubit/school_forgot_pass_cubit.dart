import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'school_forgot_pass_state.dart';

class SchoolForgetPassCubit extends Cubit<SchoolForgetPassState> {
  final AuthRepoImplementation schoolAuthRepoImp;
  static SchoolForgetPassCubit get(context) => BlocProvider.of(context);

  SchoolForgetPassCubit(this.schoolAuthRepoImp) : super(SchoolForgetPassInitial());

  void forgotPass({required String email}) async {
    emit(SchoolForgetPassLoading());
    final result = await schoolAuthRepoImp.forgetPassword(email: email);
    result.fold((l) => emit(SchoolForgetPassFailure(failure: l)),
            (r) => emit(SchoolForgetPassSuccess()));
  }
}