import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_school_state.dart';


class GetSchoolCubit extends Cubit<GetSchoolState> {
  final AuthRepoImplementation schoolAuthRepoImp;
  static GetSchoolCubit get(context) => BlocProvider.of(context);
  GetSchoolCubit(this.schoolAuthRepoImp) : super(GetSchoolInitial());

  SchoolModel? schoolModel;
  void getSchool() async {
    emit(GetSchoolLoading());
    final result = await schoolAuthRepoImp.getSchool();
    result.fold((l) => emit(GetSchoolFailure(failure: l)),
            (r) {schoolModel = r; emit(GetSchoolSuccess(schoolModel: r));});
  }

  void assignSchool({required Map<String, dynamic> json}) async {
    emit(GetSchoolLoading());
    try {
      schoolModel = SchoolModel.fromJson(json);
      emit(GetSchoolSuccess(schoolModel: schoolModel!));
    }
    catch(e)
    {
      emit(GetSchoolFailure(failure: DataFailure(e.toString())));
    }
  }
}