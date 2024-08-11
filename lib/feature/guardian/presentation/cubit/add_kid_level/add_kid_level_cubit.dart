import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_kid_level_state.dart';

class AddKidLevelCubit extends Cubit<AddKidLevelState> {
  AddKidLevelCubit(this.parentRepoImp)
      : super(AddKidLevelInitial());
  final GuardianRepoImplementation parentRepoImp;

  static AddKidLevelCubit get(context) => BlocProvider.of(context);

  void addKidLevel({   required String kidId,   required String schoolId,   required String levelId, }) async {
    emit(AddKidLevelLoading());
    var response = await parentRepoImp.addKidSchoolLevel(kidId: kidId, schoolId: schoolId, levelId: levelId);
    response.fold((failure) {
      emit(AddKidLevelFailure(failure: failure));
    }, (result) async {
      emit(AddKidLevelSuccess());
    });
  }
}
