import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_levels_state.dart';

class GetLevelsCubit extends Cubit<GetLevelsState> {
  GetLevelsCubit(this.parentRepoImp)
      : super(GetLevelsInitial());
  final GuardianRepoImplementation parentRepoImp;

  static GetLevelsCubit get(context) => BlocProvider.of(context);

  List<LevelModel> levels = [];

  void getLevels({required String schoolId}) async {
    emit(GetLevelsLoading());
    var response = await parentRepoImp.getLevels(schoolId: schoolId);
    response.fold((failure) {
      emit(GetLevelsFailure(failure: failure));
    }, (result) async {
      levels = result;
      emit(GetLevelsSuccess());
    });
  }
}
