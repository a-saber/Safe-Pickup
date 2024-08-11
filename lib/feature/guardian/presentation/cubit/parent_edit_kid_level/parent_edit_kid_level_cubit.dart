import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'parent_edit_kid_level_state.dart';

class ParentEditKidLevelCubit extends Cubit<ParentEditKidLevelState> {
  ParentEditKidLevelCubit(this.parentRepoImp)
      : super(ParentEditKidLevelInitial());
  final GuardianRepoImplementation parentRepoImp;

  static ParentEditKidLevelCubit get(context) => BlocProvider.of(context);

  void editKidLevelCubit({
    required String kidId,
    required String schoolId,
    required String oldLevelId,
    required String newLevelId,
  }) async {
    emit(ParentEditKidLevelLoading());
    var response = await parentRepoImp.editKidLevel(
        kidId: kidId,
        schoolId: schoolId,
        oldLevelId: oldLevelId,
        newLevelId: newLevelId);
    response.fold((failure) {
      emit(ParentEditKidLevelFailure(failure: failure));
    }, (result) async {
      emit(ParentEditKidLevelSuccess());
    });
  }
}
