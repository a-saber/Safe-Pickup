import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_schools_state.dart';


class GetSchoolsCubit extends Cubit<GetSchoolsState> {
  GetSchoolsCubit(this.authRepo) : super(GetSchoolsInitial());
  final AuthRepoImplementation authRepo;
  static GetSchoolsCubit get(context) => BlocProvider.of(context);

  Future<void> getSchools() async
  {
    emit(GetSchoolsLoading());

    var response = await authRepo.getSchools();
    response.fold((failure)
    {
      emit(GetSchoolsError(failure.errorMessage));
    }, (result) async
    {
      emit(GetSchoolsSuccess(result));
    }
    );
  }
}
