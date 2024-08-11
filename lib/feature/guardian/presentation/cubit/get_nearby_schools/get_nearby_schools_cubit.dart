import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_nearby_schools_state.dart';

class GetNearBySchoolsCubit extends Cubit<GetNearBySchoolsState> {
  GetNearBySchoolsCubit(this.parentRepoImp)
      : super(GetNearBySchoolsInitial());
  final GuardianRepoImplementation parentRepoImp;

  static GetNearBySchoolsCubit get(context) => BlocProvider.of(context);

  List<SchoolModel> schools = [];

  void getNearBySchools(context, {required double distanceInKm}) async {
    emit(GetNearBySchoolsLoading());
    var response = await parentRepoImp.getNearBySchools(context, distanceInKm: distanceInKm);
    response.fold((failure) {
      emit(GetNearBySchoolsFailure(failure: failure));
    }, (result) async {
      schools = result;
      emit(GetNearBySchoolsSuccess());
    });
  }
}
