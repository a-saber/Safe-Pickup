import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_all_schools_state.dart';

class GetAllSchoolsCubit extends Cubit<GetAllSchoolsState> {
  GetAllSchoolsCubit(this.parentRepoImp)
      : super(GetAllSchoolsInitial());
  final GuardianRepoImplementation parentRepoImp;

  static GetAllSchoolsCubit get(context) => BlocProvider.of(context);

  List<SchoolModel> schools = [];

  void getAllSchools() async {
    emit(GetAllSchoolsLoading());
    var response = await parentRepoImp.getSchools();
    response.fold((failure) {
      emit(GetAllSchoolsFailure(failure: failure));
    }, (result) async {
      schools = result;
      emit(GetAllSchoolsSuccess());
    });
  }
}
