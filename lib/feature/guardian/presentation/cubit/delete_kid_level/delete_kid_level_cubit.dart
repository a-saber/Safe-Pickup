import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delete_kid_level_state.dart';

class DeleteKidLevelCubit extends Cubit<DeleteKidLevelState> {
  DeleteKidLevelCubit(this.parentRepoImp)
      : super(DeleteKidLevelInitial());
  final GuardianRepoImplementation parentRepoImp;

  static DeleteKidLevelCubit get(context) => BlocProvider.of(context);

  void deleteKidLevel({   required String kidId,   required String schoolId,   required String levelId, }) async {
    emit(DeleteKidLevelLoading());
    var response = await parentRepoImp.deleteKidSchoolLevel(kidId: kidId, schoolId: schoolId, levelId: levelId);
    response.fold((failure) {
      emit(DeleteKidLevelFailure(failure: failure));
    }, (result) async {
      emit(DeleteKidLevelSuccess());
    });
  }
}
