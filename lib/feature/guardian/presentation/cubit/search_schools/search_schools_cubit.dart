import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_schools_state.dart';

class SearchSchoolsCubit extends Cubit<SearchSchoolsState> {
  SearchSchoolsCubit(this.parentRepoImp)
      : super(SearchSchoolsInitial());
  final GuardianRepoImplementation parentRepoImp;

  static SearchSchoolsCubit get(context) => BlocProvider.of(context);

  List<SchoolModel> schools = [];

  void init() {
    emit(SearchSchoolsInitial());
  }
  void searchSchools({required String schoolName}) async {
    emit(SearchSchoolsLoading());
    var response = await parentRepoImp.searchSchools(schoolName: schoolName);
    response.fold((failure) {
      emit(SearchSchoolsFailure(failure: failure));
    }, (result) async {
      schools = result;
      emit(SearchSchoolsSuccess());
    });
  }
}
