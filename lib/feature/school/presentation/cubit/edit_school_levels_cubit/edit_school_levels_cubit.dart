import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/school/data/repo/school_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'edit_school_levels_state.dart';

class EditSchoolLevelsCubit extends Cubit<EditSchoolLevelsState> {
  EditSchoolLevelsCubit(this.schoolRepoImp) : super(EditSchoolLevelsInitial());
  final SchoolRepoImplementation schoolRepoImp;
  static EditSchoolLevelsCubit get(context) => BlocProvider.of(context);

  void editLevels({required List<LevelModel> levels}) async
  {
    emit(EditSchoolLevelsLoading());
    var response = await schoolRepoImp.editLevels(
      levels: levels,
    );
    response.fold((failure)
    {
      emit(EditSchoolLevelsError(failure.errorMessage));
    }, (result) async
    {
      emit(EditSchoolLevelsSuccess());
    }
    );
  }
}
